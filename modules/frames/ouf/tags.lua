local _, ns = ...
local oUF = ns.oUF;

local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events
local tagSharedEvents = tags.SharedEvents

local gsub = string.gsub
local format = string.format
local floor = math.floor

local function Short(value)
	if(value >= 1e6) then
		return gsub(format('%.2fm', value / 1e6), '%.?0+([km])$', '%1')
	elseif(value >= 1e4) then
		return gsub(format('%.1fk', value / 1e3), '%.?0+([km])$', '%1')
	else
		return value
	end
end

local function Status(unit)
	if(not UnitIsConnected(unit)) then
		return 'Offline'
	elseif(UnitIsGhost(unit)) then
		return 'Ghost'
	elseif(UnitIsDead(unit)) then
		return 'Dead'
	end
end

local function GetAuraCount(unit, id)
	local index = 1
	local count, spellID, _
	repeat
		_, _, _, count, _, _, _, _, _, _, spellID = UnitAura(unit, index, 'HELPFUL')
		if(spellID == id) then
			return count
		end

		index = index + 1
	until(not spellID)
end

local events = {
	curhp = 'UNIT_HEALTH UNIT_MAXHEALTH',
	defhp = 'UNIT_HEALTH UNIT_MAXHEALTH',
	maxhp = 'UNIT_HEALTH UNIT_MAXHEALTH',
	perhp = 'UNIT_HEALTH UNIT_MAXHEALTH',
	targethp = 'UNIT_HEALTH UNIT_MAXHEALTH',
	curpp = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER',
	altpp = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER',
	leader = 'PARTY_LEADER_CHANGED',
	cast = 'UNIT_SPELLCAST_START UNIT_SPELLCAST_STOP UNIT_SPELLCAST_CHANNEL_START UNIT_SPELLCAST_CHANNEL_STOP',
	name = 'UNIT_SPELLCAST_START UNIT_SPELLCAST_STOP UNIT_SPELLCAST_CHANNEL_START UNIT_SPELLCAST_CHANNEL_STOP UNIT_NAME_UPDATE UNIT_FACTION UNIT_CLASSIFICATION_CHANGED',
	color = 'UNIT_FACTION',
	status = 'UNIT_CONNECTION UNIT_HEALTH',
}

for tag, func in next, {
	curhp = function(unit)
		if(Status(unit)) then return end
		return Short(UnitHealth(unit))
	end,
	defhp = function(unit)
		if(Status(unit)) then return end

		local cur = UnitHealth(unit)
		local max = UnitHealthMax(unit)
		if(cur ~= max) then
			return Short(max - cur)
		end
	end,
	maxhp = function(unit)
		if(Status(unit)) then return end

		local max = UnitHealthMax(unit)
		if(max == UnitHealth(unit)) then
			return Short(max)
		end
	end,
	perhp = function(unit)
		if(Status(unit)) then return end

		local cur = UnitHealth(unit)
		local max = UnitHealthMax(unit)
		if(cur ~= max) then
			return floor(cur / max * 100)
		end
	end,
	targethp = function(unit)
		if(Status(unit)) then return end

		local cur = UnitHealth(unit)
		local max = UnitHealthMax(unit)
		if(UnitCanAttack('player', unit)) then
			return format('(%d|cff0090ff%%|r)', cur / max * 100)
		elseif(cur ~= max) then
			return format('|cff0090ff/|r %s', Short(max))
		end
	end,
	curpp = function(unit)
		if(Status(unit)) then return end

		local cur = UnitPower(unit)
		if(cur > 0) then
			return Short(cur)
		end
	end,
	altpp = function(unit)
		local cur = UnitPower(unit, 0)
		local max = UnitPowerMax(unit, 0)
		if(UnitPowerType(unit) ~= 0 and cur ~= max) then
			return floor(cur / max * 100)
		end
	end,
	leader = function(unit)
		return UnitIsGroupLeader(unit) and '|cffffff00!|r'
	end,
	cast = function(unit)
		return UnitCastingInfo(unit) or UnitChannelInfo(unit)
	end,
	name = function(unit)
		local name, _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
		if(name) then
			local color = notInterruptible and 'ff9000' or 'ff0000'
			return format('|cff%s%s|r', color, name)
		end

		name, _, _, _, _, _, _, notInterruptible = UnitChannelInfo(unit)
		if(name) then
			local color = notInterruptible and 'ff9000' or 'ff0000'
			return format('|cff%s%s|r', color, name)
		end

		name = UnitName(unit)

		local color = _TAGS['impblizz:color'](unit)
		name = color and format('%s%s|r', color, name) or name

		local rare = _TAGS['rare'](unit)
		return rare and format('%s |cff0090ff%s|r', name, rare) or name
	end,
	color = function(unit)
		local reaction = UnitReaction(unit, 'player')
		if(UnitIsTapDenied(unit) or not UnitIsConnected(unit)) then
			return '|cff999999'
		elseif(not UnitIsPlayer(unit) and reaction) then
			return Hex(_COLORS.reaction[reaction])
		elseif(UnitFactionGroup(unit) and UnitIsEnemy(unit, 'player') and UnitIsPVP(unit)) then
			return '|cffff0000'
		end
	end,
	status = Status
} do
	tagMethods['impblizz:' .. tag] = func
	tagEvents['impblizz:' .. tag] = events[tag]
end