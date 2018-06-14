local addonName, Loc = ...;

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

local defaults = {
    afkMode = true,

    styleChat = true,
    overrideBlizzardStrings = true,

    autoRepair = true,
    guildRepair = true,
    autoSell = true,
    autoScreenshot = true,

    toggleObjective = true,

    healthWarnings = true,
    announceInterrupts = true,

    killingBlows = true,
    autoRes = true,

    anchorMouse = true,
    styleTooltips = true,
    guildColour = 'ffff87ff',
    hostileBorder = true,
    nameClassColours = true,
    tooltipToT = true,
    tooltipClassHealth = true,
    tooltipFontSize = 12,
};

local options = LibStub('Wasabi'):New(addonName, 'PrimaryDB', defaults);
options:AddSlash('/imp');

options:Initialize(function(self)
    local title = self:CreateTitle();
    title:SetPoint('TOPLEFT', 190, -10);
    title:SetText('Improved Blizzard UI - v'..GetAddOnMetadata('ImprovedBlizzardUI', 'Version'));

    -- Miscellaneous Category
    local miscTitle = self:CreateTitle();
    miscTitle:SetPoint('TOPLEFT', 10, -50);
    miscTitle:SetText(Loc['Miscellaneous']);

    local afkMode = self:CreateCheckButton('afkMode');
    afkMode:SetPoint('TOPLEFT', miscTitle, 'BOTTOMLEFT', 0, -8);
    afkMode:SetText(Loc['Enable AFK Mode']);
    AddTooltip(afkMode, Loc['After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.']);

    local autoRepair = self:CreateCheckButton('autoRepair');
    autoRepair:SetPoint('TOPLEFT', afkMode, 'BOTTOMLEFT', 0, 0);
    autoRepair:SetText(Loc['Auto Repair']);
    AddTooltip(autoRepair, Loc['Automatically repairs your armour when you visit a merchant that can repair.']);

    local guildRepair = self:CreateCheckButton('guildRepair');
    guildRepair:SetPoint('TOPLEFT', autoRepair, 'BOTTOMLEFT', 0, 0);
    guildRepair:SetText(Loc['Use Guild Bank For Repairs']);
    AddTooltip(guildRepair, Loc['When automatically repairing allow the use of Guild Bank funds.']);

    local autoSell = self:CreateCheckButton('autoSell');
    autoSell:SetPoint('TOPLEFT', guildRepair, 'BOTTOMLEFT', 0, 0);
    autoSell:SetText(Loc['Auto Sell Trash']);
    AddTooltip(autoSell, Loc['Automatically sells any grey items that are in your inventory.']);

    local toggleObjective = self:CreateCheckButton('toggleObjective');
    toggleObjective:SetPoint('TOPLEFT', autoSell, 'BOTTOMLEFT', 0, 0);
    toggleObjective:SetText(Loc['Dynamic Objective Tracker']);
    AddTooltip(toggleObjective, Loc['When you enter an instanced area the Objective Tracker will automatically close.']);

    local autoScreenshot = self:CreateCheckButton('autoScreenshot');
    autoScreenshot:SetPoint('TOPLEFT', toggleObjective, 'BOTTOMLEFT', 0, 0);
    autoScreenshot:SetText(Loc['Achievement Screenshot']);
    AddTooltip(autoScreenshot, Loc['Automatically take a screenshot upon earning an achievement.']);

    -- Chat Category
    local chatTitle = self:CreateTitle();
    chatTitle:SetPoint('TOPLEFT', autoScreenshot, 'BOTTOMLEFT', 0, -8);
    chatTitle:SetText(Loc['Chat']);

    local styleChat = self:CreateCheckButton('styleChat');
    styleChat:SetPoint('TOPLEFT', chatTitle, 'BOTTOMLEFT', 0, -8);
    styleChat:SetText(Loc['Style Chat']);
    AddTooltip(styleChat, Loc['Styles the Blizzard Chat frame to better match the rest of the UI.']);

    local overrideBlizzardStrings = self:CreateCheckButton('overrideBlizzardStrings');
    overrideBlizzardStrings:SetPoint('TOPLEFT', styleChat, 'BOTTOMLEFT', 0, 0);
    overrideBlizzardStrings:SetText(Loc['Minify Blizzard Strings']);
    AddTooltip(overrideBlizzardStrings, Loc['Shortens chat messages such as Loot Received, Exp Gain, Skill Gain and Chat Channels.']);

    -- Combat Category
    local combatTitle = self:CreateTitle();
    combatTitle:SetPoint('TOPLEFT', overrideBlizzardStrings, 'BOTTOMLEFT', 0, -8);
    combatTitle:SetText(Loc['Combat']);

    local healthWarnings = self:CreateCheckButton('healthWarnings');
    healthWarnings:SetPoint('TOPLEFT', combatTitle, 'BOTTOMLEFT', 0, -8);
    healthWarnings:SetText(Loc['Display Health Warnings']);
    AddTooltip(healthWarnings, Loc['Displays a five second warning when Player Health is less than 50% and 25%.']);

    local announceInterrupts = self:CreateCheckButton('announceInterrupts');
    announceInterrupts:SetPoint('TOPLEFT', healthWarnings, 'BOTTOMLEFT', 0, 0);
    announceInterrupts:SetText(Loc['Announce Interrupts']);
    AddTooltip(announceInterrupts, Loc['When you interrupt a target your character announces this to an appropriate sound channel.']);

    -- PvP Category
    local pvpTitle = self:CreateTitle();
    pvpTitle:SetPoint('TOPLEFT', announceInterrupts, 'BOTTOMLEFT', 0, -8);
    pvpTitle:SetText(Loc['PvP']);

    local killingBlows = self:CreateCheckButton('killingBlows');
    killingBlows:SetPoint('TOPLEFT', pvpTitle, 'BOTTOMLEFT', 0, -8);
    killingBlows:SetText(Loc['Highlight Killing Blows']);
    AddTooltip(killingBlows, Loc['When you get a Killing Blow in a Battleground or Arena this will be displayed prominently in the center of the screen.']);

    local autoRes = self:CreateCheckButton('autoRes');
    autoRes:SetPoint('TOPLEFT', killingBlows, 'BOTTOMLEFT', 0, 0);
    autoRes:SetText(Loc['Automatic Ressurection']);
    AddTooltip(autoRes, Loc['When you die in a Battleground you are automatically ressurected.']);

    -- Tooltips Category
    local tooltipsTitle = self:CreateTitle();
    tooltipsTitle:SetPoint('TOPLEFT', 250, -50);
    tooltipsTitle:SetText(Loc['Tooltips']);

    local anchorMouse = self:CreateCheckButton('anchorMouse');
    anchorMouse:SetPoint('TOPLEFT', tooltipsTitle, 'BOTTOMLEFT', 0, -8);
    anchorMouse:SetText(Loc['Anchor To Mouse']);
    AddTooltip(anchorMouse, Loc['The Tooltip will always display at the mouse location.']);
    
    local styleTooltips = self:CreateCheckButton('styleTooltips');
    styleTooltips:SetPoint('TOPLEFT', anchorMouse, 'BOTTOMLEFT', 0, 0);
    styleTooltips:SetText(Loc['Style Tooltips']);
    AddTooltip(styleTooltips, Loc['Adjusts the Fonts and behavior of the default Tooltips.']);

    local hostileBorder = self:CreateCheckButton('hostileBorder');
    hostileBorder:SetPoint('TOPLEFT', styleTooltips, 'BOTTOMLEFT', 0, 0);
    hostileBorder:SetText(Loc['Hostile Border']);
    AddTooltip(hostileBorder, Loc['Colours the Border of the Tooltip based on the hostility of the target.']);

    local nameClassColours = self:CreateCheckButton('nameClassColours');
    nameClassColours:SetPoint('TOPLEFT', hostileBorder, 'BOTTOMLEFT', 0, 0);
    nameClassColours:SetText(Loc['Class Coloured Name']);
    AddTooltip(nameClassColours, Loc['Colours the name of the Target to match their Class.']);

    local tooltipToT = self:CreateCheckButton('tooltipToT');
    tooltipToT:SetPoint('TOPLEFT', nameClassColours, 'BOTTOMLEFT', 0, 0);
    tooltipToT:SetText(Loc['Show Target of Target']);
    AddTooltip(tooltipToT, Loc['Displays who / what the unit is targeting. Coloured by Class.']);

    local tooltipClassHealth = self:CreateCheckButton('tooltipClassHealth');
    tooltipClassHealth:SetPoint('TOPLEFT', tooltipToT, 'BOTTOMLEFT', 0, 0);
    tooltipClassHealth:SetText(Loc['Class Colour Health Bar']);
    AddTooltip(tooltipClassHealth, Loc['Colours the Tooltip Health Bar by Class.']);

    local guildColour = self:CreateColorPicker('guildColour');
	guildColour:SetPoint('TOPLEFT', tooltipClassHealth, 'BOTTOMLEFT', 5, -3);
    guildColour:SetText(Loc['Guild Colour']);

    local tooltipFontSize = self:CreateSlider('tooltipFontSize');
    tooltipFontSize:SetPoint('TOPLEFT', guildColour, 'BOTTOMLEFT', 4, -10);
    tooltipFontSize:SetRange(7, 20);
    tooltipFontSize:SetStep(1);
    AddTooltip(tooltipFontSize, Loc['Font Size']);
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

    showMinimapCoords = true,
    replaceZoom = true,
    showPerformance = true,

    killFeed = true,
    showInWorld = false,
    showInDungeons = true,
    showInRaids = true,
    showInPvP = true,
    showSpell = true,
    showDamage = true,
    inactiveFade = true,
    fontSize = 17,

    showMapDungeons = true,
    showCursorCoords = true,
};

local framesOptions = options:CreateChild(Loc['Frames'], 'FramesDB', frameDefaults);

framesOptions:Initialize(function(self)
    local title = self:CreateTitle();
    title:SetPoint('TOPLEFT', 190, -10);
    title:SetText('Improved Blizzard UI - v'..GetAddOnMetadata('ImprovedBlizzardUI', 'Version'));

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

    local focusClassColours = self:CreateCheckButton('focusClassColours');
    focusClassColours:SetPoint('TOPLEFT', focusFrame, 'BOTTOMLEFT', 0, -8)
    focusClassColours:SetText(Loc['Display Class Colours']);
    AddTooltip(focusClassColours, Loc['Colours Focus Health bar to match their class.']);

    local minimapTitle = self:CreateTitle();
    minimapTitle:SetPoint('TOPLEFT', 250, -50)
    minimapTitle:SetText(Loc['Mini Map']);

    local showMinimapCoords = self:CreateCheckButton('showMinimapCoords');
    showMinimapCoords:SetPoint('TOPLEFT', minimapTitle, 'BOTTOMLEFT', 0, -8)
    showMinimapCoords:SetText(Loc['Display Player Co-Ordinates']);
    AddTooltip(showMinimapCoords, Loc['Adds a frame to the Mini Map showing the players location in the world. Does not work in Dungeons.']);

    local replaceZoom = self:CreateCheckButton('replaceZoom');
    replaceZoom:SetPoint('TOPLEFT', showMinimapCoords, 'BOTTOMLEFT', 0, 0)
    replaceZoom:SetText(Loc['Replace Zoom Functionality']);
    AddTooltip(replaceZoom, Loc['Hides the Zoom Buttons and enables scroll wheel zooming.']);

    local showPerformance = self:CreateCheckButton('showPerformance');
    showPerformance:SetPoint('TOPLEFT', replaceZoom, 'BOTTOMLEFT', 0, 0);
    showPerformance:SetText(Loc['Display System Statistics']);
    AddTooltip(showPerformance, Loc['Displays FPS and Latency above the Mini Map.']);

    -- World Map Title
    local worldMapTitle = self:CreateTitle();
    worldMapTitle:SetPoint('TOPLEFT', showPerformance, 'BOTTOMLEFT', 0, -24);
    worldMapTitle:SetText(Loc['World Map']);

    local showMapDungeons = self:CreateCheckButton('showMapDungeons');
    showMapDungeons:SetPoint('TOPLEFT', worldMapTitle, 'BOTTOMLEFT', 0, -8);
    showMapDungeons:SetText(Loc['Show Instance Portals']);
    AddTooltip(showMapDungeons, Loc['Displays the location of old world Raids and Dungeons.']);

    local showCursorCoords = self:CreateCheckButton('showCursorCoords');
    showCursorCoords:SetPoint('TOPLEFT', showMapDungeons, 'BOTTOMLEFT', 0, 0);
    showCursorCoords:SetText(Loc['Show Cursor Co-ordinates']);
    AddTooltip(showCursorCoords, Loc['Displays the world location of where you are highlighting.']);

    -- Kill Feed Title
    local killFeedTitle = self:CreateTitle();
    killFeedTitle:SetPoint('TOPLEFT', showCursorCoords, 'BOTTOMLEFT', 0, -10);
    killFeedTitle:SetText(Loc['Kill Feed']);

    local killFeed = self:CreateCheckButton('killFeed');
    killFeed:SetPoint('TOPLEFT', killFeedTitle, 'BOTTOMLEFT', 0, -8);
    killFeed:SetText(Loc['Enable Kill Feed']);
    AddTooltip(killFeed, Loc['Displays a feed of the last 5 kills that occur around you when in Instances and optionally out in the World.']);

    local showInWorld = self:CreateCheckButton('showInWorld');
    showInWorld:SetPoint('TOPLEFT', killFeed, 'BOTTOMLEFT', 0, 0);
    showInWorld:SetText(Loc['Show In World']);
    AddTooltip(showInWorld, Loc['Displays the Kill Feed when solo in the world.']);

    local showInDungeons = self:CreateCheckButton('showInDungeons');
    showInDungeons:SetPoint('TOPLEFT', showInWorld, 'BOTTOMLEFT', 0, 0);
    showInDungeons:SetText(Loc['Show In Dungeons']);
    AddTooltip(showInDungeons, Loc['Displays the Kill Feed when in 5 man Dungeons.']);

    local showInRaids = self:CreateCheckButton('showInRaids');
    showInRaids:SetPoint('TOPLEFT', showInDungeons, 'BOTTOMLEFT', 0, 0);
    showInRaids:SetText(Loc['Show In Raids']);
    AddTooltip(showInRaids, Loc['Displays the Kill Feed when in Raids.']);

    local showInPvP = self:CreateCheckButton('showInPvP');
    showInPvP:SetPoint('TOPLEFT', showInRaids, 'BOTTOMLEFT', 0, 0);
    showInPvP:SetText(Loc['Show In PvP']);
    AddTooltip(showInPvP, Loc['Displays the Kill Feed when in Instanced PvP (Arenas and Battlegrounds).']);

    local showSpell = self:CreateCheckButton('showSpell');
    showSpell:SetPoint('TOPLEFT', showInPvP, 'BOTTOMLEFT', 0, 0);
    showSpell:SetText(Loc['Show Casted Spell']);
    AddTooltip(showSpell, Loc['Show the Spell that caused a death.']);

    local showDamage = self:CreateCheckButton('showDamage');
    showDamage:SetPoint('TOPLEFT', showSpell, 'BOTTOMLEFT', 0, 0);
    showDamage:SetText(Loc['Show Damage']);
    AddTooltip(showDamage, Loc['Show how much damage the Creature or Player took.']);

    local inactiveFade = self:CreateCheckButton('inactiveFade');
    inactiveFade:SetPoint('TOPLEFT', showDamage, 'BOTTOMLEFT', 0, 0);
    inactiveFade:SetText(Loc['Hide When Inactive']);
    AddTooltip(inactiveFade, Loc['Hides the Kill Feed after no new events have occured for a short period.']);

    local fontSize = self:CreateSlider('fontSize');
    fontSize:SetPoint('TOPLEFT', inactiveFade, 'BOTTOMLEFT', 4, -10);
    fontSize:SetRange(10, 30);
    fontSize:SetStep(1);
    AddTooltip(fontSize, Loc['Font Size']);
end);

local barDefaults = {
    showArt = true,
    barTimer = true,
    castingScale = 1.1,

    outOfRange = true,
    barsScale = 1.0,

    showMainText = true,
    showBottomLeftText = true,
    showBottomRightText = true,
    showLeftText = true,
    showRightText = true,

    buffScale = 1.1,
};

local barOptions = options:CreateChild(Loc['Action Bars'], 'BarsDB', barDefaults);

barOptions:Initialize(function(self)
    local title = self:CreateTitle();
    title:SetPoint('TOPLEFT', 190, -10);
    title:SetText('Improved Blizzard UI - v'..GetAddOnMetadata('ImprovedBlizzardUI', 'Version'));

    -- Cast Bars
    local castBarTitle = self:CreateTitle();
    castBarTitle:SetPoint('TOPLEFT', 10, -50);
    castBarTitle:SetText(Loc['Cast Bars']);

    -- Player Cast Bar Timer
    local barTimer = self:CreateCheckButton('barTimer');
    barTimer:SetPoint('TOPLEFT', castBarTitle, 'BOTTOMLEFT', 0, -8)
    barTimer:SetText(Loc['Cast Bar Timer']);
    AddTooltip(barTimer, Loc['Adds a timer in seconds above the Cast Bar.']);

    local castingScale = self:CreateSlider('castingScale');
    castingScale:SetPoint('TOPLEFT', barTimer, 'BOTTOMLEFT', 4, 0);
    castingScale:SetRange(0.1, 2.0);
    castingScale:SetStep(0.1);
    AddTooltip(castingScale, Loc['Cast Bar Scale']);

    -- Target Cast Bar Timer
    local targetBarTimer = self:CreateCheckButton('targetBarTimer');
    targetBarTimer:SetPoint('TOPLEFT', castingScale, 'BOTTOMLEFT', -4, -12)
    targetBarTimer:SetText(Loc['Target Cast Bar Timer']);
    AddTooltip(targetBarTimer, Loc["Adds a timer in seconds above the Target's Cast Bar."]);

    -- Focus Cast Bar Timer
    local focusBarTimer = self:CreateCheckButton('focusBarTimer');
    focusBarTimer:SetPoint('TOPLEFT', targetBarTimer, 'BOTTOMLEFT', 0, 0)
    focusBarTimer:SetText(Loc['Focus Cast Bar Timer']);
    AddTooltip(focusBarTimer, Loc["Adds a timer in seconds above the Focus' Cast Bar."]);

    local actionBarsTitle = self:CreateTitle();
    actionBarsTitle:SetPoint('TOPLEFT', focusBarTimer, 'BOTTOMLEFT', 0, -24);
    actionBarsTitle:SetText(Loc['Action Bars']);

    local outOfRange = self:CreateCheckButton('outOfRange');
    outOfRange:SetPoint('TOPLEFT', actionBarsTitle, 'BOTTOMLEFT', 0, -8);
    outOfRange:SetText(Loc['Out of Range Indicator']);
    AddTooltip(outOfRange, Loc['When an Ability is not usable due to range the entire Button is highlighted Red.']);

    local showMainText = self:CreateCheckButton('showMainText');
    showMainText:SetPoint('TOPLEFT', outOfRange, 'BOTTOMLEFT', 0, 0);
    showMainText:SetText(Loc['Show Main Action Bar Text']);
    AddTooltip(showMainText, Loc['Disabling Hides Macro Name Text and Hotkey Text from the specified Action Bar']);

    local showBottomLeftText = self:CreateCheckButton('showBottomLeftText');
    showBottomLeftText:SetPoint('TOPLEFT', showMainText, 'BOTTOMLEFT', 0, 0);
    showBottomLeftText:SetText(Loc['Show Bottom Left Bar Text']);
    AddTooltip(showBottomLeftText, Loc['Disabling Hides Macro Name Text and Hotkey Text from the specified Action Bar']);

    local showBottomRightText = self:CreateCheckButton('showBottomRightText');
    showBottomRightText:SetPoint('TOPLEFT', showBottomLeftText, 'BOTTOMLEFT', 0, 0);
    showBottomRightText:SetText(Loc['Show Bottom Right Bar Text']);
    AddTooltip(showBottomRightText, Loc['Disabling Hides Macro Name Text and Hotkey Text from the specified Action Bar']);

    local showRightText = self:CreateCheckButton('showRightText');
    showRightText:SetPoint('TOPLEFT', showBottomRightText, 'BOTTOMLEFT', 0, 0);
    showRightText:SetText(Loc['Show Right 1 Bar Text']);
    AddTooltip(showRightText, Loc['Disabling Hides Macro Name Text and Hotkey Text from the specified Action Bar']);

    local showLeftText = self:CreateCheckButton('showLeftText');
    showLeftText:SetPoint('TOPLEFT', showRightText, 'BOTTOMLEFT', 0, 0);
    showLeftText:SetText(Loc['Show Right 2 Bar Text']);
    AddTooltip(showLeftText, Loc['Disabling Hides Macro Name Text and Hotkey Text from the specified Action Bar']);

    local barsScale = self:CreateSlider('barsScale');
    barsScale:SetPoint('TOPLEFT', showLeftText, 'BOTTOMLEFT', 4, 0);
    barsScale:SetRange(0.1, 2.0);
    barsScale:SetStep(0.1);
    AddTooltip(barsScale, Loc['Action Bar Scale']);

    local buffsTitle = self:CreateTitle();
    buffsTitle:SetPoint('TOPLEFT', barsScale, 'BOTTOMLEFT', 0, -24);
    buffsTitle:SetText(Loc['Buffs and Debuffs']);

    local buffScale = self:CreateSlider('buffScale');
    buffScale:SetPoint('TOPLEFT', buffsTitle, 'BOTTOMLEFT', 4, -8);
    buffScale:SetRange(0.1, 2.0);
    buffScale:SetStep(0.1);
    AddTooltip(buffScale, Loc['Buffs and Debuffs Scale']);
end);

options:On('Okay', function(self)
    ReloadUI();
end);