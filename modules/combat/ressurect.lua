--[[
    modules\combat\ressurect.lua
    Resurrects the player automatically based on certain conditions
]]
local addonName, Loc = ...;

local ResFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Replacement of the old function that blizzard deprecated

    @ return bool
]]
function HasSoulstone()
	local options = GetSortedSelfResurrectOptions();
	return options and options[1] and options[1].name;
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)  
    if (event == 'PLAYER_DEAD' and PrimaryDB.autoRes) then
        if (HasSoulstone()) then return end -- If we can self res (Ankh etc) then don't do anything.

        local inInstance, instanceType = IsInInstance();

        -- Res if we're in a BG not gonna bother with WG, Ashran etc because no one plays them
        if (inInstance and instanceType == 'pvp') then
            RepopMe();
            return
        end
    end
end

-- Register the Modules Events
ResFrame:SetScript('OnEvent', HandleEvents);
ResFrame:RegisterEvent('PLAYER_DEAD');