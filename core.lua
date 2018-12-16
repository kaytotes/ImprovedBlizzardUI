-- Create Ace3 Addon.
ImpUI = LibStub('AceAddon-3.0'):NewAddon('ImprovedBlizzardUI', 'AceConsole-3.0');

-- Register Slash Command
ImpUI:RegisterChatCommand('imp', 'HandleSlash');

-- Called by Ace3 when addon is loaded.
function ImpUI:OnInitialize()
    local version = GetAddOnMetadata('ImprovedBlizzardUI', 'Version');

    print('|cffffff00Improved Blizzard UI ' .. version .. ' Initialised.');
end

-- Slash command handler. Basically unused for now.
function ImpUI:HandleSlash(input)
    ImpUI:Print(input);
end