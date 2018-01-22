local addonName, Loc = ...;

local defaults = {
    afkMode = true,

    styleChat = true,
    overrideBlizzardStrings = true,

    autoRepair = true,
    guildRepair = true,
    autoSell = true,
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

local options = LibStub('Wasabi'):New(addonName, 'ImprovedBlizzardUIDB', defaults);
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
    AddTooltip(styleChat, Loc['Tweaks X, Y, Z']);

    local overrideBlizzardStrings = self:CreateCheckButton('overrideBlizzardStrings');
    overrideBlizzardStrings:SetPoint('TOPLEFT', styleChat, 'BOTTOMLEFT', 0, 0);
    overrideBlizzardStrings:SetText(Loc['Minify Blizzard Strings']);
    AddTooltip(overrideBlizzardStrings, Loc['Shortens chat messages such as Loot Received, Exp Gain, Skill Gain and Chat Channels.']);
end);

options:On('Okay', function(self)
    ReloadUI();
end);