--[[
    ImpBlizzardUI/config.lua
    Handles the various config settings within ImpBlizzardUI and builds the config pane itself.
    Current 
    Todo: 
]]

local _, ImpBlizz = ...;

local MiscConfig = {};

-- Load Fonts and set the sizes etc
local Font = "Interface\\Addons\\ImpBlizzardUI\\media\\impfont.ttf";
local CheckBoxFontSize = 14;
local CheckBoxOffset = -30;
local HeaderFontSize = 16;

-- Simply checks if any of the options have changed. This is basically a huge if statement
local function OptionChanged()

end

-- Reset all options to the default settings
local function SetDefaults()

end

-- Builds the Primary (Misc Settings) Config Panel
local function BuildPrimaryWindow()

end

-- Initialise the Config System
local function Init()
    BuildPrimaryWindow();
end

-- End of File, Call Init and then add the config to the Blizzard Interface Options window
Init();
InterfaceOptions_AddCategory(Config.panel);