-- Create Ace3 Addon.
ImpUI = LibStub('AceAddon-3.0'):NewAddon('ImprovedBlizzardUI', 'AceConsole-3.0');

-- Configuration Table
local config = {};

-- Configuration Options
local options = {
    name = 'Test',
    handler = ImpUI,
    type = 'group',
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "The message to be displayed when you get home.",
            usage = "<Your message>",
            get = "GetMessage",
            set = "SetMessage",
        },
    },
};

-- Configuration Defaults (Per Character DB)
local defaults = {
    profile = {
        message = 'Blah de Blah',
    },
};

-- Where I'm intending on registering modules.
function ImpUI:RegisterModules()
    self:Print('Registering Modules...');
end

-- Called by Ace3 when addon is loaded.
function ImpUI:OnInitialize()
    -- Set up DB
    self.db = LibStub('AceDB-3.0'):New('ImpUI_DB', defaults, true);

    -- Register Config
    LibStub('AceConfig-3.0'):RegisterOptionsTable('ImprovedBlizzardUI', options);

    -- Add to Blizz Config
    self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('ImprovedBlizzardUI', 'ImprovedBlizzardUI');

    -- Register the Modules
    ImpUI:RegisterModules();

    -- Finally print Intialized Message.
    local version = GetAddOnMetadata('ImprovedBlizzardUI', 'Version');
    print('|cffffff00Improved Blizzard UI ' .. version .. ' Initialized.');
end