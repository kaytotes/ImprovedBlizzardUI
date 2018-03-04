--[[
    modules\combat\killingblow.lua
    When you get a Killing Blow in a Battleground or Arena this will be displayed prominently in the center of the screen.
]]
local addonName, Loc = ...;

local KillingBlowFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)  
    local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _ = ...; -- Get all the variables we need
    local _, instanceType = IsInInstance();

    if(event == 'PARTY_KILL') then
        if(instanceType == 'pvp' or instanceType == 'arena' or (instanceType == 'none' and GetZonePVPInfo() == 'combat')) then -- Only run in a BG
            if(sourceGUID == UnitGUID('player') and PrimaryDB.killingBlows) then
                Imp_OSD.AddMessage( Loc['Killing Blow!'], 1, 1, 0, 2.0 );
            end
        end
    end
end

-- Register the Modules Events
KillingBlowFrame:SetScript('OnEvent', HandleEvents);
KillingBlowFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');