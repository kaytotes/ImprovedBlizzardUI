--[[
    modules\bars\bags.lua
    Moves the Bag Bar.
]]
ImpUI_Bags = ImpUI:NewModule('ImpUI_Bags', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

local Bags = CreateFrame('Frame', nil, UIParent);

--[[
    Hides or shows the Bag Bar
    @ return void
]]
function ImpUI_Bags:ToggleBagBar()
    if(Bags.bagsVisible) then
        -- Hide them
        Helpers.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, -1, -300, nil);
        Bags.bagsVisible = false;
    else
        --show them
        Helpers.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, 0, 0, nil);
        Bags.bagsVisible = true;
    end
end

--[[
    Does the initial hiding of the Bag Bar.
    @ return void
]]
local function HideBagBar()
    Bags.bagsVisible = true;
    ImpUI_Bags:ToggleBagBar();
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Bags:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Bags:OnEnable()
    self:RegisterEvent('PLAYER_ENTERING_WORLD', HideBagBar);

    self:SecureHook(MainMenuBar, 'ChangeMenuBarSizeAndPosition', HideBagBar);
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Bags:OnDisable()
end