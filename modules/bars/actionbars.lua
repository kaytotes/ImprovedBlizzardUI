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
    Handles most of the actual adjustment.

    @ return void
]]
local function AdjustActionBars(rightMultiBarShowing)
    if (InCombatLockdown() == false) then
        ActionBars.bagsVisible = true;
        ToggleBagBar();

        -- Basically force art to be the small type at all times
        _, width, height = GetAtlasInfo("hud-MainMenuBar-small");
		MainMenuBar:SetSize(width,height); 
		MainMenuBarArtFrame:SetSize(width,height); 
		MainMenuBarArtFrameBackground:SetSize(width, height); 
		MainMenuBarArtFrameBackground.BackgroundLarge:Hide();
		MainMenuBarArtFrameBackground.BackgroundSmall:Show(); 
		MainMenuBarArtFrame.PageNumber:ClearAllPoints();
        MainMenuBarArtFrame.PageNumber:SetPoint("RIGHT", MainMenuBarArtFrameBackground, "RIGHT", -6, -3);
        
        -- Move Right Bar and Make Horizontal
        if (rightMultiBarShowing) then
            Imp.ModifyFrame(MultiBarBottomRight, 'TOP', MainMenuBar, -142, 85, nil);
            Imp.ModifyFrame(MultiBarBottomRightButton7, 'RIGHT', MultiBarBottomRightButton6, 43, 0, nil);
        end
        
        -- Vehicle Leave Button (Flight Paths etc)
        Imp.ModifyBasicFrame(MainMenuBarVehicleLeaveButton, 'LEFT', MainMenuBar, -40, -10, nil);
        MainMenuBarVehicleLeaveButton:SetFrameStrata('HIGH');

        -- Adjust Stancebar and Pet Bar
        if(MultiBarBottomLeft:IsShown()) then
			Imp.ModifyFrame(StanceBarFrame, 'TOPLEFT', MainMenuBar, -4, 75, nil);	
            Imp.ModifyFrame(PetActionButton1, 'TOP', MainMenuBar, -124, 77, nil);
            
            if (StanceBarFrame:IsShown()) then
                Imp.ModifyFrame(PossessBarFrame, 'TOPLEFT', MainMenuBar, -4, 118, nil);	
            else
                Imp.ModifyFrame(PossessBarFrame, 'TOPLEFT', MainMenuBar, -4, 68, nil);	
            end
		end
		
		if(MultiBarBottomRight:IsShown()) then
			Imp.ModifyFrame(StanceBarFrame, 'TOPLEFT', MainMenuBar, -4, 118, nil);
            Imp.ModifyFrame(PetActionButton1, 'TOP', MainMenuBar, -124, 121, nil);

            if (StanceBarFrame:IsShown()) then
                Imp.ModifyFrame(PossessBarFrame, 'TOPLEFT', MainMenuBar, -4, 165, nil);	
            else
                Imp.ModifyFrame(PossessBarFrame, 'TOPLEFT', MainMenuBar, -4, 121, nil);	
            end
		end
		
		if(MultiBarBottomLeft:IsShown() ~= true and MultiBarBottomRight:IsShown() ~= true) then
			Imp.ModifyFrame(StanceBarFrame, 'TOPLEFT', MainMenuBar, 0, 31, nil);		
            Imp.ModifyFrame(PetActionButton1, 'TOP', MainMenuBar, -124, 34, nil);
            
            if (StanceBarFrame:IsShown()) then
                Imp.ModifyFrame(PossessBarFrame, 'TOPLEFT', MainMenuBar, 0, 85, nil);
            else
                Imp.ModifyFrame(PossessBarFrame, 'TOPLEFT', MainMenuBar, 0, 38, nil);
            end
        end

        -- Style the Action Buttons
		StyleButtons('ActionButton', BarsDB.showMainText);
		StyleButtons('MultiBarBottomLeftButton', BarsDB.showBottomLeftText);
		StyleButtons('MultiBarBottomRightButton', BarsDB.showBottomRightText);
		StyleButtons('MultiBarLeftButton', BarsDB.showLeftText);
        StyleButtons('MultiBarRightButton', BarsDB.showRightText);

        -- Hide Textures
        PossessBackground1:SetTexture(nil);
        PossessBackground2:SetTexture(nil);
        _G['StanceBarLeft']:SetTexture(nil);
        _G['StanceBarMiddle']:SetTexture(nil);
        _G['StanceBarRight']:SetTexture(nil);
        _G['SlidingActionBarTexture'..0]:SetTexture(nil);
		_G['SlidingActionBarTexture'..1]:SetTexture(nil);
        
        if ( StanceBarFrame ) then
			for i=1, NUM_STANCE_SLOTS do
				_G["StanceButton"..i]:GetNormalTexture():SetTexture(nil);
				_G["StanceButton"..i]:GetNormalTexture():SetTexture(nil);
			end
		end
	end
end

--[[
    When two status bars are shown (eg Rep + Exp) then hide the large texture and force the small

	@params StatusTrackingBarManager $self TThe status bar manager
    @params StatusBar $bar The actual bar itself
    @params float $width The width of the status bar.
    
    @ return void
]]
hooksecurefunc(StatusTrackingBarManager, "SetDoubleBarSize", function (self, bar, width)
    local textureHeight = self:GetInitialBarHeight(); 
	local statusBarHeight = textureHeight - 5; 
	
    self.SingleBarSmallUpper:SetSize(width, statusBarHeight); 
    self.SingleBarSmallUpper:SetPoint("CENTER", bar, 0, 4);
    self.SingleBarSmallUpper:Show(); 
    self.SingleBarLargeUpper:Hide();
    
    self.SingleBarSmall:SetSize(width, statusBarHeight); 
    self.SingleBarSmall:SetPoint("CENTER", bar, 0, -5);
    self.SingleBarSmall:Show(); 
    self.SingleBarLarge:Hide(); 

	bar.StatusBar:SetSize(width, statusBarHeight);  
	bar:SetSize(width, statusBarHeight);
end);

--[[
    When one status bars are shown (eg Rep + Exp) then hide the large texture and force the small

	@params StatusTrackingBarManager $self TThe status bar manager
    @params StatusBar $bar The actual bar itself
    @params float $width The width of the status bar.
    
    @ return void
]]
hooksecurefunc(StatusTrackingBarManager, "SetSingleBarSize", function (self, bar, width)
	local textureHeight = self:GetInitialBarHeight();

    self.SingleBarSmall:SetSize(width, textureHeight); 
    self.SingleBarSmall:SetPoint("CENTER", bar, 0, 4);
    self.SingleBarSmall:Show(); 
    self.SingleBarLarge:Hide(); 

	bar.StatusBar:SetSize(width, textureHeight);  
	bar:SetSize(width, textureHeight);
end);

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
    Detect if Bottom Right Bar is showing

	@params MainMenuBar $self The main menu bar itself
    @params bool $rightMultiBarShowing Is the Bottom Right bar showing?
    
    @ return void
]]
hooksecurefunc(MainMenuBar, "ChangeMenuBarSizeAndPosition", function (self, rightMultiBarShowing)
    AdjustActionBars(rightMultiBarShowing);
end);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if(event == 'PLAYER_ENTERING_WORLD' or event == 'PLAYER_LOGIN' or event == 'PLAYER_TALENT_UPDATE' or event == 'ACTIVE_TALENT_GROUP_CHANGED') then
        AdjustActionBars(MultiBarBottomRight:IsShown());
	end
end

-- Register the Modules Events
ActionBars:SetScript('OnEvent', HandleEvents);
ActionBars:RegisterEvent('PLAYER_LOGIN');
ActionBars:RegisterEvent('PLAYER_ENTERING_WORLD');
ActionBars:RegisterEvent('PLAYER_TALENT_UPDATE');
ActionBars:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED');