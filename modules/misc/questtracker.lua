--[[
    modules\misc\questtracker.lua
    Hides the quest tracker when a player enters an instance.
]]
local addonName, Loc = ...;

local ObjFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_LOGIN') then
        print('PLAYER_LOGIN');
        isInstance, instanceType = IsInInstance();

        if (isInstance and instanceType ~= 'none' and PrimaryDB.toggleObjective) then
            if(not ObjectiveTrackerFrame.collapsed) then
                ObjectiveTracker_Collapse();
            end
        end
    end
end

-- Register the Modules Events
ObjFrame:SetScript('OnEvent', HandleEvents);
ObjFrame:RegisterEvent('PLAYER_LOGIN');