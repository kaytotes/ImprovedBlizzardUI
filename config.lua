local addonName, Loc = ...;

local defaults = {
    afkMode = true,
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

    -- AFK Mode Config
    local afkMode = self:CreateCheckButton('afkMode');
    afkMode:SetPoint('TOPLEFT', miscTitle, 'BOTTOMLEFT', 0, -8)
    afkMode:SetText(Loc['Enable AFK Mode']);
    AddTooltip(afkMode, Loc['After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.']);
end);