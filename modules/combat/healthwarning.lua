--[[
    modules\combat\healthwarning.lua
    Displays a five second warning when Player Health is less than 50% and 25%.
]]
local addonName, Loc = ...;

local HealthFrame = CreateFrame('Frame', nil, UIParent);

local config = false;

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_LOGIN') then
        config = PrimaryDB.healthWarnings;
    end

    if ( event == 'UNIT_HEALTH' and ... == 'player' and config) then
        local hp = UnitHealth('player') / UnitHealthMax('player');

        if ( hp > 0.50 ) then
            HealthFrame.canShowHalf = true;
        end

        if ( hp <= 0.50 and hp > 0.25 and HealthFrame.canShowHalf) then
            Imp_OSD.AddMessage( Loc['HP < 50% !'], 0, 1, 1, 5.0 );
            HealthFrame.canShowHalf = false;
            HealthFrame.canShowQuarter = true;
            return;
        elseif(hp < 0.25 and HealthFrame.canShowQuarter) then
            Imp_OSD.AddMessage( Loc['HP < 25% !!!'], 1, 0, 0, 5.0 );
            HealthFrame.canShowHalf = true;
            HealthFrame.canShowQuarter = false;
            return;
        end
    end
end

-- Register the Modules Events
HealthFrame.canShowHalf = true;
HealthFrame.canShowQuarter = true;
HealthFrame:SetScript('OnEvent', HandleEvents);
HealthFrame:RegisterEvent('UNIT_HEALTH');
HealthFrame:RegisterEvent('PLAYER_LOGIN');