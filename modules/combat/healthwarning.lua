--[[
    modules\combat\healthwarning.lua
    Displays a five second warning when Player Health is less than 50% and 25%.
]]
local ImpUI_Health = ImpUI:NewModule('ImpUI_Health', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;

-- Variables
local canShowHalf = true;
local canShowQuarter = true;

function ImpUI_Health:UNIT_HEALTH(event, ...)
    if (ImpUI.db.char.healthWarning == false) then return; end

    if (... == 'player') then
        ImpUI:Print('UNIT_HEALTH');

        local hp = UnitHealth('player') / UnitHealthMax('player');

        if (hp > 0.50) then
            canShowHalf = true;
        end

        if ( hp <= 0.50 and hp > 0.25 and canShowHalf == true) then
            ImpUI:Print(L['HP < 50% !']);

            canShowHalf = false;
            canShowQuarter = true;
            return;
        elseif(hp < 0.25 and canShowQuarter == true) then
            ImpUI:Print(L['HP < 25% !!!']);

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
    ImpUI:Print('ImpUI_Health');
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Health:OnEnable()
    self:RegisterEvent('UNIT_HEALTH');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Health:OnDisable()
end