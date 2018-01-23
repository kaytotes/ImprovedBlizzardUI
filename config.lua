local addonName, Loc = ...;

local defaults = {
    afkMode = true,

    styleChat = true,
    overrideBlizzardStrings = true,

    autoRepair = true,
    guildRepair = true,
    autoSell = true,

    healthWarnings = true,

    barTimer = true,
    castingScale = 1.1,
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

local actionBarOptions = options:CreateChild(Loc['Action Bars'], 'ActionBarDB', defaults);

actionBarOptions:Initialize(function(self)
    local title = self:CreateTitle();
    title:SetPoint('TOPLEFT', 190, -10);
    title:SetText("Improved Blizzard UI - v"..GetAddOnMetadata("ImprovedBlizzardUI", "Version"));

    -- Cast Bar
    local castBarTitle = self:CreateTitle();
    castBarTitle:SetPoint('TOPLEFT', 10, -50)
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
end);

options:On('Okay', function(self)
    ReloadUI();
end);

actionBarOptions:On('Okay', function(self)
    ReloadUI();
end);