--[[
    modules\bars\actionbars.lua
    Handles setting up the primary Bottom Left, Top Left, Top Right Bars
]]
ImpUI_Bars = ImpUI:NewModule('ImpUI_Bars', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

--[[
    Handles the hiding of Macro and Hotkey text from each button on an Action Bar
	@params string $actionBar The string name of the actionbar buttons, assumes 12 exist
	@params bool $show Whether or not the text should be shown
    @ return void
]]
local function StyleButtons(actionBar, show)
	for i = 1, 12 do 
		if (show == false) then
			_G[actionBar..i..'HotKey']:SetAlpha(0);
            _G[actionBar..i..'Name']:SetAlpha(0);
        else
            _G[actionBar..i..'HotKey']:SetAlpha(1);
            _G[actionBar..i..'Name']:SetAlpha(1);
		end
	end
end

--[[
    Based on config shows or hides the Action Bar Button text.
    @ return void
]]
function ApplyButtonStyles()
    local showMainText = ImpUI.db.profile.showMainText;
    local showBottomLeftText = ImpUI.db.profile.showBottomLeftText;
    local showBottomRightText = ImpUI.db.profile.showBottomRightText;
    local showLeftText = ImpUI.db.profile.showLeftText;
    local showRightText = ImpUI.db.profile.showRightText;

    StyleButtons('ActionButton', showMainText);
    StyleButtons('MultiBarBottomLeftButton', showBottomLeftText);
    StyleButtons('MultiBarBottomRightButton', showBottomRightText);
    StyleButtons('MultiBarLeftButton', showLeftText);
    StyleButtons('MultiBarRightButton', showRightText);
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Bars:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Bars:OnEnable()
    self:RegisterEvent('PLAYER_ENTERING_WORLD', ApplyButtonStyles);

    if (Helpers.IsRetail()) then
        self:SecureHook(MainMenuBar, 'ChangeMenuBarSizeAndPosition', ApplyButtonStyles);
    end
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Bars:OnDisable()
end