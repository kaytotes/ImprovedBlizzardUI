local _, ns = ...
local oUF = ns.oUF;

local statusBarTexture = 'Interface\\TargetingFrame\\UI-StatusBar';

local BACKDROP = {
	bgFile = TEXTURE,
	insets = {top = -1, bottom = -1, left = -1, right = -1}
}

local function UpdateHealth(self, event, unit)
	if(not unit or self.unit ~= unit) then
		return
    end
    
    print('Updating Health');

	local element = self.Health
	element:SetShown(UnitIsConnected(unit))

	if(element:IsShown()) then
		local cur = UnitHealth(unit)
		local max = UnitHealthMax(unit)
		element:SetMinMaxValues(0, max)
		element:SetValue(max - cur)
	end
end

local UnitSpecific = {
    party = function(self)
        print('party');

        local Name = self.StringParent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		Name:SetPoint('LEFT', self.Health, 3, 0)
		Name:SetPoint('RIGHT', self.HealthValue, 'LEFT')
		Name:SetJustifyH('LEFT')
		Name:SetWordWrap(false)
		self:Tag(Name, '[name]')

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

    end,
}

local Shared = function(self, unit)
    Mixin(self, BackdropTemplateMixin)
	self:SetBackdrop(BACKDROP)
    self:SetBackdropColor(0, 0, 0)
    
	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetStatusBarTexture(statusBarTexture)
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
    
    Health:SetAllPoints()

    local Debuffs = CreateFrame('Frame', nil, self)
		Debuffs.spacing = 4
		Debuffs.initialAnchor = 'TOPLEFT'
		Debuffs.PostCreateIcon = PostCreateAura
        self.Debuffs = Debuffs
        
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
    
    print('Shared');

	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle("ImprovedBlizzardUI", Shared)
oUF:Factory(function(self)

     self:SetActiveStyle("ImprovedBlizzardUI")

     -- oUF:SpawnHeader(overrideName, overrideTemplate, visibility, attributes ...)
     self:SpawnHeader(nil, nil, 'custom [group:party] show; [@raid3,exists] show; [@raid26,exists] hide; hide',
     'showParty', true,
     'showRaid', true,
     'showPlayer', false,
     'yOffset', -6,
     'groupBy', 'ASSIGNEDROLE',
     'groupingOrder', 'TANK,HEALER,DAMAGER',
     'oUF-initialConfigFunction', [[
         self:SetHeight(19)
         self:SetWidth(126)
     ]]
 ):SetPoint('CENTER')

end)