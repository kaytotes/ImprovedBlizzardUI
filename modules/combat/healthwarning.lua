--[[
    
]]
local addonName, Loc = ...;

local HealthFrame = CreateFrame('Frame', nil, UIParent);

local function HealthFrame_Update()
    if ( UnitIsDeadOrGhost('player') ) then return; end -- Ignore if the Player is dead

    local hp = UnitHealth('player') / UnitHealthMax('player'); -- Get the players health as a percentage

    if ( hp <= 0.50 ) then
        Imp_OSD:AddMessage( Loc['HP < 50% !'], 0, 1, 1, 53, 3 );
        return;
    end

    return;
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if ( event == 'UNIT_HEALTH' and ... == 'player') then
        local hp = UnitHealth('player') / UnitHealthMax('player');

        if ( hp > 0.50 ) then
            HealthFrame.canShowHalf = true;
        end

        if ( hp <= 0.50 and hp > 0.25 and HealthFrame.canShowHalf) then
            Imp_OSD:AddMessage( Loc['HP < 50% !'], 0, 1, 1, 53, 5.0 );
            HealthFrame.canShowHalf = false;
            HealthFrame.canShowQuarter = true;
            return;
        elseif(hp < 0.25 and HealthFrame.canShowQuarter) then
            Imp_OSD:AddMessage( Loc['HP < 25% !!!'], 1, 0, 0, 53, 5.0 );
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
HealthFrame:RegisterEvent('ADDON_LOADED');
HealthFrame:RegisterEvent('UNIT_HEALTH');