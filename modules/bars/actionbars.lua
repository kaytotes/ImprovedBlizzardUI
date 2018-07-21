--[[
    modules\bars\actionbars.lua
    Handles setting up the primary Bottom Left, Top Left, Top Right Bars
]]
local addonName, Loc = ...;

local ActionBars = CreateFrame('Frame', nil, UIParent);

--[[
    Hides or shows the Bag Bar

    @ return void
]]
function ToggleBagBar()
    if(ActionBars.bagsVisible) then
        -- Hide them
        Imp.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, -1, -300, nil);
        ActionBars.bagsVisible = false;
    else
        --show them
        Imp.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, 0, 0, nil);
        ActionBars.bagsVisible = true;
    end
end

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
		end
	end
end

--[[
    Does the initial hiding of the Bag Bar.

    @ return void
]]
local function HideBagBar()
    ActionBars.bagsVisible = true;
    ToggleBagBar();
end

--[[
    Based on config shows or hides the Action Bar Button text.

    @ return void
]]
local function ApplyButtonStyles()
    StyleButtons('ActionButton', BarsDB.showMainText);
    StyleButtons('MultiBarBottomLeftButton', BarsDB.showBottomLeftText);
    StyleButtons('MultiBarBottomRightButton', BarsDB.showBottomRightText);
    StyleButtons('MultiBarLeftButton', BarsDB.showLeftText);
    StyleButtons('MultiBarRightButton', BarsDB.showRightText);
end

--[[
    Handles the Out of Range action bar colouring

	@param Frame $self The Action Bar Button
	@param float $elapsed The amount of time passed since the last frame
    @ return void
]]
local function ActionButton_OnUpdate_Hook(self, elapsed)
    if(BarsDB.outOfRange) then
        if(self.rangeTimer == TOOLTIP_UPDATE_TIME) then
            if(IsActionInRange(self.action) == false) then
                self.icon:SetVertexColor(1, 0, 0);
            else
                local canUse, amountMana = IsUsableAction( self.action );
                if(canUse) then
                    self.icon:SetVertexColor( 1.0, 1.0, 1.0 );
    			elseif(amountMana) then
                    self.icon:SetVertexColor( 0.5, 0.5, 1.0 );
    			else
                    self.icon:SetVertexColor( 0.4, 0.4, 0.4 )
                end
            end
        end
    end
end
hooksecurefunc('ActionButton_OnUpdate', ActionButton_OnUpdate_Hook);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_ENTERING_WORLD') then
        local initialLogin, reloadingUI = ...;

        HideBagBar();
        ApplyButtonStyles();
    end
end

-- Register the Modules Events
ActionBars:SetScript('OnEvent', HandleEvents);
ActionBars:RegisterEvent('PLAYER_ENTERING_WORLD');

hooksecurefunc(MainMenuBar, "ChangeMenuBarSizeAndPosition", function (self, rightMultiBarShowing)
    HideBagBar();
    ApplyButtonStyles();
end);