--[[
    ImpBlizzardUI/config.lua
    Handles the various config settings within ImpBlizzardUI and builds the config panes.
]]

local _, ImpBlizz = ...;

local Config = {};

-- Load Fonts and set the sizes etc
local Font = "Interface\\Addons\\ImpBlizzardUI\\media\\impfont.ttf";
local CheckBoxFontSize = 13;
local CheckBoxOffset = -30;
local HeaderFontSize = 13;

-- Simply checks if any of the options have changed. This is basically a huge if statement
local function ConfigChanged()
    if(Conf_HealthBarColor ~= Config.panel.healthColour:GetChecked() or Conf_Interrupts ~= Config.panel.interrupts:GetChecked() or Conf_ChatArrows ~= Config.panel.chatArrows:GetChecked() or Conf_HealthUpdate ~= Config.panel.healthWarning:GetChecked() or Conf_ObjectiveTracker ~= Config.panel.objectiveTracker:GetChecked() or Conf_KillFeed ~= Config.panel.killFeed:GetChecked() or Conf_KillingBlow ~= Config.panel.killingBlow:GetChecked() or Conf_HideSpam ~= Config.panel.portraitSpam:GetChecked() or Conf_ClassColours ~= Config.panel.classColours:GetChecked() or Conf_ClassIcon ~= Config.panel.classIcon:GetChecked() or Conf_CastingTimer ~= Config.panel.castingBar:GetChecked() or Conf_OutOfRange ~= Config.panel.rangeIndicator:GetChecked() or Conf_ShowArt ~= Config.panel.barArt:GetChecked() or Conf_AutoRepair ~= Config.panel.autoRepair:GetChecked() or Conf_GuildBankRepair ~= Config.panel.guildRepair:GetChecked() or Conf_SellGreys ~= Config.panel.sellGreys:GetChecked() or Conf_AFKCamera ~= Config.panel.afkCamera:GetChecked() or Conf_ShowCoords ~= Config.panel.playerCoords:GetChecked() or Conf_ShowStats ~= Config.panel.systemStats:GetChecked() or Conf_MinifyGlobals ~= Config.panel.minifyStrings:GetChecked() or Conf_StyleChat ~= Config.panel.styleChat:GetChecked()) then
        return true;
    else
        return false;
    end
end

--[[
    Primary Window Config Stuff Begins
]]
-- Reset all options to the default settings
local function SetDefaults_Primary()
    Config.panel.autoRepair:SetChecked(true);
    Config.panel.guildRepair:SetChecked(true);
    Config.panel.sellGreys:SetChecked(true);
    Config.panel.afkCamera:SetChecked(true);
    Config.panel.playerCoords:SetChecked(true);
    Config.panel.systemStats:SetChecked(true);
    Config.panel.minifyStrings:SetChecked(true);
    Config.panel.styleChat:SetChecked(true);
    Config.panel.barArt:SetChecked(true);
    Config.panel.rangeIndicator:SetChecked(true);
    Config.panel.castingBar:SetChecked(true);
    Config.panel.classIcon:SetChecked(true);
    Config.panel.classColours:SetChecked(true);
    Config.panel.portraitSpam:SetChecked(true);
    Config.panel.killingBlow:SetChecked(true);
    Config.panel.killFeed:SetChecked(true);
    Config.panel.objectiveTracker:SetChecked(true);
    Config.panel.healthWarning:SetChecked(true);
    Config.panel.chatArrows:SetChecked(true);
    Config.panel.interrupts:SetChecked(true);
    Config.panel.healthColour:SetChecked(true);
end

-- Loads the already set config options for the Primary window
local function LoadConfig_Primary()
    Config.panel.autoRepair:SetChecked(Conf_AutoRepair);
    Config.panel.guildRepair:SetChecked(Conf_GuildBankRepair);
    Config.panel.sellGreys:SetChecked(Conf_SellGreys);
    Config.panel.afkCamera:SetChecked(Conf_AFKCamera);
    Config.panel.playerCoords:SetChecked(Conf_ShowCoords);
    Config.panel.systemStats:SetChecked(Conf_ShowStats);
    Config.panel.minifyStrings:SetChecked(Conf_MinifyGlobals);
    Config.panel.styleChat:SetChecked(Conf_StyleChat);
    Config.panel.barArt:SetChecked(Conf_ShowArt);
    Config.panel.rangeIndicator:SetChecked(Conf_OutOfRange);
    Config.panel.castingBar:SetChecked(Conf_CastingTimer);
    Config.panel.classIcon:SetChecked(Conf_ClassIcon);
    Config.panel.classColours:SetChecked(Conf_ClassColours);
    Config.panel.portraitSpam:SetChecked(Conf_HideSpam);
    Config.panel.killingBlow:SetChecked(Conf_KillingBlow);
    Config.panel.killFeed:SetChecked(Conf_KillFeed);
    Config.panel.objectiveTracker:SetChecked(Conf_ObjectiveTracker);
    Config.panel.healthWarning:SetChecked(Conf_HealthUpdate);
    Config.panel.chatArrows:SetChecked(Conf_ChatArrows);
    Config.panel.interrupts:SetChecked(Conf_Interrupts);
    Config.panel.healthColour:SetChecked(Conf_HealthBarColor);
end

-- Applies any changes
local function ApplyChanges_Primary()
    if(ConfigChanged()) then
        Conf_AutoRepair = Config.panel.autoRepair:GetChecked();
        Conf_GuildBankRepair = Config.panel.guildRepair:GetChecked();
        Conf_SellGreys = Config.panel.sellGreys:GetChecked();
        Conf_AFKCamera = Config.panel.afkCamera:GetChecked();
        Conf_ShowCoords = Config.panel.playerCoords:GetChecked();
        Conf_ShowStats = Config.panel.systemStats:GetChecked();
        Conf_MinifyGlobals = Config.panel.minifyStrings:GetChecked();
        Conf_StyleChat = Config.panel.styleChat:GetChecked();
        Conf_ShowArt = Config.panel.barArt:GetChecked();
        Conf_OutOfRange = Config.panel.rangeIndicator:GetChecked();
        Conf_CastingTimer = Config.panel.castingBar:GetChecked();
        Conf_ClassIcon = Config.panel.classIcon:GetChecked();
        Conf_ClassColours = Config.panel.classColours:GetChecked();
        Conf_HideSpam = Config.panel.portraitSpam:GetChecked();
        Conf_KillingBlow = Config.panel.killingBlow:GetChecked();
        Conf_KillFeed = Config.panel.killFeed:GetChecked();
        Conf_ObjectiveTracker = Config.panel.objectiveTracker:GetChecked();
        Conf_HealthUpdate = Config.panel.healthWarning:GetChecked();
        Conf_ChatArrows = Config.panel.chatArrows:GetChecked();
        Conf_Interrupts = Config.panel.interrupts:GetChecked();
        Conf_HealthBarColor = Config.panel.healthColour:GetChecked();
        ReloadUI();
    end
end

-- Checks to see if any of the values are nil. If they are it must be a first load. Set to defaults.
local function CheckFirstLoad()
    if (Conf_AutoRepair == nil) then Conf_AutoRepair = true end
    if (Conf_GuildBankRepair == nil) then Conf_GuildBankRepair = true end
    if (Conf_SellGreys == nil) then Conf_SellGreys = true end
    if (Conf_AFKCamera == nil) then Conf_AFKCamera = true end
    if (Conf_ShowCoords == nil) then Conf_ShowCoords = true end
    if (Conf_ShowStats == nil) then Conf_ShowStats = true end
    if (Conf_MinifyGlobals == nil) then Conf_MinifyGlobals = true end
    if (Conf_StyleChat == nil) then Conf_StyleChat = true end
    if (Conf_ShowArt == nil) then Conf_ShowArt = true end
    if (Conf_OutOfRange == nil) then Conf_OutOfRange = true end
    if (Conf_CastingTimer == nil) then Conf_CastingTimer = true end
    if (Conf_ClassIcon == nil) then Conf_ClassIcon = true end
    if (Conf_ClassColours == nil) then Conf_ClassColours = true end
    if (Conf_HideSpam == nil) then Conf_HideSpam = true end
    if (Conf_KillingBlow == nil) then Conf_KillingBlow = true end
    if (Conf_KillFeed == nil) then Conf_KillFeed = true end
    if (Conf_ObjectiveTracker == nil) then Conf_ObjectiveTracker = true end
    if (Conf_HealthUpdate == nil) then Conf_HealthUpdate = true end
    if (Conf_ChatArrows == nil) then Conf_ChatArrows = true end
    if (Conf_Interrupts == nil) then Conf_Interrupts = true end
    if (Conf_HealthBarColor == nil) then Conf_HealthBarColor = true end
end

-- Event Handler, Only used for detecting when the addon has finished initialising and trigger config loading
local function HandleEvents(self, event, ...)
    if(event == "ADDON_LOADED" and ... == "ImpBlizzardUI") then
        CheckFirstLoad();
        LoadConfig_Primary();
    end
end

-- Builds the Primary (Misc Settings) Config Panel - Parent to all other panels
local function BuildWindow_Primary()
    Config.panel = CreateFrame("Frame", "ImpBlizzardUI_Misc", UIParent);
    Config.panel.name = "Improved Blizzard UI";
    Config.panel.okay = ApplyChanges_Primary;
    Config.panel.cancel = LoadConfig_Primary;
    Config.panel.default = SetDefaults_Primary;

    -- Register the event handler and addon loaded event
    Config.panel:SetScript("OnEvent", HandleEvents);
    Config.panel:RegisterEvent("ADDON_LOADED");

    -- Title
    Config.panel.titleText = Config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    Config.panel.titleText:SetFont(Font, 14, "OUTLINE");
    Config.panel.titleText:SetPoint("TOPLEFT", 190, -10);
    Config.panel.titleText:SetText("|cffffff00 Improved Blizzard UI - v"..GetAddOnMetadata("ImpBlizzardUI", "Version"));

    -- Setup for config headers and check boxes
    local startY = 10;
    local titleX = 60;
    local checkboxX = 15;
    local currentY = startY;

    -- Helper for creating config headers
    local function createHeader(panelName, label)
        currentY = currentY - 40;
        Config.panel[panelName] = Config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        Config.panel[panelName]:SetFont(Font, HeaderFontSize, "OUTLINE");
        Config.panel[panelName]:SetPoint( "TOPLEFT", titleX, currentY);
        Config.panel[panelName]:SetText("|cffffff00 - "..ImpBlizz[label].." - ");
        currentY = currentY + 5;
    end

    -- Helper for creating config checkboxes
    local function createCheckBox(panelName, label, frameName)
        currentY = currentY - 25;
        Config.panel[panelName] = CreateFrame("CheckButton", frameName.."CheckBox", Config.panel, "UICheckButtonTemplate");
        Config.panel[panelName]:ClearAllPoints();
        Config.panel[panelName]:SetPoint("TOPLEFT", checkboxX, currentY);
        _G[Config.panel[panelName]:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
        _G[Config.panel[panelName]:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz[label]);
    end

    --[[
        Misc Config Begins
    ]]
    createHeader("miscHeader", "Miscellaneous");

    createCheckBox("autoRepair", "Auto Repair", "Repair");
    createCheckBox("guildRepair", "Use Guild Bank For Repairs", "GuildRepair");
    createCheckBox("sellGreys", "Auto Sell Trash", "SellGreys");
    createCheckBox("afkCamera", "AFK Mode", "AFKCamera");
    --[[
        Misc Config Ends
    ]]

    --[[
        User Interface Config Begins
    ]]
    createHeader("uiHeader", "User Interface");

    createCheckBox("playerCoords", "Display Player Co-Ordinates", "Coords");
    createCheckBox("systemStats", "Display System Statistics", "Stats");
    --[[
        User Interface Config Ends
    ]]

    --[[
        PvP Config Begins
    ]]
    createHeader("pvpHeader", "PvP");

    createCheckBox("killingBlow", "Highlight Killing Blows", "KillingBlows");
    createCheckBox("killFeed", "Display PvP Kill Tracker", "KillFeed");
    createCheckBox("objectiveTracker", "Auto-Hide Quest Tracker", "ObjectiveTrackerFeed");
    --[[
        User Interface Config Ends
    ]]

    -- Move to right side of config pane
    titleX = 410;
    checkboxX = 365;
    currentY = startY;

    --[[
        Chat Config Begins
    ]]
    createHeader("chatHeader", "Chat");

    createCheckBox("minifyStrings", "Minify Blizzard Strings", "Minify");
    createCheckBox("styleChat", "Style Chat", "Style");
    createCheckBox("chatArrows", "Hide Chat Arrows", "ChatArrows");
    --[[
        Chat Config Ends
    ]]

    --[[
        Action Bar Config Begins
    ]]
    createHeader("actionBarsHeader", "Action Bars");

    createCheckBox("barArt", "Display Art", "Art");
    createCheckBox("rangeIndicator", "Out of Range Indicator", "Range");
    --[[
        Action Bar Config Ends
    ]]

    --[[
        Combat Config Begins
    ]]
    createHeader("combatHeader", "Combat");

    createCheckBox("castingBar", "Casting Bar Timer", "Casting");
    createCheckBox("classIcon", "Display Class Icon", "ClassIcon");
    createCheckBox("classColours", "Display Class Colours", "ClassColours");
    createCheckBox("portraitSpam", "Hide Portrait Spam", "PortraitSpam");
    createCheckBox("healthWarning", "Display Health Warnings", "HealthWarning");
    createCheckBox("interrupts", "Announce Interrupts", "Interrupts");
    createCheckBox("healthColour", "Colourize Health Bars", "HealthColour");
    --[[
        Combat Bar Config Ends
    ]]
end
--[[
    Primary Window Config Stuff Ends
]]

-- Initialise the Config System
local function Init()
    BuildWindow_Primary();
end

-- End of File, Call Init and then add the config to the Blizzard Interface Options window
Init();
InterfaceOptions_AddCategory(Config.panel);
