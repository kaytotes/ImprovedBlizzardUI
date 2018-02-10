--[[
    modules\misc\autoscreenshot.lua
    Automatically takes a screenshot when an achievement is earned
]]
local addonName, Loc = ...;

local AutoScreenshotFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'ACHIEVEMENT_EARNED' and PrimaryDB.autoScreenshot) then
        Screenshot();
    end
end

-- Register the Modules Events
AutoScreenshotFrame:SetScript('OnEvent', HandleEvents);
AutoScreenshotFrame:RegisterEvent('ACHIEVEMENT_EARNED');
