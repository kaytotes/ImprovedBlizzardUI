--[[
    modules\combat\healthwarning.lua
    Displays a five second warning when Player Health is less than 50% and 25%.
]]
local ImpUI_Health = ImpUI:NewModule('ImpUI_Health', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

local OSD;

-- Local Functions
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;

-- Module Variables
local canShowHalf = true;
local canShowQuarter = true;

--[[
    Fired when a Units health changes. In this case we only care
    about whether the Unit is a Player.
	
    @ return void
]]
function ImpUI_Health:UNIT_HEALTH(event, ...)
    if (ImpUI.db.profile.healthWarning == false) then return; end

    if (... == 'player') then
        local hp = UnitHealth('player') / UnitHealthMax('player');

        if (hp > 0.50) then
            canShowHalf = true;
        end

        local size = ImpUI.db.profile.healthWarningSize;

        if ( hp <= 0.50 and hp > 0.25 and canShowHalf == true) then
            -- Get font config options.
            local font = ImpUI.db.profile.healthWarningFont;
            local colour = ImpUI.db.profile.healthWarningHalfColour;

            OSD:AddMessage( L['HP < 50% !'], font, size, colour.r, colour.g, colour.b, 5.0 );

            canShowHalf = false;
            canShowQuarter = true;
            return;
        elseif(hp < 0.25 and canShowQuarter == true) then
            -- Get font config options.
            local font = ImpUI.db.profile.healthWarningFont;
            local colour = ImpUI.db.profile.healthWarningQuarterColour;

            OSD:AddMessage( L['HP < 25% !!!'], font, size, colour.r, colour.g, colour.b, 5.0 );

            canShowHalf = true;
            canShowQuarter = false;
            return;
        end
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Health:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Health:OnEnable()
    OSD = ImpUI:GetModule('ImpUI_OSD');

    self:RegisterEvent('UNIT_HEALTH');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Health:OnDisable()
end