--[[
    modules\combat\interrupts.lua
    When you interrupt a target your character announces this to an appropriate sound channel.
]]
local ImpUI_Interrupts = ImpUI:NewModule('ImpUI_Interrupts', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local UnitGUID = UnitGUID;
local SendChatMessage = SendChatMessage;
local IsInGroup = IsInGroup;
local IsInRaid = IsInRaid;

local CONF_AUTO = 1;
local CONF_SAY = 2;
local CONF_YELL = 3;

--[[
    Fires on basically any combat log event then I narrow
    scope within the function itself.
	
    @ return void
]]
function ImpUI_Interrupts:COMBAT_LOG_EVENT_UNFILTERED()
    if (ImpUI.db.profile.announceInterrupts == false) then return; end

    local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, _, spellName, _, _, _, _, _ = CombatLogGetCurrentEventInfo();

    if (event == 'SPELL_INTERRUPT' and (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet'))) then
        local message = L['Interrupted X on Y'](spellName, destName);

        local channel;
        local config = ImpUI.db.profile.interruptChannel;

        if (config == CONF_AUTO) then -- Auto
            channel = IsInGroup(2) and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or IsInGroup() and 'PARTY' or 'SAY';
        elseif (config == CONF_SAY) then
            channel = 'SAY';
        elseif (config == CONF_YELL) then
            channel = 'YELL';
        end

        local inInstance, instanceType = IsInInstance();
        
        if ((channel == 'SAY' or channel == 'YELL') and inInstance == false) then
            return;
        end
        
        SendChatMessage(message, channel);
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Interrupts:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Interrupts:OnEnable()
    self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Interrupts:OnDisable()
end