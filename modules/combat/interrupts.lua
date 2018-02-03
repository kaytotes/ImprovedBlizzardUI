--[[
    modules\combat\interrupts.lua
    When you interrupt a target your character announces this to an appropriate sound channel.
]]
local addonName, Loc = ...;

local InterruptFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _, sourceID, _, _, spellID, spellName, spellSchool = ...;

    if (eventType == 'SPELL_INTERRUPT' and (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet'))) then
        if(PrimaryDB.announceInterrupts) then
            local message = 'Interrupted %sl on %t';
            message = message:gsub('%%t', destName):gsub('%%sl', GetSpellLink(spellID));
            SendChatMessage(message, IsInGroup(2) and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or IsInGroup() and 'PARTY' or 'SAY');
        end
    end
end

-- Register the Modules Events
InterruptFrame:SetScript('OnEvent', HandleEvents);
InterruptFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');