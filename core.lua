-- Create Ace3 Addon.
ImpUI = LibStub('AceAddon-3.0'):NewAddon('ImprovedBlizzardUI', 'AceConsole-3.0', 'AceHook-3.0');

-- Get Localisation
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- LibSharedMedia-3.0
LSM = LibStub('LibSharedMedia-3.0');

-- Get Addon Version
local version = GetAddOnMetadata('ImprovedBlizzardUI', 'Version');

-- Configuration Options
local options = {
    name = 'Improved Blizzard UI - '..version,
    handler = ImpUI,
    type = 'group',
    childGroups = "tab",
    args = {
        -- Miscellaneous Tab
        misc = {
            name = L['Miscellaneous'],
            desc = L['Miscellaneous'],
            type = 'group',
            args = {
                enableAfkMode = {
                    type = 'toggle',
                    name = L['Enable AFK Mode'],
                    desc = 'After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.',
                    get = 'IsAFKEnabled',
                    set = 'SetAFKEnabled',
                    order = 1,
                },
                autoRepair = {
                    type = 'toggle',
                    name = L['Auto Repair'],
                    desc = L['Automatically repairs your armour when you visit a merchant that can repair.'],
                    get = 'IsAutoRepairEnabled',
                    set = 'SetAutoRepairEnabled',
                    order = 2,
                },
                guildRepair = {
                    type = 'toggle',
                    name = L['Use Guild Bank For Repairs'],
                    desc = L['When automatically repairing allow the use of Guild Bank funds.'],
                    get = 'IsGuildRepairEnabled',
                    set = 'SetGuildRepairEnabled',
                    order = 3,
                },
                autoSell = {
                    type = 'toggle',
                    name = L['Auto Sell Trash'],
                    desc = L['Automatically sells any grey items that are in your inventory.'],
                    get = 'IsAutoSellEnabled',
                    set = 'SetAutoSellEnabled',
                    order = 4,
                },
                autoScreenshot = {
                    type = 'toggle',
                    name = L['Achievement Screenshot'],
                    desc = L['Automatically take a screenshot upon earning an achievement.'],
                    get = 'IsAutoScreenshotEnabled',
                    set = 'SetAutoScreenshot',
                    order = 5,
                },

                -- Chat Section
                chatHeader = {
                    type = 'header',
                    name = L['Chat'],
                    order = 6,
                },

                overrideStrings = {
                    type = 'toggle',
                    name = L['Minify Blizzard Strings'],
                    desc = L['Shortens chat messages such as Loot Received, Exp Gain, Skill Gain and Chat Channels.'],
                    get = 'ShouldMinifyStrings',
                    set = 'SetMinifyStrings',
                    order = 7,
                },

                styleChat = {
                    type = 'toggle',
                    name = L['Style Chat'],
                    desc = L['Styles the Blizzard Chat frame to better match the rest of the UI.'],
                    get = 'ShouldStyleChat',
                    set = 'SetStyleChat',
                    order = 8,
                },

                chatFont = {
                    type = 'select',
                    name = L['Chat Font'],
                    desc = L['Sets the font used for the chat window, tabs etc.'],
                    dialogControl = 'LSM30_Font',
                    values = LSM:HashTable( LSM.MediaType.FONT ),
                    get = 'GetChatFont',
                    set = 'SetChatFont',
                    disabled = function () 
                        return ImpUI.db.char.styleChat == false;
                    end,
                    order = 9,
                },

                outlineChat = {
                    type = 'toggle',
                    name = L['Outline Font'],
                    desc = L['Applies a thin outline to text rendered in the chat windows.'],
                    get = 'GetChatOutline',
                    set = 'SetChatOutline',
                    disabled = function () 
                        return ImpUI.db.char.styleChat == false;
                    end,
                    order = 10,
                },

                -- Combat Section
                combatHeader = {
                    type = 'header',
                    name = L['Combat'],
                    order = 11,
                },

                healthWarnings = {
                    type = 'toggle',
                    name = L['Display Health Warnings'],
                    desc = L['Displays a five second warning when Player Health is less than 50% and 25%.'],
                    get = 'ShouldDisplayHealthWarning',
                    set = 'SetDisplayHealthWarning',
                    order = 12,
                },

                healthWarningFont = {
                    type = 'select',
                    name = L['Health Warning Font'],
                    desc = L['The font used by the Health Warning On Screen Display Message'],
                    dialogControl = 'LSM30_Font',
                    values = LSM:HashTable( LSM.MediaType.FONT ),
                    get = 'GetHealthWarningFont',
                    set = 'SetHealthWarningFont',
                    disabled = function () 
                        return ImpUI.db.char.healthWarning == false;
                    end,
                    order = 13,
                },
            }
        },
    },
};

-- Configuration Defaults (Per Character DB)
local defaults = {
    char = {
        afkMode = true,
        autoScreenshot = true,
        autoRepair = true,
        guildRepair = true,
        autoSell = true,
        minifyStrings = true,
        styleChat = true,
        chatFont = 'Improved Blizzard UI',
        outlineChat = true,
        healthWarnings = true,
        healthWarningFont = 'Improved Blizzard UI',
    },
};

--[[
    Opens the Improved Blizzard UI options panel.

    Yes this really does call the exact same function twice. This is due to a Blizzard
    bug that has existed ever since InterfaceOptionsFrame_OpenToCategory was put in
    the game. Since it's been years and would take someone 2 minutes to fix, we 
    can only assume Blizzard just doesn't care and won't ever fix it.
	
    @ return void
]]
function ImpUI:OpenOptions()
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame);
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame);
end

--[[
    Handles the /imp slash command.

    For now just opens options.
	
    @ return void
]]
function ImpUI:HandleSlash(input)
    if (not input or input:trim() == '') then
        self:OpenOptions();
    end
end

--[[
	Fires when the Addon is Initialised.
	
    @ return void
]]
function ImpUI:OnInitialize()
    -- Set up Improved Blizzard UI font.
    LSM:Register(LSM.MediaType.FONT, 'Improved Blizzard UI', [[Interface\AddOns\ImprovedBlizzardUI\media\ImprovedBlizzardUI.ttf]]);

    -- Set up DB
    self.db = LibStub('AceDB-3.0'):New('ImpUI_DB', defaults, true);

    -- Register Config
    LibStub('AceConfig-3.0'):RegisterOptionsTable('ImprovedBlizzardUI', options);

    -- Add to Blizz Config
    self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('ImprovedBlizzardUI', 'Improved Blizzard UI');

    -- Register Slash Command
    self:RegisterChatCommand('imp', 'HandleSlash');

    -- Finally print Intialized Message.
    print('|cffffff00Improved Blizzard UI ' .. version .. ' Initialized.');
end