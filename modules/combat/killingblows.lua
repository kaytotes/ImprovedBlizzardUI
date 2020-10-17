--[[
    modules\combat\killingblows.lua
    When you get a Killing Blow this will be displayed prominently in the center of the screen.
]]
local ImpUI_KillingBlows = ImpUI:NewModule('ImpUI_KillingBlows', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local OSD;

-- Local Functions
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;
local IsInInstance = IsInInstance;
local UnitGUID = UnitGUID;
local GetZonePVPInfo = GetZonePVPInfo;

--[[
    Fires on basically any combat log event then I narrow
    scope within the function itself.
	
    @ return void
]]
function ImpUI_KillingBlows:COMBAT_LOG_EVENT_UNFILTERED()
    if (ImpUI.db.profile.killingBlows == false) then return; end

    local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, _, spellName, _, amount, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo();
    local _, instanceType = IsInInstance();

    if(event == 'PARTY_KILL') then
        if(sourceGUID == UnitGUID('player')) then
            local shouldShow = false;

            -- Figure out if we should show based on config.
            if (instanceType == 'none' and ImpUI.db.profile.killingBlowInWorld) then shouldShow = true; end
            if (instanceType == 'party' and ImpUI.db.profile.killingBlowInInstance) then shouldShow = true; end
            if (instanceType == 'raid' and ImpUI.db.profile.killingBlowInRaid) then shouldShow = true; end
            if((instanceType == 'pvp' or instanceType == 'arena' or (instanceType == 'none' and GetZonePVPInfo() == 'combat')) and ImpUI.db.profile.killingBlowInPvP) then shouldShow = true; end

            if (shouldShow) then
                local message = ImpUI.db.profile.killingBlowMessage;
                local font = ImpUI.db.profile.killingBlowFont;
                local size = ImpUI.db.profile.killingBlowSize;
                local colour = ImpUI.db.profile.killingBlowColour;
    
                OSD:AddMessage( message, font, size, colour.r, colour.g, colour.b, 2.0 );
            end
        end
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_KillingBlows:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_KillingBlows:OnEnable()
    OSD = ImpUI:GetModule('ImpUI_OSD');

    self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_KillingBlows:OnDisable()
end