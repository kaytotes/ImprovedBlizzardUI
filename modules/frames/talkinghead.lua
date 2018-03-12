--[[
    modules\frames\talkinghead.lua
    Repositions the Talking Head Frame
]]
local addonName, Loc = ...;

local TalkingFrame = CreateFrame('Frame', nil, UIParent);  

local function MoveTalkingHead()
    if (InCombatLockdown() == false and MultiBarBottomRight:IsShown()) then
        TalkingHeadFrame.ignoreFramePositionManager = true;
        TalkingHeadFrame:ClearAllPoints();
        TalkingHeadFrame:SetPoint('BOTTOM', 0, 150);
    end
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_ENTERING_WORLD') then
        MoveTalkingHead();
    end
end

-- Register the Modules Events
TalkingFrame:SetScript('OnEvent', HandleEvents);
TalkingFrame:RegisterEvent('PLAYER_ENTERING_WORLD');