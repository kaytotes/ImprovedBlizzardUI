--[[
    ImpBlizzardUI/modules/ImpBlizzardUI_Combat
    Handles the more generic combat related changes
    Current Features:
]]
local _, ImpBlizz = ...;

local CombatFrame = CreateFrame("Frame", nil, UIParent);

local function BuildOnScreenDisplay()
    CombatFrame.onScreenDisplay = CreateFrame( "MessageFrame", "CombatOnScreenDisplay", UIParent );
    CombatFrame.onScreenDisplay:SetPoint("LEFT");
    CombatFrame.onScreenDisplay:SetPoint("RIGHT");
    CombatFrame.onScreenDisplay:SetHeight(29);
    CombatFrame.onScreenDisplay:SetInsertMode("TOP");
    CombatFrame.onScreenDisplay:SetFrameStrata("HIGH");
    CombatFrame.onScreenDisplay:SetTimeVisible(3);
    CombatFrame.onScreenDisplay:SetFadeDuration(1);
    CombatFrame.onScreenDisplay:SetFont("Interface\\AddOns\\ImpBlizzardUI\\media\\impfont.ttf", 26, "OUTLINE");
end

-- Handle the Blizzard API Events
local function HandleEvents(self, event, ...)

end

-- Initialise the module
local function Init()
    BuildOnScreenDisplay();
    
    CombatFrame:SetScript("OnEvent", HandleEvents);
    CombatFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

-- Run Initialise
Init();
