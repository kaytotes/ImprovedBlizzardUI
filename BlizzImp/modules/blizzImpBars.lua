local impBars = CreateFrame( "Frame", "ImprovBars", UIParent );

-- Used for all action bars
local barScale = 1.1;

-- Vehicle Leave Button
local vehButtonX = 0;
local vehButtonY = 0;

-- Main Action Bar
local mainBarX = 256;
local mainBarY = 0;

-- Bottom Right Action Bar
local rightBarX = -254;
local rightBarY = 100;

-- Bottom Left Action Bar
local leftBarX = -254;
local leftBarY = 55;

-- Stance Bar
local stanceBarX = 0;
local stanceBarY = 120;
local stanceBarScale = 1;

-- Right Gryphon Art
local artPosX = 34;
local artPosY = 0;

-- Bags Bar
local bagsBarHiddenX = -1;
local bagsBarHiddenY = -300;


local petBar = CreateFrame("Frame", nil, PetActionBarFrame);
petBar:SetFrameStrata("BACKGROUND");
petBar:SetWidth(330);
petBar:SetHeight(33);

local function HideMicroMenu()
	-- Move Micro Menu
    CharacterMicroButton:SetMovable(true);
    CharacterMicroButton:ClearAllPoints();
    CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, 0, 5000);
    CharacterMicroButton:SetUserPlaced(true);
    CharacterMicroButton:SetMovable(false);
end

local function BuildPet()
	local offset = 0;

	if(ReputationWatchBar:IsShown() and MainMenuExpBar:IsShown())then
		offset = 0;
	else
		offset = 10;
	end

	if ( StanceBarFrame and GetNumShapeshiftForms() > 0 ) then
		PetActionButton1:ClearAllPoints()
		PetActionButton1:SetPoint("CENTER", -606, 28 + offset)
	else
		PetActionButton1:ClearAllPoints()
		PetActionButton1:SetPoint("CENTER", -140, 28 + offset)
	end
end

local function SetBars()

	MainMenuBarVehicleLeaveButton:SetMovable(true);
	MainMenuBarVehicleLeaveButton:ClearAllPoints();
	MainMenuBarVehicleLeaveButton:SetPoint("TOPLEFT", vehButtonX, vehButtonY);
	MainMenuBarVehicleLeaveButton:SetUserPlaced(true);
	MainMenuBarVehicleLeaveButton:SetMovable(false);

	-- Remove Art
	MainMenuBarTexture2:SetTexture(nil)
    MainMenuBarTexture3:SetTexture(nil)
    
    -- Move Main Bar
    MainMenuBar:SetMovable(true);
    MainMenuBar:ClearAllPoints();
    MainMenuBar:SetScale( barScale );
    MainMenuBar:SetPoint("BOTTOM", mainBarX, mainBarY);
    MainMenuBar:SetUserPlaced(true);
    MainMenuBar:SetMovable(false);
    
    -- Move End Cap
    MainMenuBarRightEndCap:SetPoint("CENTER", MainMenuBarArtFrame, artPosX, artPosY);
    if( bShowBarArt == false)then
    	MainMenuBarRightEndCap:SetTexture(nil);
		MainMenuBarLeftEndCap:SetTexture(nil);
    end

    -- Move Bottom Right Bar
    MultiBarBottomRight:SetMovable(true);
	MultiBarBottomRight:ClearAllPoints();
	MultiBarBottomRight:SetPoint("BOTTOM", rightBarX, rightBarY);
    MultiBarBottomRight:SetUserPlaced(true);
    MultiBarBottomRight:SetMovable(false);

    -- Move Bottom Left Bar
    MultiBarBottomLeft:SetMovable(true);
	MultiBarBottomLeft:ClearAllPoints();
	MultiBarBottomLeft:SetPoint("BOTTOM", leftBarX, leftBarY);
    MultiBarBottomLeft:SetUserPlaced(true);
    MultiBarBottomLeft:SetMovable(false);

    BuildPet();

	-- Remove Pet Bar Textures
	for i = 0, 1 do
    	local texture = _G["SlidingActionBarTexture"..i]
    	if texture then
        	texture:SetTexture(nil);
    	end
    end

  	-- Remove Stance Bar Art
    _G["StanceBarLeft"]:SetTexture(nil);
    _G["StanceBarMiddle"]:SetTexture(nil);
    _G["StanceBarRight"]:SetTexture(nil);

	-- Move Stance Bar
	StanceBarFrame:SetMovable(true);
	StanceBarFrame:ClearAllPoints();
	StanceBarFrame:SetScale( stanceBarScale );
	StanceBarFrame:SetPoint("TOPLEFT", stanceBarX, stanceBarY);
	StanceBarFrame:SetUserPlaced(true);
	StanceBarFrame:SetMovable( false );
    
    -- Adjust EXP Bar
    MainMenuExpBar:ClearAllPoints();
    MainMenuExpBar:SetWidth(512);
    MainMenuExpBar:SetPoint("TOP", -256, 0 );
	ExhaustionTick:Hide();
	ExhaustionLevelFillBar:SetVertexColor(0.0, 0.0, 0.0, 0.0);

	-- NOT the actual Rep Bar - Mouse Over Info "Frame"
	ReputationWatchStatusBar:SetWidth(512);
	ReputationWatchStatusBar:ClearAllPoints();
    ReputationWatchStatusBar:SetPoint("TOP", 0, 0 );

	for i = 1, 19 do -- Remove EXP Dividers
    	local texture = _G["MainMenuXPBarDiv"..i]
    	if texture then
        	texture:Hide()
    	end
	end

	-- Remove "collapsed" exp bar at max level
	for i = 0, 3 do
		local texture = _G["MainMenuMaxLevelBar"..i]
		if( texture ) then
			texture:Hide();
		end
	end

	-- Hide Bar Buttons
    MainMenuBarPageNumber:Hide();
    ActionBarDownButton:Hide();
    ActionBarUpButton:Hide();

    -- Move Bag Bar
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, bagsBarHiddenX, bagsBarHiddenY);
    
    HideMicroMenu();

    --Hide Exhaustion Tick
    ExhaustionTick:HookScript("OnShow", ExhaustionTick.Hide);
end

local function Bars_HandleEvents( self, event, ... )
	if( event == "PLAYER_ENTERING_WORLD" ) then
		if( InCombatLockdown() == false )then
			SetBars();
		end
	end

	if( event == "PLAYER_FLAGS_CHANGED" )then
		if( InCombatLockdown() == false )then
			HideMicroMenu();
		end
	end

	if( event == "UNIT_EXITED_VEHICLE" )then
		local unit = ...;
		if(unit == "player")then
			if( InCombatLockdown() == false )then
				HideMicroMenu();
				SetBars();
			end
		end
	end

	if( event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED")then
		if( InCombatLockdown() == false)then
			SetBars();
		end
	end
end

local function Bars_Init()
	impBars:SetScript( "OnEvent", Bars_HandleEvents );

	impBars:RegisterEvent( "PLAYER_LOGIN" );
	impBars:RegisterEvent( "PLAYER_ENTERING_WORLD" );
	impBars:RegisterEvent( "PLAYER_TARGET_CHANGED" );
	impBars:RegisterEvent( "UNIT_EXITED_VEHICLE" );
	impBars:RegisterEvent( "PLAYER_FLAGS_CHANGED" );
	impBars:RegisterEvent( "PLAYER_TALENT_UPDATE" );
	impBars:RegisterEvent( "ACTIVE_TALENT_GROUP_CHANGED" )
	if( InCombatLockdown() == false )then
		SetBars();
	end
end

-- Nigh identical replacement for ReputationWatchBar_Update
-- Orig Func exists in Blizz ReputationFrame.lua
local function RepWatchBar_Update( newLevel )
	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo();
	local visibilityChanged = nil;
	if ( not newLevel ) then
		newLevel = UnitLevel("player");
	end
	if ( name ) then
		local colorIndex = reaction;
		-- if it's a different faction, save possible friendship id
		if ( ReputationWatchBar.factionID ~= factionID ) then
			ReputationWatchBar.factionID = factionID;
			ReputationWatchBar.friendshipID = GetFriendshipReputation(factionID);
		end

		local isCappedFriendship;
		-- do something different for friendships
		if ( ReputationWatchBar.friendshipID ) then
			local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID);
			if ( nextFriendThreshold ) then
				min, max, value = friendThreshold, nextFriendThreshold, friendRep;
			else
				-- max rank, make it look like a full bar
				min, max, value = 0, 1, 1;
				isCappedFriendship = true;
			end
			colorIndex = 5;		-- always color friendships green
		end

		-- See if it was already shown or not
		if ( not ReputationWatchBar:IsShown() ) then
			visibilityChanged = 1;
		end
		
		-- Normalize values
		max = max - min;
		value = value - min;
		min = 0;
		ReputationWatchStatusBar:SetMinMaxValues(min, max);
		ReputationWatchStatusBar:SetValue(value);
		if ( isCappedFriendship ) then
			ReputationWatchStatusBarText:SetText(name);
		else
			ReputationWatchStatusBarText:SetText(name.." "..value.." / "..max);
		end
		local color = FACTION_BAR_COLORS[colorIndex];
		ReputationWatchStatusBar:SetStatusBarColor(color.r, color.g, color.b);
		ReputationWatchBar:Show();
		
		-- If the player is max level then replace the xp bar with the watched reputation, otherwise stack the reputation watch bar on top of the xp bar
		ReputationWatchStatusBar:SetFrameLevel(MainMenuBarArtFrame:GetFrameLevel()-1);
		if ( newLevel < MAX_PLAYER_LEVEL and not IsXPUserDisabled() ) then
			-- Reconfigure reputation bar
			ReputationWatchStatusBar:SetHeight(8);
			ReputationWatchBar:ClearAllPoints();
			ReputationWatchBar:SetPoint("TOP", -256, 0 ); --MODIFIED
			ReputationWatchStatusBarText:SetPoint("CENTER", ReputationWatchBarOverlayFrame, "CENTER", 0, 3);

			for i = 0, 3 do
				_G["ReputationWatchBarTexture"..i]:Hide();
				_G["ReputationXPBarTexture"..i]:Hide();
			end

			-- Show the XP bar
			MainMenuExpBar:Show();
			MainMenuExpBar.pauseUpdates = nil;
			-- Hide max level bar
			MainMenuBarMaxLevelBar:Hide();
		else
			-- Replace xp bar
			ReputationWatchStatusBar:SetHeight(13);
			ReputationWatchBar:ClearAllPoints();
			ReputationWatchBar:SetPoint("TOP", -256, 0 ); --MODIFIED
			ReputationWatchStatusBarText:SetPoint("CENTER", ReputationWatchBarOverlayFrame, "CENTER", 0, 1);
			
			for i = 0, 3 do
				_G["ReputationWatchBarTexture"..i]:Hide();
				_G["ReputationXPBarTexture"..i]:Hide();
			end

			ExhaustionTick:Hide();

			-- Hide the XP bar
			MainMenuExpBar:Hide();
			MainMenuExpBar.pauseUpdates = true;
			-- Hide max level bar
			MainMenuBarMaxLevelBar:Hide();
		end
		
	else
		if ( ReputationWatchBar:IsShown() ) then
			visibilityChanged = 1;
		end
		ReputationWatchBar:Hide();
		if ( newLevel < MAX_PLAYER_LEVEL and not IsXPUserDisabled() ) then
			MainMenuExpBar:Show();
			MainMenuExpBar.pauseUpdates = nil;
			MainMenuBarMaxLevelBar:Hide();
		else
			MainMenuExpBar:Hide();
			MainMenuExpBar.pauseUpdates = true;
			ExhaustionTick:Hide();
		end
	end
	
	-- update the xp bar
	TextStatusBar_UpdateTextString(MainMenuExpBar);
	ExpBar_Update();

	if( InCombatLockdown() == false )then
		SetBars();
	end
end

local function UpdateRange( self, elapsed )
	if ( ActionButton_IsFlashing(self) ) then
		local flashtime = self.flashtime;
		flashtime = flashtime - elapsed;
		
		if ( flashtime <= 0 ) then
			local overtime = -flashtime;
			if ( overtime >= ATTACK_BUTTON_FLASH_TIME ) then
				overtime = 0;
			end
			flashtime = ATTACK_BUTTON_FLASH_TIME - overtime;

			local flashTexture = self.Flash;
			if ( flashTexture:IsShown() ) then
				flashTexture:Hide();
			else
				flashTexture:Show();
			end
		end
		
		self.flashtime = flashtime;
	end

	local rangeTimer = self.rangeTimer
	local icon = self.icon;

	if( rangeTimer == TOOLTIP_UPDATE_TIME ) then
		local inRange = IsActionInRange( self.action );
		if( inRange == false ) then
			-- Red Out Button
			icon:SetVertexColor( 1, 0, 0 );
		else
			local canUse, amountMana = IsUsableAction( self.action );
			if( canUse ) then
				icon:SetVertexColor( 1.0, 1.0, 1.0 );
			elseif( amountMana ) then
				icon:SetVertexColor( 0.5, 0.5, 1.0 );
			else
				icon:SetVertexColor( 0.4, 0.4, 0.4 );
			end
		end
	end
end

local function MoveMicro(anchor, anchorTo, relAnchor, x, y, isStacked)
	HideMicroMenu();
	UpdateMicroButtons();
end

local function VehicleLeaveButton_Update()
	if ( CanExitVehicle() and ActionBarController_GetCurrentActionBarState() == LE_ACTIONBAR_STATE_MAIN ) then
		MainMenuBarVehicleLeaveButton:ClearAllPoints();
		MainMenuBarVehicleLeaveButton:SetPoint("CENTER", -600, 40)

		MainMenuBarVehicleLeaveButton:Show();
		if( InCombatLockdown() == false)then
			ShowPetActionBar(true);
		end
	else
		MainMenuBarVehicleLeaveButton:Hide();
		if( InCombatLockdown() == false)then
			ShowPetActionBar(true);
		end
	end
end

-- Fixes the Blizzard Bug related to World Map Breaking Cooldown Display
-- Force Cooldown Update
local function FixCooldowns()

	-- Action Bar 1
	for i = 1, 12 do
		local button = _G["ActionButton"..i];
		ActionButton_UpdateCooldown( button );
	end

	-- Action Bar 2
	for i = 1, 12 do
		local button = _G["MultiBarBottomLeftButton"..i];
		ActionButton_UpdateCooldown( button );
	end

	-- Action Bar 3
	for i = 1, 12 do
		local button = _G["MultiBarBottomRightButton"..i];
		ActionButton_UpdateCooldown( button );
	end

	-- Action Bar 4
	for i = 1, 12 do
		local button = _G["MultiBarLeftButton"..i];
		ActionButton_UpdateCooldown( button );
	end

	-- Action Bar 5
	for i = 1, 12 do
		local button = _G["MultiBarRightButton"..i];
		ActionButton_UpdateCooldown( button );
	end		
end

do
	hooksecurefunc(WorldMapFrame, "Hide", FixCooldowns);
	hooksecurefunc( "MainMenuBarVehicleLeaveButton_Update", VehicleLeaveButton_Update)
	hooksecurefunc( "MoveMicroButtons", MoveMicro );
	hooksecurefunc( "ActionButton_OnUpdate", UpdateRange );
	hooksecurefunc( "ReputationWatchBar_Update", RepWatchBar_Update );
end

-- Initalise
Bars_Init();