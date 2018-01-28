--[[
    modules\bars\actionbars.lua
]]
local addonName, Loc = ...;

local ActionBars = CreateFrame('Frame', nil, UIParent);

-- Destroy the frames that we aren't using
Imp.DestroyFrame(ReputationWatchBar);
Imp.DestroyFrame(HonorWatchBar);
Imp.DestroyFrame(MainMenuBarMaxLevelBar);

-- We're not bothering with the reputation bar so disable the option completely in UI
ReputationDetailMainScreenCheckBox:Disable();
ReputationDetailMainScreenCheckBoxText:SetTextColor(.5,.5,.5);

-- Gut Blizzard Art Textures
MainMenuBarLeftEndCap:Hide();
MainMenuBarRightEndCap:Hide();

for i = 0, 3 do
   _G['MainMenuBarTexture' .. i]:Hide();
end

for i = 1, 19 do
	_G['MainMenuXPBarDiv' .. i]:Hide();
end
 
MainMenuXPBarTextureMid:Hide();
MainMenuXPBarTextureLeftCap:Hide();
MainMenuXPBarTextureRightCap:Hide();
MainMenuExpBar:SetFrameStrata('LOW');
ExhaustionTick:SetFrameStrata('MEDIUM');
MainMenuBarExpText:ClearAllPoints();
MainMenuBarExpText:SetPoint('CENTER',MainMenuExpBar,0,-1);
MainMenuBarOverlayFrame:SetFrameStrata('MEDIUM');
ArtifactWatchBar:SetFrameStrata('Medium');
ArtifactWatchBar.StatusBar.XPBarTexture0:SetTexture(nil);
ArtifactWatchBar.StatusBar.XPBarTexture1:SetTexture(nil);
ArtifactWatchBar.StatusBar.XPBarTexture2:SetTexture(nil);
ArtifactWatchBar.StatusBar.XPBarTexture3:SetTexture(nil);
ArtifactWatchBar.StatusBar.WatchBarTexture0:SetTexture(nil);
ArtifactWatchBar.StatusBar.WatchBarTexture1:SetTexture(nil);
ArtifactWatchBar.StatusBar.WatchBarTexture2:SetTexture(nil);
ArtifactWatchBar.StatusBar.WatchBarTexture3:SetTexture(nil);

--[[
    Hides or shows the Bag Bar

    @ return void
]]
local function ToggleBagBar()
    if(ActionBars.bagsVisible) then
        -- Hide them
        Imp.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, -1, -300, nil);
        ActionBars.bagsVisible = false;
    else
        --show them
        Imp.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, -100, 0, nil);
        ActionBars.bagsVisible = true;
    end
end
ActionBars.bagsVisible = false;

--[[
    Hides the Micro Menu by moving it off screen

    @ return void
]]
local function HideMicroMenu()
	Imp.ModifyFrame(CharacterMicroButton, 'BOTTOMLEFT', UIParent, 5000, 2, nil);
end

--[[
    Tweakes both the Experience Bar and Artifact Bar

    @ return void
]]
local function AdjustExperienceBars()
    MainMenuExpBar:SetSize(542,10);
	Imp.ModifyBasicFrame(MainMenuExpBar, 'BOTTOM', MainMenuBar, 19, -11, nil);
	ArtifactWatchBar:SetSize(542,10);
	ArtifactWatchBar.StatusBar:SetWidth(542);
	Imp.ModifyBasicFrame(ArtifactWatchBar, 'BOTTOM', MainMenuBar, 19, -11, nil);
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
    Repositions and scales essentially all of the action bars

    @ return void
]]
local function AdjustActionBars()
	if (InCombatLockdown() == false) then
		MainMenuBar:SetWidth(512);
		Imp.ModifyFrame(MainMenuBar, 'BOTTOM', nil, 0, 10, BarsDB.barsScale); -- Main Action Bar
		Imp.ModifyBasicFrame(MainMenuBarPageNumber, 'TOPRIGHT', ActionBarDownButton, 6, -1, nil);
        Imp.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, -1, -300, nil); -- Bag Bar
		--Imp.ModifyFrame(CharacterMicroButton, 'BOTTOMRIGHT', UIParent, 0, 5000, nil); -- Micro Menu

		Imp.ModifyFrame(MultiBarBottomLeft, 'TOP', MainMenuBar, 1, 36, nil);
		Imp.ModifyFrame(MultiBarBottomRight, 'TOP', MainMenuBar, 1, 78, nil);

		-- Adjust Stancebar and Pet Bar
		if(MultiBarBottomLeft:IsShown()) then
			Imp.ModifyFrame(StanceBarFrame, 'TOPLEFT', MainMenuBar, -4, 69, nil);	
			Imp.ModifyFrame(PetActionButton1, 'TOP', MainMenuBar, -107, 71, nil);
		end
		
		if(MultiBarBottomRight:IsShown()) then
			Imp.ModifyFrame(StanceBarFrame, 'TOPLEFT', MainMenuBar, -4, 111, nil);
			Imp.ModifyFrame(PetActionButton1, 'TOP', MainMenuBar, -107, 113, nil);
		end
		
		if(MultiBarBottomLeft:IsShown() ~= true and MultiBarBottomRight:IsShown() ~= true) then
			Imp.ModifyFrame(StanceBarFrame, 'TOPLEFT', MainMenuBar, 0, 30, nil);		
			Imp.ModifyFrame(PetActionButton1, 'TOP', MainMenuBar, -107, 30, nil);
		end

		MainMenuBarTexture2:SetTexture(nil);
        MainMenuBarTexture3:SetTexture(nil);
        _G['StanceBarLeft']:SetTexture(nil);
        _G['StanceBarMiddle']:SetTexture(nil);
        _G['StanceBarRight']:SetTexture(nil);
        _G['SlidingActionBarTexture'..0]:SetTexture(nil);
		_G['SlidingActionBarTexture'..1]:SetTexture(nil);
		
		-- Style the Action Buttons
		StyleButtons('ActionButton', BarsDB.showMainText);
		StyleButtons('MultiBarBottomLeftButton', BarsDB.showBottomLeftText);
		StyleButtons('MultiBarBottomRightButton', BarsDB.showBottomRightText);
		StyleButtons('MultiBarLeftButton', BarsDB.showLeftText);
		StyleButtons('MultiBarRightButton', BarsDB.showRightText);
		
		Imp.ModifyBasicFrame(MainMenuBarVehicleLeaveButton, 'LEFT', MainMenuBar, 0, 0, nil);
	end
end

--[[
    Whenever the experience bar updates just reset things basically. Bit forceful.

    @ return void
]]
local function MainMenuBar_UpdateExperienceBars_Hook()
    AdjustActionBars();
    AdjustExperienceBars();
end

--[[
    Handles the Out of Range action bar colouring

	@param Frame $self The Action Bar Button
	@param float $elapsed The amount of time passed since the last frame
    @ return void
]]
-- 
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

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if(event == 'PLAYER_ENTERING_WORLD' or event == 'PLAYER_TALENT_UPDATE' or event == 'ACTIVE_TALENT_GROUP_CHANGED') then
		AdjustActionBars();
		AdjustExperienceBars();
		HideMicroMenu();
	end
	
	if(event == 'UNIT_EXITED_VEHICLE') then
        if(... == 'player') then
            AdjustActionBars();
        end
    end

    if(event == 'PET_BATTLE_OPENING_START' or event == 'PET_BATTLE_OPENING_DONE') then
        Imp.ModifyFrame(CharacterMicroButton, 'TOPLEFT', MicroButtonFrame, -11, 28, nil);
	end
end

-- Register the Modules Events
ActionBars:SetScript('OnEvent', HandleEvents);
ActionBars:RegisterEvent('PLAYER_ENTERING_WORLD');
ActionBars:RegisterEvent('PLAYER_FLAGS_CHANGED');
ActionBars:RegisterEvent('PLAYER_TALENT_UPDATE');
ActionBars:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED');
ActionBars:RegisterEvent('UNIT_EXITED_VEHICLE');
ActionBars:RegisterEvent('PLAYER_LEVEL_UP');
ActionBars:RegisterEvent('ADDON_LOADED');
ActionBars:RegisterEvent('PET_BATTLE_OPENING_START');
ActionBars:RegisterEvent('PET_BATTLE_OPENING_DONE');

-- Blizzard Function Hooks
hooksecurefunc('MoveMicroButtons', HideMicroMenu);
hooksecurefunc('ActionButton_OnUpdate', ActionButton_OnUpdate_Hook);
hooksecurefunc('MultiActionBar_Update', AdjustActionBars);
hooksecurefunc('MainMenuBar_UpdateExperienceBars', MainMenuBar_UpdateExperienceBars_Hook);
hooksecurefunc('MainMenuBarVehicleLeaveButton_Update', AdjustActionBars);
