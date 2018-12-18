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
            }
        },

        -- Combat Tab
        combat = {
            name = L['Combat'],
            desc = L['Combat'],
            type = 'group',
            order = 2,
            args = {
                -- Health Warning Section
                healthHeader = {
                    type = 'header',
                    name = L['Health Warning'],
                    order = 1,
                },

                healthWarnings = {
                    type = 'toggle',
                    name = L['Health Warnings'],
                    desc = L['Displays a five second warning when Player Health is less than 50% and 25%.'],
                    get = 'ShouldDisplayHealthWarning',
                    set = 'SetDisplayHealthWarning',
                    order = 2,
                },

                healthWarningHalfColour = {
                    type = 'color',
                    name = L['50% Colour'],
                    desc = L['The colour of the warning that displays at 50% health.'],
                    get = 'GetHealthWarningHalfColour',
                    set = 'SetHealthWarningHalfColour',
                    disabled = function () 
                        return ImpUI.db.char.healthWarning == false;
                    end,
                    hasAlpha = false,
                    order = 3,
                },

                healthWarningQuarterColour = {
                    type = 'color',
                    name = L['25% Colour'],
                    desc = L['The colour of the warning that displays at 25% health.'],
                    get = 'GetHealthWarningQuarterColour',
                    set = 'SetHealthWarningQuarterColour',
                    disabled = function () 
                        return ImpUI.db.char.healthWarning == false;
                    end,
                    hasAlpha = false,
                    order = 4,
                },

                healthWarningSize = {
                    type = 'range',
                    name = L['Health Warning Size'],
                    desc = L['The size of the Health Warning Display.'],
                    min = 8,
                    max = 104,
                    step = 1,
                    get = 'GetHealthWarningSize',
                    set = 'SetHealthWarningSize',
                    disabled = function () 
                        return ImpUI.db.char.healthWarning == false;
                    end,
                    isPercent = false,
                    order = 5,
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
                    order = 6,
                },

                -- Interrupts Section
                interruptHeader = {
                    type = 'header',
                    name = L['Interrupts'],
                    order = 7,
                },

                announceInterrupts = {
                    type = 'toggle',
                    name = L['Announce Interrupts'],
                    desc = L['When you interrupt a target your character announces this to an appropriate sound channel.'],
                    get = 'ShouldAnnounceInterrupts',
                    set = 'SetAnnounceInterrupts',
                    order = 8,
                },

                interruptChannel = {
                    type = 'select',
                    name = L['Chat Channel'],
                    desc = L['The Channel that should be used when announcing an interrupt. Auto intelligently chooses based on situation.'],
                    get = 'GetInterruptChannel',
                    set = 'SetInterruptChannel',
                    style = 'dropdown',
                    values = 'GetInterruptOptions',
                    disabled = function () 
                        return ImpUI.db.char.announceInterrupts == false;
                    end,
                    order = 9,
                },

                -- Killing Blows Section
                killingBlowsHeader = {
                    type = 'header',
                    name = L['Killing Blows'],
                    order = 10,
                },

                killingBlows = {
                    type = 'toggle',
                    name = L['Highlight Killing Blows'],
                    desc = L['When you get a Killing Blow this will be displayed prominently in the center of the screen.'],
                    get = 'ShouldDisplayKillingBlows',
                    set = 'SetKillingBlows',
                    order = 11,
                },

                killingBlowMessage = {
                    type = 'input',
                    name = L['Killing Blow Message'],
                    desc = L['The message that is displayed in the center of the screen.'],
                    get = 'GetKillingBlowMessage',
                    set = 'SetKillingBlowMessage',
                    disabled = function () 
                        return ImpUI.db.char.killingBlows == false;
                    end,
                    order = 12,
                },

                killingBlowColour = {
                    type = 'color',
                    name = L['Colour'],
                    desc = L['The colour of the Killing Blow notification.'],
                    get = 'GetKillingBlowColour',
                    set = 'SetKillingBlowColour',
                    disabled = function () 
                        return ImpUI.db.char.killingBlows == false;
                    end,
                    hasAlpha = false,
                    order = 13,
                },

                killingBlowSize = {
                    type = 'range',
                    name = L['Killing Blow Size'],
                    desc = L['The size of the Killing Blow notification'],
                    min = 8,
                    max = 104,
                    step = 1,
                    get = 'GetKillingBlowSize',
                    set = 'SetKillingBlowSize',
                    disabled = function () 
                        return ImpUI.db.char.killingBlows == false;
                    end,
                    isPercent = false,
                    order = 14,
                },

                killingBlowFont = {
                    type = 'select',
                    name = L['Killing Blow Font'],
                    desc = L['The font used by the Killing Blow Notification.'],
                    dialogControl = 'LSM30_Font',
                    values = LSM:HashTable( LSM.MediaType.FONT ),
                    get = 'GetKillingBlowFont',
                    set = 'SetKillingBlowFont',
                    disabled = function () 
                        return ImpUI.db.char.killingBlows == false;
                    end,
                    order = 15,
                },

                killingBlowInWorld = {
                    type = 'toggle',
                    name = L['In World'],
                    desc = L['Notification will display in World content.'],
                    get = function (info)
                        return ImpUI.db.char.killingBlowInWorld;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.killingBlowInWorld = newValue;
                    end,
                    disabled = function () 
                        return ImpUI.db.char.killingBlows == false;
                    end,
                    order = 16,
                },

                killingBlowInPvP = {
                    type = 'toggle',
                    name = L['In PvP'],
                    desc = L['Notification will display in PvP content.'],
                    get = function (info)
                        return ImpUI.db.char.killingBlowInPvP;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.killingBlowInPvP = newValue;
                    end,
                    disabled = function () 
                        return ImpUI.db.char.killingBlows == false;
                    end,
                    order = 17,
                },

                killingBlowInInstance = {
                    type = 'toggle',
                    name = L['In Instance'],
                    desc = L['Notification will display in 5 Man instanced content.'],
                    get = function (info)
                        return ImpUI.db.char.killingBlowInInstance;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.killingBlowInInstance = newValue;
                    end,
                    disabled = function () 
                        return ImpUI.db.char.killingBlows == false;
                    end,
                    order = 18,
                },

                killingBlowInRaid = {
                    type = 'toggle',
                    name = L['In Raid'],
                    desc = L['Notification will display in instanced raid content.'],
                    get = function (info)
                        return ImpUI.db.char.killingBlowInRaid;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.killingBlowInRaid = newValue;
                    end,
                    disabled = function () 
                        return ImpUI.db.char.killingBlows == false;
                    end,
                    order = 19,
                },

                -- Automatic Ressurection Section
                autoRelHeader = {
                    type = 'header',
                    name = L['Automatic Release'],
                    order = 20,
                },

                autoRel = {
                    type = 'toggle',
                    name = L['Automatic Release'],
                    desc = L['Automatically release your spirit when you die.'] ,
                    get = function (info)
                        return ImpUI.db.char.autoRel;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.autoRel = newValue;
                    end,
                    order = 21,
                },

                autoRelInWorld = {
                    type = 'toggle',
                    name = L['In World'],
                    desc = '',
                    get = function (info)
                        return ImpUI.db.char.autoRelInWorld;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.autoRelInWorld = newValue;
                    end,
                    disabled = function () 
                        return ImpUI.db.char.autoRel == false;
                    end,
                    order = 22,
                },

                autoRelInInstance = {
                    type = 'toggle',
                    name = L['In Instance'],
                    desc = '',
                    get = function (info)
                        return ImpUI.db.char.autoRelInInstance;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.autoRelInInstance = newValue;
                    end,
                    disabled = function () 
                        return ImpUI.db.char.autoRel == false;
                    end,
                    order = 23,
                },

                autoRelInPvP = {
                    type = 'toggle',
                    name = L['In PvP'],
                    desc = '',
                    get = function (info)
                        return ImpUI.db.char.autoRelInPvP;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.autoRelInPvP = newValue;
                    end,
                    disabled = function () 
                        return ImpUI.db.char.autoRel == false;
                    end,
                    order = 23,
                },

                autoRelInRaid = {
                    type = 'toggle',
                    name = L['In Raid'],
                    desc = '',
                    get = function (info)
                        return ImpUI.db.char.autoRelInRaid;
                    end,
                    set = function (info, newValue)
                        ImpUI.db.char.autoRelInRaid = newValue;
                    end,
                    disabled = function () 
                        return ImpUI.db.char.autoRel == false;
                    end,
                    order = 24,
                }
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
        healthWarningSize = 26,
        healthWarningHalfColour = {
            r = 0,
            g = 1,
            b = 1,
            a = 1,
        },
        healthWarningQuarterColour = {
            r = 1,
            g = 0,
            b = 0,
            a = 1,
        },
        announceInterrupts = true,
        interruptChannel = 1,
        killingBlows = true,
        killingBlowMessage = L['Killing Blow!'],
        killingBlowColour = {
            r = 1,
            g = 1,
            b = 0,
            a = 1,
        },
        killingBlowSize = 26,
        killingBlowFont = 'Improved Blizzard UI',
        killingBlowInWorld = false,
        killingBlowInPvP = true,
        killingBlowInInstance = false,
        killingBlowInRaid = false,

        autoRel = true,
        autoRelInWorld = false,
        autoRelInInstance = false,
        autoRelInPvP = true,
        autoRelInRaid = false,
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