-- Create Ace3 Addon.
ImpUI = LibStub('AceAddon-3.0'):NewAddon('ImprovedBlizzardUI', 'AceConsole-3.0', 'AceHook-3.0');

-- Get Localisation
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- LibSharedMedia-3.0
LSM = LibStub('LibSharedMedia-3.0');

--[[
    Opens the Improved Blizzard UI options panel.

    Yes this really does call the exact same function twice. This is due to a Blizzard
    bug that has existed ever since InterfaceOptionsFrame_OpenToCategory was put in
    the game. Since it's been years and would take someone 2 minutes to fix, we 
    can only assume Blizzard just doesn't care and won't ever fix it.
	
    @ return void
]]
function OpenImprovedUIOptions()
    InterfaceOptionsFrame_OpenToCategory(ImpUI.optionsFrame);
    InterfaceOptionsFrame_OpenToCategory(ImpUI.optionsFrame);
end
local isEditing = false;

--[[
	Gets the Draggable UI Elements
]]
local function GetDraggables()
    local draggables = {
        'ImpUI_OSD',
        'ImpUI_Killfeed',
        'ImpUI_Player',
        'ImpUI_Target',
        'ImpUI_CastBar',
        'ImpUI_Buffs',
        'ImpUI_Performance',
    };

    if (Helpers.IsRetail()) then
        table.insert(draggables, 'ImpUI_Focus');
    end

    if (Helpers.IsClassic()) then
        table.insert(draggables, 'ImpUI_Party');
    end

    return draggables;
end

--[[
	Unlocks all of the UI draggable frames.
]]
local function UnlockFrames()
    if (isEditing) then return; end

    for i, module in pairs (GetDraggables()) do
        local m = ImpUI:GetModule(module);
        m:Unlock();
    end 

    isEditing = true;
end

--[[
	Locks all of the UI draggable frames.
]]
local function LockFrames()
    if (isEditing == false) then return; end

    for i, module in pairs (GetDraggables()) do
        local m = ImpUI:GetModule(module);
        m:Lock();
    end 

    isEditing = false;
end

--[[
    Just prints the addons configuration options.
	
    @ return void
]]
local function PrintConfig()
    ImpUI:Print(L['/imp - Open the configuration panel.']);
    ImpUI:Print(L['/imp grid - Toggle a grid to aid in interface element placement.']);
    ImpUI:Print(L['/imp unlock - Unlocks the interfaces movable frames. Locking them saves position.']);
    ImpUI:Print(L['/imp lock - Locks the interfaces movable frames.']);
end

--[[
    Handles the /imp slash command.

    For now just opens options.
	
    @ return void
]]
function ImpUI:HandleSlash(input)
    -- Nothing provided. Just open options and print config commands.
    if (not input or input:trim() == '') then
        OpenImprovedUIOptions();
        PrintConfig();
    end

    local command = input:trim();

    -- Grid
    if (command == 'grid') then
        local grid = ImpUI:GetModule('ImpUI_Grid');
        grid:ToggleGrid();
        return;
    end

    -- Unlock
    if (command == 'unlock') then
        UnlockFrames();
    end

    -- Lock
    if (command == 'lock') then
        LockFrames();
    end
end

--[[
    Iterates through each module, disabling and then enabling each one.
]]
function ImpUI:ReloadAllModules()
    for name, module in ImpUI:IterateModules() do
        module:Disable();
        module:Enable();
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
    self.db = LibStub('AceDB-3.0'):New('ImpUI_DB', ImpUI_Config.defaults, true);

    --Enable Profile Management
    ImpUI_Config.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);

    -- Reload modules after active profile is changed so new settings will take effect
    self.db.RegisterCallback(self, "OnProfileChanged", "ReloadAllModules")
    self.db.RegisterCallback(self, "OnProfileCopied", "ReloadAllModules")
    self.db.RegisterCallback(self, "OnProfileReset", "ReloadAllModules")

    -- Register Config
    LibStub('AceConfig-3.0'):RegisterOptionsTable('ImprovedBlizzardUI', ImpUI_Config.options);

    -- Add to Blizz Config
    self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('ImprovedBlizzardUI', 'Improved Blizzard UI');

    -- Register Slash Command
    self:RegisterChatCommand('imp', 'HandleSlash');

    print(format('|cffffff00Improved Blizzard UI %s - %s (%s) Mode Initialized.', GetAddOnMetadata('ImprovedBlizzardUI', 'Version'), Helpers.GetEnvironment(), Helpers.GetSupportedBuild()));
end