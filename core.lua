-- Create Ace3 Addon.
ImpUI = LibStub('AceAddon-3.0'):NewAddon('ImprovedBlizzardUI', 'AceConsole-3.0');

-- Get Localisation
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Get Addon Version
local version = GetAddOnMetadata('ImprovedBlizzardUI', 'Version');

-- Configuration Table
local config = {};

-- Configuration Options
local options = {
    name = 'Improved Blizzard UI - '..version,
    handler = ImpUI,
    type = 'group',
    args = {
        enableAfkMode = {
            type = 'toggle',
            name = L['Enable AFK Mode'],
            desc = 'After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.',
            get = 'IsAFKEnabled',
            set = 'SetAFKEnabled',
        },
    },
};

-- Configuration Defaults (Per Character DB)
local defaults = {
    char = {
        afkMode  = true,
    },
};

-- Called by Ace3 when addon is loaded.
function ImpUI:OnInitialize()
    -- Set up DB
    self.db = LibStub('AceDB-3.0'):New('ImpUI_DB', defaults, true);

    -- Register Config
    LibStub('AceConfig-3.0'):RegisterOptionsTable('ImprovedBlizzardUI', options);

    -- Add to Blizz Config
    self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('ImprovedBlizzardUI', 'Improved Blizzard UI');

    -- Finally print Intialized Message.
    print('|cffffff00Improved Blizzard UI ' .. version .. ' Initialized.');
end