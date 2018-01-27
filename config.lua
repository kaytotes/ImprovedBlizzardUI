local addonName, Loc = ...;

local defaults = {
    afkMode = true,

    styleChat = true,
    overrideBlizzardStrings = true,

    autoRepair = true,
    guildRepair = true,
    autoSell = true,

    healthWarnings = true,
};

--[[
    Adds a Tooltip to a Frame

    @ param Frame $frame The Frame that the tooltip should be added too
    @ param string $text The text that should be displayed on the tooltip
    @ return void
]]
local function AddTooltip(frame, text)
    frame:SetScript('OnEnter', function(self)
        GameTooltip:SetOwner(frame, 'ANCHOR_TOPLEFT');
        GameTooltip:AddLine(text, 1, 1, 0);
        GameTooltip:Show();
    end);
    frame:SetScript('OnLeave', GameTooltip_Hide);
end

local options = LibStub('Wasabi'):New(addonName, 'PrimaryDB', defaults);
options:AddSlash('/ibui');
options:AddSlash('/improvedblizzardui');

options:Initialize(function(self)
    local title = self:CreateTitle();
    title:SetPoint('TOPLEFT', 190, -10);
    title:SetText("Improved Blizzard UI - v"..GetAddOnMetadata("ImprovedBlizzardUI", "Version"));

    -- Miscellaneous Category
    local miscTitle = self:CreateTitle();
    miscTitle:SetPoint('TOPLEFT', 10, -50)
    miscTitle:SetText(Loc['Miscellaneous']);

    local afkMode = self:CreateCheckButton('afkMode');
    afkMode:SetPoint('TOPLEFT', miscTitle, 'BOTTOMLEFT', 0, -8)
    afkMode:SetText(Loc['Enable AFK Mode']);
    AddTooltip(afkMode, Loc['After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.']);

    local autoRepair = self:CreateCheckButton('autoRepair');
    autoRepair:SetPoint('TOPLEFT', afkMode, 'BOTTOMLEFT', 0, 0)
    autoRepair:SetText(Loc['Auto Repair']);
    AddTooltip(autoRepair, Loc['Automatically repairs your armour when you visit a merchant that can repair.']);

    local guildRepair = self:CreateCheckButton('guildRepair');
    guildRepair:SetPoint('TOPLEFT', autoRepair, 'BOTTOMLEFT', 0, 0)
    guildRepair:SetText(Loc['Use Guild Bank For Repairs']);
    AddTooltip(guildRepair, Loc['When automatically repairing allow the use of Guild Bank funds.']);

    local autoSell = self:CreateCheckButton('autoSell');
    autoSell:SetPoint('TOPLEFT', guildRepair, 'BOTTOMLEFT', 0, 0)
    autoSell:SetText(Loc['Auto Sell Trash']);
    AddTooltip(autoSell, Loc['Automatically sells any grey items that are in your inventory.']);

    -- Chat Category
    local chatTitle = self:CreateTitle();
    chatTitle:SetPoint('TOPLEFT', autoSell, 'BOTTOMLEFT', 0, -8)
    chatTitle:SetText(Loc['Chat']);

    local styleChat = self:CreateCheckButton('styleChat');
    styleChat:SetPoint('TOPLEFT', chatTitle, 'BOTTOMLEFT', 0, -8)
    styleChat:SetText(Loc['Style Chat']);
    AddTooltip(styleChat, Loc['Styles the Blizzard Chat frame to better match the rest of the UI.']);

    local overrideBlizzardStrings = self:CreateCheckButton('overrideBlizzardStrings');
    overrideBlizzardStrings:SetPoint('TOPLEFT', styleChat, 'BOTTOMLEFT', 0, 0);
    overrideBlizzardStrings:SetText(Loc['Minify Blizzard Strings']);
    AddTooltip(overrideBlizzardStrings, Loc['Shortens chat messages such as Loot Received, Exp Gain, Skill Gain and Chat Channels.']);

    -- Combat Category
    local combatTitle = self:CreateTitle();
    combatTitle:SetPoint('TOPLEFT', overrideBlizzardStrings, 'BOTTOMLEFT', 0, -8)
    combatTitle:SetText(Loc['Combat']);

    local healthWarnings = self:CreateCheckButton('healthWarnings');
    healthWarnings:SetPoint('TOPLEFT', combatTitle, 'BOTTOMLEFT', 0, -8)
    healthWarnings:SetText(Loc['Display Health Warnings']);
    AddTooltip(healthWarnings, Loc['Displays a five second warning when Player Health is less than 50% and 25%.']);
end);

local frameDefaults = {
    primaryOffsetX = 265,
    primaryOffsetY = 150,
    primaryScale = 1.2,

    stylePrimaryFrames = true,
    playerClassColours = true,
    playerPortraitSpam = true,
    playerHideOOC = true,

    targetBuffsOnTop = true,
    targetClassColours = true,
    targetOfTargetClassColours = true,

    focusClassColours = true,
};

local framesOptions = options:CreateChild(Loc['Frames'], 'FramesDB', frameDefaults);

framesOptions:Initialize(function(self)
    local title = self:CreateTitle();
    title:SetPoint('TOPLEFT', 190, -10);
    title:SetText("Improved Blizzard UI - v"..GetAddOnMetadata("ImprovedBlizzardUI", "Version"));

    local globalTitle = self:CreateTitle();
    globalTitle:SetPoint('TOPLEFT', 10, -50)
    globalTitle:SetText(Loc['Primary']);

    local stylePrimaryFrames = self:CreateCheckButton('stylePrimaryFrames');
    stylePrimaryFrames:SetPoint('TOPLEFT', globalTitle, 'BOTTOMLEFT', 0, -8)
    stylePrimaryFrames:SetText(Loc['Style Unit Frames']);
    AddTooltip(stylePrimaryFrames, Loc['Tweaks textures and structure of Unit Frames.']);

    local primaryScale = self:CreateSlider('primaryScale');
    primaryScale:SetPoint('TOPLEFT', stylePrimaryFrames, 'BOTTOMLEFT', 4, 0);
    primaryScale:SetRange(0.1, 2.0);
    primaryScale:SetStep(0.1);
    AddTooltip(primaryScale, Loc['Player and Target Frame Scale']);

    -- Player Frame
    local playerFrame = self:CreateTitle();
    playerFrame:SetPoint('TOPLEFT', primaryScale, 'BOTTOMLEFT', 0, -24)
    playerFrame:SetText(Loc['Player Frame']);

    local playerClassColours = self:CreateCheckButton('playerClassColours');
    playerClassColours:SetPoint('TOPLEFT', playerFrame, 'BOTTOMLEFT', 0, -8)
    playerClassColours:SetText(Loc['Display Class Colours']);
    AddTooltip(playerClassColours, Loc['Colours your Health bar to match the current class.']);

    local playerPortraitSpam = self:CreateCheckButton('playerPortraitSpam');
    playerPortraitSpam:SetPoint('TOPLEFT', playerClassColours, 'BOTTOMLEFT', 0, 0)
    playerPortraitSpam:SetText(Loc['Hide Portrait Spam']);
    AddTooltip(playerPortraitSpam, Loc['Hides the damage text that appears over the Player portrait when damaged or healed.']);

    local playerHideOOC = self:CreateCheckButton('playerHideOOC');
    playerHideOOC:SetPoint('TOPLEFT', playerPortraitSpam, 'BOTTOMLEFT', 0, 0)
    playerHideOOC:SetText(Loc['Hide Out of Combat']);
    AddTooltip(playerHideOOC, Loc['Hides the Player Frame when you are out of combat, have no target and are at full health.']);

    local targetFrame = self:CreateTitle();
    targetFrame:SetPoint('TOPLEFT', playerHideOOC, 'BOTTOMLEFT', 0, -10)
    targetFrame:SetText(Loc['Target Frame']);

    local targetClassColours = self:CreateCheckButton('targetClassColours');
    targetClassColours:SetPoint('TOPLEFT', targetFrame, 'BOTTOMLEFT', 0, -8)
    targetClassColours:SetText(Loc['Display Class Colours']);
    AddTooltip(targetClassColours, Loc['Colours Target Health bar to match their class.']);

    local targetBuffsOnTop = self:CreateCheckButton('targetBuffsOnTop');
    targetBuffsOnTop:SetPoint('TOPLEFT', targetClassColours, 'BOTTOMLEFT', 0, 0)
    targetBuffsOnTop:SetText(Loc['Buffs On Top']);
    AddTooltip(targetBuffsOnTop, Loc['Displays the Targets Buffs above the Unit Frame.']);

    local targetOfTargetFrame = self:CreateTitle();
    targetOfTargetFrame:SetPoint('TOPLEFT', targetBuffsOnTop, 'BOTTOMLEFT', 0, -10)
    targetOfTargetFrame:SetText(Loc['Target of Target Frame']);

    local targetOfTargetClassColours = self:CreateCheckButton('targetOfTargetClassColours');
    targetOfTargetClassColours:SetPoint('TOPLEFT', targetOfTargetFrame, 'BOTTOMLEFT', 0, -8)
    targetOfTargetClassColours:SetText(Loc['Display Class Colours']);
    AddTooltip(targetOfTargetClassColours, Loc['Colours Target of Target Health bar to match their class.']);

    local focusFrame = self:CreateTitle();
    focusFrame:SetPoint('TOPLEFT', targetOfTargetClassColours, 'BOTTOMLEFT', 0, -10)
    focusFrame:SetText(Loc['Focus Frame']);

    local focusFrameClassColours = self:CreateCheckButton('focusFrameClassColours');
    focusFrameClassColours:SetPoint('TOPLEFT', focusFrame, 'BOTTOMLEFT', 0, -8)
    focusFrameClassColours:SetText(Loc['Display Class Colours']);
    AddTooltip(focusFrameClassColours, Loc['Colours Focus Health bar to match their class.']);
end);

local barDefaults = {
    barTimer = true,
    castingScale = 1.1,

    displayArt = true,
    outOfRange = true,
    barsScale = 1.0,
};

local barOptions = options:CreateChild(Loc['Action Bars'], 'BarsDB', barDefaults);

barOptions:Initialize(function(self)
    local title = self:CreateTitle();
    title:SetPoint('TOPLEFT', 190, -10);
    title:SetText("Improved Blizzard UI - v"..GetAddOnMetadata("ImprovedBlizzardUI", "Version"));

    -- Cast Bar
    local castBarTitle = self:CreateTitle();
    castBarTitle:SetPoint('TOPLEFT', 10, -50);
    castBarTitle:SetText(Loc['Cast Bar']);

    local barTimer = self:CreateCheckButton('barTimer');
    barTimer:SetPoint('TOPLEFT', castBarTitle, 'BOTTOMLEFT', 0, -8)
    barTimer:SetText(Loc['Casting Bar Timer']);
    AddTooltip(barTimer, Loc['Adds a timer in seconds above the Casting Bar.']);

    local castingScale = self:CreateSlider('castingScale');
    castingScale:SetPoint('TOPLEFT', barTimer, 'BOTTOMLEFT', 4, 0);
    castingScale:SetRange(0.1, 2.0);
    castingScale:SetStep(0.1);
    AddTooltip(castingScale, Loc['Casting Bar Scale']);

    local actionBarsTitle = self:CreateTitle();
    actionBarsTitle:SetPoint('TOPLEFT', castingScale, 'BOTTOMLEFT', 0, -24);
    actionBarsTitle:SetText(Loc['Action Bars']);

    local outOfRange = self:CreateCheckButton('outOfRange');
    outOfRange:SetPoint('TOPLEFT', actionBarsTitle, 'BOTTOMLEFT', 0, -8);
    outOfRange:SetText(Loc['Out of Range Indicator']);
    AddTooltip(outOfRange, Loc['When an Ability is not usable due to range the entire Button is highlighted Red.']);

    local barsScale = self:CreateSlider('barsScale');
    barsScale:SetPoint('TOPLEFT', outOfRange, 'BOTTOMLEFT', 4, 0);
    barsScale:SetRange(0.1, 2.0);
    barsScale:SetStep(0.1);
    AddTooltip(barsScale, Loc['Action Bar Scale']);
end);

options:On('Okay', function(self)
    ReloadUI();
end);