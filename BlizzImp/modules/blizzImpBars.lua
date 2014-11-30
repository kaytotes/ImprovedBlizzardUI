local impBars = CreateFrame( "Frame", "ImprovBars", UIParent );

local hideArt = false;

local function SetBars()

	-- Remove Art
	MainMenuBarTexture2:SetTexture(nil)
    MainMenuBarTexture3:SetTexture(nil)
    
    -- Move Main Bar
    MainMenuBar:ClearAllPoints();
    MainMenuBar:SetScale( 1.1 );
    MainMenuBar:SetPoint("BOTTOM", 256, 0)
    
    -- Move End Cap
    MainMenuBarRightEndCap:SetPoint("CENTER", MainMenuBarArtFrame, 35, 0)
    if( hideArt )then
    	MainMenuBarRightEndCap:SetTexture(nil);
		MainMenuBarLeftEndCap:SetTexture(nil);
    end

    -- Move Bottom Right Bar
    MultiBarBottomRight:ClearAllPoints();
    MultiBarBottomRight:SetPoint("BOTTOM", -254, 100);

    -- Move Pet Bar
    PetActionBarFrame:SetMovable(true);
    PetActionBarFrame:ClearAllPoints();
	PetActionBarFrame:SetPoint("BOTTOM", -222, 142);
	PetActionBarFrame:SetUserPlaced(true);
	PetActionBarFrame:SetMovable(false);

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
	StanceBarFrame:SetPoint("TOPLEFT", 0, 120);
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
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, -1, -300);
    
    -- Move Micro Menu
    CharacterMicroButton:SetMovable(true);
    CharacterMicroButton:ClearAllPoints();
    CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, 0, 5000);
    CharacterMicroButton:SetUserPlaced(true);
    CharacterMicroButton:SetMovable(false);
end

local function Bars_Init()
	impBars:SetScript( "OnEvent", Bars_HandleEvents );

	impBars:RegisterEvent( "PLAYER_LOGIN" );
	impBars:RegisterEvent( "PLAYER_ENTERING_WORLD" );
	impBars:RegisterEvent( "PLAYER_TARGET_CHANGED" );
	impBars:RegisterEvent( "UNIT_EXITED_VEHICLE" );
	impBars:RegisterEvent("PLAYER_FLAGS_CHANGED");

	SetBars();
end

local function Bars_HandleEvents( self, event, ... )
	--TESTING
	if( event == "PLAYER_ENTERING_WORLD" ) then
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
	
	if ( visibilityChanged ) then
		UIParent_ManageFramePositions();
		UpdateContainerFrameAnchors();
	end
end

local function UpdateRange( self, elapsed )
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

do
	hooksecurefunc( "ActionButton_OnUpdate", UpdateRange );
	hooksecurefunc( "ReputationWatchBar_Update", RepWatchBar_Update );
end

-- Initalise
Bars_Init();