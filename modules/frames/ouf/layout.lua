local _, ns = ...
local oUF = ns.oUF;

local _, playerClass = UnitClass('player')

local TEXTURE = [[Interface\ChatFrame\ChatFrameBackground]]
local BACKDROP = {
	bgFile = TEXTURE,
	insets = {top = -1, bottom = -1, left = -1, right = -1}
}

local DEAD_TEXTURE = [[|TInterface\RaidFrame\Raid-Icon-DebuffDisease:26|t ]]
local GLOW = {
	edgeFile = [[Interface\AddOns\oUF_ImprovedBlizzardUI\assets\glow]], edgeSize = 3
}

local function PostUpdatePower(element, unit, cur, min, max)
	local shouldShow = max ~= 0
	element.__owner.Health:SetHeight(shouldShow and 20 or 22)
	element:SetShown(shouldShow)
end

local function UpdateGroupPower(self, event, unit)
	if(unit ~= self.unit) then
		return
	end

	local element = self.Power
	local visibility = false

	if(UnitIsConnected(unit) and not UnitHasVehicleUI(unit)) then
		local role = UnitGroupRolesAssigned(unit)
		visibility = role == 'HEALER' and UnitPowerType(unit) == Enum.PowerType.Mana
	end

	if(visibility) then
		element:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Mana))
		element:SetValue(UnitPower(unit, Enum.PowerType.Mana))
	end

	element:SetShown(visibility)
end

local function UpdateHealth(self, event, unit)
	if(not unit or self.unit ~= unit) then
		return
	end

	local element = self.Health
	element:SetShown(UnitIsConnected(unit))

	if(element:IsShown()) then
		local cur = UnitHealth(unit)
		local max = UnitHealthMax(unit)
		element:SetMinMaxValues(0, max)
		element:SetValue(max - cur)
	end
end

local function UpdateSummon(self, event)
	local element = self.SummonIndicator
	local icon = element.Icon

	local status = C_IncomingSummon.IncomingSummonStatus(self.unit)
	if(status == Enum.SummonStatus.None) then
		element:Hide()
	else
		element:Show()

		if(status == Enum.SummonStatus.Pending) then
			icon:SetVertexColor(1, 1, 1)
			icon:SetDesaturated(false)
			element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_PENDING
		elseif(status == Enum.SummonStatus.Accepted) then
			icon:SetVertexColor(0, 1, 0)
			icon:SetDesaturated(true)
			element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_ACCEPTED
		elseif(status == Enum.SummonStatus.Declined) then
			icon:SetVertexColor(1, 0.3, 0.3)
			icon:SetDesaturated(true)
			element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_DECLINED
		end
	end
end

local function OnSummonEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
	GameTooltip:SetText(self.tooltip)
	GameTooltip:Show()
end

local function PostUpdatePortrait(element, unit)
	element:SetModelAlpha(0.1)
	-- element:SetDesaturation(1)
end

local function PostUpdateCast(element, unit)
	local Spark = element.Spark
	if(not element.notInterruptible and UnitCanAttack('player', unit)) then
		Spark:SetVertexColor(1, 0, 0)
	else
		Spark:SetVertexColor(1, 1, 1)
	end
end

local function PostUpdateTotem(element)
	local shown = {}
	for index = 1, MAX_TOTEMS do
		local Totem = element[index]
		if(Totem:IsShown()) then
			local prevShown = shown[#shown]

			Totem:ClearAllPoints()
			Totem:SetPoint('TOPLEFT', shown[#shown] or element.__owner, 'TOPRIGHT', 4, 0)
			table.insert(shown, Totem)
		end
	end
end

local function PostUpdateClassPower(element, cur, max, diff, powerType)
	if(diff) then
		for index = 1, max do
			local Bar = element[index]
			if(max == 3) then
				Bar:SetWidth(74)
			elseif(max == 4) then
				Bar:SetWidth(index > 2 and 55 or 54)
			elseif(max == 5 or max == 10) then
				Bar:SetWidth((index == 1 or index == 6) and 42 or 43)
			elseif(max == 6) then
				Bar:SetWidth(35)
			end

			if(max == 10) then
				-- Rogue anticipation talent, align >5 on top of the first 5
				if(index == 6) then
					Bar:ClearAllPoints()
					Bar:SetPoint('LEFT', element[index - 5])
				end
			else
				if(index > 1) then
					Bar:ClearAllPoints()
					Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', 4, 0)
				end
			end
		end
	end
end

local function UpdateClassPowerColor(element)
	local r, g, b = 1, 1, 2/5
	if(not UnitHasVehicleUI('player')) then
		if(playerClass == 'MONK') then
			r, g, b = 0, 4/5, 3/5
		elseif(playerClass == 'WARLOCK') then
			r, g, b = 2/3, 1/3, 2/3
		elseif(playerClass == 'PALADIN') then
			r, g, b = 1, 1, 2/5
		elseif(playerClass == 'MAGE') then
			r, g, b = 5/6, 1/2, 5/6
		end
	end

	for index = 1, #element do
		local Bar = element[index]
		Bar:SetStatusBarColor(r, g, b)
		Bar.bg:SetColorTexture(r * 1/3, g * 1/3, b * 1/3)
	end
end

local function UpdateExperienceColor(element, isHonor)
	local colors = element.__owner.colors
	if(isHonor) then
		colors = colors.honor
		element:SetStatusBarColor(unpack(colors[1]))
		element:SetAnimatedTextureColors(unpack(colors[1]))
	else
		colors = colors.experience
		element:SetStatusBarColor(unpack(colors[1]))
		element:SetAnimatedTextureColors(unpack(colors[1]))
		element.Rested:SetStatusBarColor(unpack(colors[2]))
	end
end

local function UpdateThreat(self, event, unit)
	if(unit ~= self.unit) then
		return
	end

	local situation = UnitThreatSituation(unit)
	if(situation and situation > 0) then
		local r, g, b = GetThreatStatusColor(situation)
		self.ThreatIndicator:SetBackdropBorderColor(r, g, b, 1)
	else
		self.ThreatIndicator:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

local function UpdateAura(self, elapsed)
	if(self.expiration) then
		self.expiration = math.max(self.expiration - elapsed, 0)

		if(self.expiration > 0 and self.expiration < 60) then
			self.Duration:SetFormattedText('%d', self.expiration)
		else
			self.Duration:SetText()
		end
	end
end

local function OnAuraEnter(self)
	if(not self:IsVisible()) then
		return
	end

	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
	self:UpdateTooltip()
end

local function PostCreateAura(element, button)
	Mixin(button, BackdropTemplateMixin)

	button:SetBackdrop(BACKDROP)
	button:SetBackdropColor(0, 0, 0)
	button.cd:SetReverse(true)
	button.cd:SetHideCountdownNumbers(true)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
	button:SetScript('OnEnter', OnAuraEnter)

	-- We create a parent for aura strings so that they appear over the cooldown widget
	local StringParent = CreateFrame('Frame', nil, button)
	StringParent:SetFrameLevel(20)

	button.count:SetParent(StringParent)
	button.count:ClearAllPoints()
	button.count:SetPoint('BOTTOMRIGHT', button, 2, 1)
	button.count:SetFontObject('GameFontNormal')

	local Duration = StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	Duration:SetPoint('TOPLEFT', button, 0, -1)
	button.Duration = Duration

	button:HookScript('OnUpdate', UpdateAura)
end

local function PostUpdateBuff(element, unit, button, index)
	local _, _, _, _, duration, expiration, owner, canStealOrPurge = UnitAura(unit, index, button.filter)
	if(duration and duration > 0) then
		button.expiration = expiration - GetTime()
	else
		button.expiration = math.huge
	end

	if(unit == 'target' and canStealOrPurge) then
		button:SetBackdropColor(0, 1/2, 1/2)
	elseif(owner ~= 'player') then
		button:SetBackdropColor(0, 0, 0)
	end
end

local function PostUpdateDebuff(element, unit, button, index)
	local _, _, _, type, _, _, owner = UnitAura(unit, index, button.filter)
	if(owner == 'player') then
		local color = DebuffTypeColor[type or 'none']
		button:SetBackdropColor(color.r * 3/5, color.g * 3/5, color.b * 3/5)
		button.icon:SetDesaturated(false)
	else
		button:SetBackdropColor(0, 0, 0)
		button.icon:SetDesaturated(true)
	end

	PostUpdateBuff(element, unit, button, index)
end

local function FilterTargetDebuffs(...)
	local _, unit, _, _, _, _, _, _, _, owner, _, _, id = ...
	return owner == 'player' or owner == 'vehicle' or UnitIsFriend('player', unit) or not owner
end

local function FilterGroupDebuffs(...)
	local _, _, _, _, _, _, _, _, _, _, _, _, _, id = ...
	return id == 160029
end

local UnitSpecific = {
	player = function(self)
		local PetHealth = self.StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		PetHealth:SetPoint('RIGHT', self.HealthValue, 'LEFT', -2, 0)
		PetHealth:SetJustifyH('RIGHT')

		local PetHealthUpdater = CreateFrame('Frame')
		PetHealthUpdater:RegisterUnitEvent('UNIT_HEALTH', 'pet')
		PetHealthUpdater:RegisterUnitEvent('UNIT_MAXHEALTH', 'pet')
		PetHealthUpdater:RegisterUnitEvent('UNIT_PET', 'player')
		PetHealthUpdater:SetScript('OnEvent', function()
			if(UnitIsUnit('pet', 'vehicle')) then
				return
			end

			if(UnitIsDead('pet')) then
				PetHealth:SetText(DEAD_TEXTURE)
				return
			end

			local cur = UnitHealth('pet')
			local max = UnitHealthMax('pet')
			if(cur > 0) then
				local color = CreateColor(oUF:ColorGradient(cur, max, 1, 0, 0, 1, 1, 0, 1, 1, 1))
				PetHealth:SetFormattedText('%s%d%%|r ', color:GenerateHexColorMarkup(), cur / max * 100)
			else
				PetHealth:SetText()
			end
		end)

		local PowerValue = self.StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		PowerValue:SetPoint('LEFT', self.Health, 2, 0)
		PowerValue:SetPoint('RIGHT', PetHealth, 'LEFT', -2, 0)
		PowerValue:SetJustifyH('LEFT')
		PowerValue:SetWordWrap(false)
		self:Tag(PowerValue, '[powercolor][impblizz:curpp]|r[ |cff0090ff$>impblizz:altpp<$%|r][ : $>impblizz:cast]')

		local PowerPrediction = CreateFrame('StatusBar', nil, self.Power)
		PowerPrediction:SetPoint('RIGHT', self.Power:GetStatusBarTexture())
		PowerPrediction:SetPoint('BOTTOM')
		PowerPrediction:SetPoint('TOP')
		PowerPrediction:SetWidth(230)
		PowerPrediction:SetStatusBarTexture(TEXTURE)
		PowerPrediction:SetStatusBarColor(1, 0, 0)
		PowerPrediction:SetReverseFill(true)
		self.PowerPrediction = {
			mainBar = PowerPrediction
		}

		local Experience = CreateFrame('StatusBar', nil, self, 'AnimatedStatusBarTemplate')
		Experience:SetPoint('BOTTOM', 0, -20)
		Experience:SetSize(230, 6)
		Experience:SetStatusBarTexture(TEXTURE)
		Experience:EnableMouse(true)
		Experience.OverrideUpdateColor = UpdateExperienceColor
		self.Experience = Experience

		local Rested = CreateFrame('StatusBar', nil, Experience, 'BackdropTemplate')
		Rested:SetAllPoints()
		Rested:SetStatusBarTexture(TEXTURE)
		Rested:SetBackdrop(BACKDROP)
		Rested:SetBackdropColor(0, 0, 0)
		Experience.Rested = Rested

		local ExperienceBG = Rested:CreateTexture(nil, 'BORDER')
		ExperienceBG:SetAllPoints()
		ExperienceBG:SetColorTexture(1/3, 1/3, 1/3)

		local ClassPower = {}
		ClassPower.UpdateColor = UpdateClassPowerColor
		ClassPower.PostUpdate = PostUpdateClassPower

		for index = 1, 11 do -- have to create an extra to force __max to be different from UnitPowerMax
			local Bar = CreateFrame('StatusBar', nil, self, 'BackdropTemplate')
			Bar:SetHeight(6)
			Bar:SetStatusBarTexture(TEXTURE)
			Bar:SetBackdrop(BACKDROP)
			Bar:SetBackdropColor(0, 0, 0)

			if(index > 1) then
				Bar:SetPoint('LEFT', ClassPower[index - 1], 'RIGHT', 4, 0)
			else
				Bar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -4)
			end

			if(index > 5) then
				Bar:SetFrameLevel(Bar:GetFrameLevel() + 1)
			end

			local Background = Bar:CreateTexture(nil, 'BORDER')
			Background:SetAllPoints()
			Bar.bg = Background

			ClassPower[index] = Bar
		end
		self.ClassPower = ClassPower

		local Totems = {}
		Totems.PostUpdate = PostUpdateTotem

		for index = 1, MAX_TOTEMS do
			local Totem = CreateFrame('Button', nil, self)
			Totem:SetSize(22, 22)

			local Icon = Totem:CreateTexture(nil, 'OVERLAY')
			Icon:SetAllPoints()
			Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Totem.Icon = Icon

			local Background = Totem:CreateTexture(nil, 'BORDER')
			Background:SetPoint('TOPLEFT', -1, 1)
			Background:SetPoint('BOTTOMRIGHT', 1, -1)
			Background:SetColorTexture(0, 0, 0)

			local Cooldown = CreateFrame('Cooldown', nil, Totem, 'CooldownFrameTemplate')
			Cooldown:SetAllPoints()
			Cooldown:SetReverse(true)
			Totem.Cooldown = Cooldown

			Totems[index] = Totem
		end
		self.Totems = Totems

		if(playerClass == 'DEATHKNIGHT') then
			local Runes = {}
			Runes.sortOrder = 'asc'
			for index = 1, 6 do
				local Rune = CreateFrame('StatusBar', nil, self, 'BackdropTemplate')
				Rune:SetSize(35, 6)
				Rune:SetStatusBarTexture(TEXTURE)
				Rune:SetBackdrop(BACKDROP)
				Rune:SetBackdropColor(0, 0, 0)

				if(index == 1) then
					Rune:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -4)
				else
					Rune:SetPoint('LEFT', Runes[index - 1], 'RIGHT', 4, 0)
				end

				local RuneBG = Rune:CreateTexture(nil, 'BORDER')
				RuneBG:SetAllPoints()
				RuneBG:SetTexture(TEXTURE)
				RuneBG.multiplier = 1/3
				Rune.bg = RuneBG

				Runes[index] = Rune
			end
			self.Runes = Runes
		end

		self.Debuffs.size = 22
		self.Debuffs:SetSize(230, 22)
		self.Debuffs.PostUpdateIcon = PostUpdateBuff

		self:Tag(self.HealthValue, '[impblizz:status][impblizz:maxhp][|cffff8080-$>impblizz:defhp<$|r][ $>impblizz:perhp<$|cff0090ff%|r]')
		self:SetWidth(230)
	end,
	target = function(self)
		local Name = self.StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		Name:SetPoint('LEFT', self.Health, 2, 0)
		Name:SetPoint('RIGHT', self.HealthValue, 'LEFT')
		Name:SetJustifyH('LEFT')
		Name:SetWordWrap(false)
		self:Tag(Name, '[impblizz:name]')

		local Buffs = CreateFrame('Frame', nil, self)
		Buffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 4, 0)
		Buffs:SetSize(236, 44)
		Buffs.num = 27
		Buffs.size = 22
		Buffs.spacing = 4
		Buffs.initialAnchor = 'TOPLEFT'
		Buffs['growth-y'] = 'DOWN'
		Buffs.PostCreateIcon = PostCreateAura
		Buffs.PostUpdateIcon = PostUpdateBuff
		self.Buffs = Buffs

		self.Castbar.PostCastStart = PostUpdateCast
		self.Castbar.PostCastInterruptible = PostUpdateCast

		self.Debuffs.size = 19.4
		self.Debuffs['growth-y'] = 'DOWN'
		self.Debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -4)
		self.Debuffs:SetSize(230, 19.4)
		self.Debuffs.CustomFilter = FilterTargetDebuffs
		self.Debuffs.PostUpdateIcon = PostUpdateDebuff

		self.Power.PostUpdate = PostUpdatePower
		self:Tag(self.HealthValue, '[impblizz:status][impblizz:curhp][ $>impblizz:targethp]')
		self:SetWidth(230)
	end,
	party = function(self)
		local Name = self.StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		Name:SetPoint('LEFT', self.Health, 3, 0)
		Name:SetPoint('RIGHT', self.HealthValue, 'LEFT')
		Name:SetJustifyH('LEFT')
		Name:SetWordWrap(false)
		self:Tag(Name, '[impblizz:leader][raidcolor][name]')

		local Resurrect = self.StringParent:CreateTexture(nil, 'OVERLAY')
		Resurrect:SetPoint('CENTER', self)
		Resurrect:SetSize(16, 16)
		self.ResurrectIndicator = Resurrect

		local ReadyCheck = self:CreateTexture()
		ReadyCheck:SetPoint('LEFT', self, 'RIGHT', 3, 0)
		ReadyCheck:SetSize(14, 14)
		self.ReadyCheckIndicator = ReadyCheck

		local Summon = CreateFrame('Frame', nil, self)
		Summon:SetPoint('RIGHT', self, 'LEFT')
		Summon:SetSize(32, 32)
		Summon:SetScript('OnLeave', GameTooltip_Hide)
		Summon:SetScript('OnEnter', OnSummonEnter)
		Summon.Override = UpdateSummon
		self.SummonIndicator = Summon

		local SummonIcon = Summon:CreateTexture(nil, 'OVERLAY')
		SummonIcon:SetAllPoints()
		SummonIcon:SetAtlas('Raid-Icon-SummonPending')
		Summon.Icon = SummonIcon

		local RoleIcon = self:CreateTexture(nil, 'OVERLAY')
		RoleIcon:SetPoint('LEFT', self, 'RIGHT', 3, 0)
		RoleIcon:SetSize(14, 14)
		RoleIcon:SetAlpha(0)
		self.GroupRoleIndicator = RoleIcon

		self:HookScript('OnEnter', function() RoleIcon:SetAlpha(1) end)
		self:HookScript('OnLeave', function() RoleIcon:SetAlpha(0) end)

		self.Debuffs.size = 16
		self.Debuffs:SetSize(100, 16)
		self.Debuffs.CustomFilter = FilterGroupDebuffs

		local mu = self.Power.bg.multiplier
		local r, g, b = unpack(self.colors.power.MANA)
		self.Power:SetStatusBarColor(r, g, b)
		self.Power.bg:SetVertexColor(r * mu, b * mu, b * mu)
		self.Power.Override = UpdateGroupPower

		self.Range = {}

		self:Tag(self.HealthValue, '[impblizz:status][impblizz:perhp<$|cff0090ff%|r]')
	end,
	boss = function(self)
		self:Tag(self.HealthValue, '[impblizz:perhp<$|cff0090ff%|r]')
	end,
	arena = function(self)
		local Name = self.StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		Name:SetPoint('LEFT', self.Health, 3, 0)
		Name:SetPoint('RIGHT', self.HealthValue, 'LEFT')
		Name:SetJustifyH('LEFT')
		Name:SetWordWrap(false)
		self:Tag(Name, '[raidcolor][name]')

		self.Power.Override = UpdateGroupPower
		self.Power.OverrideArenaPreparation = UpdatePowerPrep
		self.Health.OverrideArenaPreparation = UpdateHealthPrep
		self:Tag(self.HealthValue, '[impblizz:perhp<$|cff0090ff%|r]')
	end
}
UnitSpecific.raid = UnitSpecific.party

local function Shared(self, unit)
	unit = unit:match('^(.-)%d+') or unit

	self.colors.power.MANA = {0, 144/255, 1}
	self.colors.power[0] = self.colors.power.MANA
	self.colors.power.RUNES = {1/2, 1/3, 2/3}
	self.colors.power[5] = self.colors.power.RUNES
	self.colors.power.INSANITY = {4/5, 2/5, 1}
	self.colors.power[13] = self.colors.power.INSANITY
	-- self.colors.experience[1] = {1/6, 2/3, 1/5}

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	Mixin(self, BackdropTemplateMixin)
	self:SetBackdrop(BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetStatusBarTexture(TEXTURE)
	Health:SetStatusBarColor(1/3, 1/3, 1/3)
	Health:SetReverseFill(true)
	Health.Override = UpdateHealth
	Health.frequentUpdates = true
	self.Health = Health

	local HealthBG = self:CreateTexture(nil, 'BORDER')
	HealthBG:SetAllPoints(Health)
	HealthBG:SetColorTexture(1/6, 1/6, 2/7)

	-- We create a parent for strings so that they appear above everything else
	local StringParent = CreateFrame('Frame', nil, self)
	StringParent:SetFrameLevel(20)
	self.StringParent = StringParent

	local HealthValue = StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	HealthValue:SetPoint('RIGHT', Health, -2, 0)
	HealthValue:SetJustifyH('RIGHT')
	self.HealthValue = HealthValue

	if(unit == 'player' or unit == 'target') then
		self:SetHeight(22)

		local Portrait = CreateFrame('PlayerModel', nil, self)
		Portrait:SetAllPoints(Health)
		Portrait:SetFrameLevel(Health:GetFrameLevel() - 1)
		Portrait.PostUpdate = PostUpdatePortrait
		self.Portrait = Portrait

		local Castbar = CreateFrame('StatusBar', nil, self)
		Castbar:SetAllPoints(Health)
		Castbar:SetStatusBarTexture(TEXTURE)
		Castbar:SetStatusBarColor(0, 0, 0, 0)
		Castbar:SetFrameStrata('HIGH')
		self.Castbar = Castbar

		local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
		Spark:SetPoint('CENTER', Castbar:GetStatusBarTexture(), 'RIGHT')
		Spark:SetSize(2, self:GetHeight() - 2)
		Spark:SetTexture(TEXTURE)
		Spark:SetVertexColor(1, 1, 1)
		Castbar.Spark = Spark

		Health:SetHeight(20)
		Health:SetPoint('TOPRIGHT')
		Health:SetPoint('TOPLEFT')
	else
		Health:SetAllPoints()
	end

	if(unit == 'focus' or unit == 'targettarget' or unit == 'boss') then
		local Name = StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		Name:SetPoint('LEFT', Health, 2, 0)
		Name:SetPoint('RIGHT', HealthValue, 'LEFT')
		Name:SetJustifyH('LEFT')
		Name:SetWordWrap(false)
		self:Tag(Name, '[impblizz:color][name]')
	else
		local Power = CreateFrame('StatusBar', nil, self)
		Power:SetPoint('BOTTOMRIGHT')
		Power:SetPoint('BOTTOMLEFT')
		Power:SetHeight(1)
		Power:SetStatusBarTexture(TEXTURE)
		Power.frequentUpdates = true
		self.Power = Power

		Power.colorClass = true
		Power.colorTapping = true
		Power.colorDisconnected = true
		Power.colorReaction = true

		local PowerBG = Power:CreateTexture(nil, 'BORDER')
		PowerBG:SetAllPoints()
		PowerBG:SetTexture(TEXTURE)
		PowerBG.multiplier = 1/3
		Power.bg = PowerBG

		local RaidTarget = StringParent:CreateTexture(nil, 'OVERLAY')
		RaidTarget:SetPoint('TOP', self, 0, 8)
		RaidTarget:SetSize(16, 16)
		self.RaidTargetIndicator = RaidTarget

		if(unit ~= 'arena') then
			local Threat = CreateFrame('Frame', nil, self, 'BackdropTemplate')
			Threat:SetPoint('TOPRIGHT', 3, 3)
			Threat:SetPoint('BOTTOMLEFT', -3, -3)
			Threat:SetFrameStrata('LOW')
			Threat:SetBackdrop(GLOW)
			Threat.Override = UpdateThreat
			self.ThreatIndicator = Threat
		end
	end

	if(unit ~= 'boss' and unit ~= 'arena') then
		local Debuffs = CreateFrame('Frame', nil, self)
		Debuffs.spacing = 4
		Debuffs.initialAnchor = 'TOPLEFT'
		Debuffs.PostCreateIcon = PostCreateAura
		self.Debuffs = Debuffs

		if(unit == 'focus') then
			Debuffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 4, 0)
			Debuffs.onlyShowPlayer = true
		elseif(unit ~= 'target') then
			Debuffs:SetPoint('TOPRIGHT', self, 'TOPLEFT', -4, 0)
			Debuffs.initialAnchor = 'TOPRIGHT'
			Debuffs['growth-x'] = 'LEFT'
		end

		if(unit == 'focus' or unit == 'targettarget') then
			Debuffs.num = 3
			Debuffs.size = 19
			Debuffs:SetSize(230, 19)

			self:SetSize(161, 19)
		end
	else
		self:SetSize(126, 19)
	end

	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle('ImprovedBlizzardUI', Shared)
oUF:Factory(function(self)
	self:SetActiveStyle('ImprovedBlizzardUI')
	self:Spawn('player'):SetPoint('CENTER', -300, -250)
	self:Spawn('focus'):SetPoint('TOPLEFT', oUF_ImprovedBlizzardUIPlayer, 0, 26)
	self:Spawn('target'):SetPoint('CENTER', 300, -250)
	self:Spawn('targettarget'):SetPoint('TOPRIGHT', oUF_ImprovedBlizzardUITarget, 0, 26)

	self:SpawnHeader(nil, nil, 'custom [group:party] show; [@raid3,exists] show; [@raid26,exists] hide; hide',
		'showParty', true,
		'showRaid', true,
		'showPlayer', true,
		'yOffset', -6,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'TANK,HEALER,DAMAGER',
		'oUF-initialConfigFunction', [[
			self:SetHeight(19)
			self:SetWidth(126)
		]]
	):SetPoint('TOP', Minimap, 'BOTTOM', 0, -10)

	for index = 1, 5 do
		local boss = self:Spawn('boss' .. index)
		local arena = self:Spawn('arena' .. index)

		if(index == 1) then
			boss:SetPoint('TOP', oUF_ImprovedBlizzardUIRaid, 'BOTTOM', 0, -20)
			arena:SetPoint('TOP', oUF_ImprovedBlizzardUIRaid, 'BOTTOM', 0, -20)
		else
			boss:SetPoint('TOP', _G['oUF_ImprovedBlizzardUIBoss' .. index - 1], 'BOTTOM', 0, -6)
			arena:SetPoint('TOP', _G['oUF_ImprovedBlizzardUIArena' .. index - 1], 'BOTTOM', 0, -6)
		end
	end
end)