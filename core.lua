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
    childGroups = "tab",
    args = {
        misc = {
            name = L['Miscellaneous'],
            desc = 'Blah de Blah',
            type = 'group',
            order = 1,
            args = {
                enableAfkMode = {
                    type = 'toggle',
                    name = L['Enable AFK Mode'],
                    desc = 'After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.',
                    get = 'IsAFKEnabled',
                    set = 'SetAFKEnabled',
                    order = 1,
                },
                autoScreenshot = {
                    type = 'toggle',
                    name = L['Achievement Screenshot'],
                    desc = L['Automatically take a screenshot upon earning an achievement.'],
                    get = 'IsAutoScreenshotEnabled',
                    set = 'SetAutoScreenshot',
                    order = 2,
                },
            }
        }
    },
};

-- Configuration Defaults (Per Character DB)
local defaults = {
    char = {
        afkMode = true,
        autoScreenshot = true,
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