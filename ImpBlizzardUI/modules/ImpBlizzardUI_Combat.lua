--[[
    ImpBlizzardUI/modules/ImpBlizzardUI_Combat
    Handles the more generic combat related changes
    Current Features:
]]
local _, ImpBlizz = ...;

local CombatFrame = CreateFrame("Frame", nil, UIParent);

-- Health Warning Update Tick (Could this be a little resource intensive?)
local function HealthWarning_Update()
    local healthPercentage = UnitHealth("player") / UnitHealthMax("player");

    -- Only shows if not dead
    if(healthPercentage >= 0.01) then
        if(healthPercentage <= 0.50 and healthPercentage > 0.25) then
            CombatFrame.onScreenDisplay:AddMessage( ImpBlizz["HP < 50% !"], 0, 1, 1, 53, 3 );
            return;
        elseif(healthPercentage < 0.25) then
            CombatFrame.onScreenDisplay:AddMessage(ImpBlizz["HP < 25% !!!"], 1, 0, 0, 53, 3);
            return;
        end
    end

    return;
end

local function BuildHealthWarning()
    if(Conf_HealthUpdate) then
        CombatFrame.healthUpdater = CreateFrame("Frame", nil, UIParent);
        CombatFrame.healthUpdater:SetScript("OnUpdate", HealthWarning_Update);
        CombatFrame.healthUpdater.storedHealth = 0;
    end
end

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
    local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _, sourceID, _, _, spellID, spellName, spellSchool = ...;

    if (eventType == "SPELL_INTERRUPT" and (sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet"))) then
        if(Conf_Interrupts) then
            local message = "Interrupted %sl on %t";
            message = message:gsub("%%t", destName):gsub("%%sl", GetSpellLink(spellID));
            SendChatMessage(message, IsInGroup(2) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY" or "SAY");
        end
    end

    if(event == "ADDON_LOADED" and ... == "ImpBlizzardUI") then
        BuildHealthWarning();
    end
end

-- Initialise the module
local function Init()
    BuildOnScreenDisplay();

    CombatFrame:SetScript("OnEvent", HandleEvents);
    CombatFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    CombatFrame:RegisterEvent("ADDON_LOADED");
end

-- Run Initialise
Init();
