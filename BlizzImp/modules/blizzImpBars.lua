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
    PetActionBarFrame:ClearAllPoints();
	PetActionBarFrame:SetPoint("BOTTOM", -280, 142);
	PetActionBarFrame.ClearAllPoints = function () end
	PetActionBarFrame.SetPoint = function () end
	-- Remove Pet Bar Textures
	for i = 0, 1 do
    	local texture = _G["SlidingActionBarTexture"..i]
    	if texture then
        	texture:Hide()
        	texture.Show = function () end
    	end
    end

	-- Move Stance Bar
	StanceBarFrame:ClearAllPoints();
	StanceBarFrame:SetPoint("TOPLEFT", 0, 120);
	StanceBarFrame.ClearAllPoints = function () end
	StanceBarFrame.SetPoint = function () end
    -- Adjust EXP Bar
    MainMenuExpBar:ClearAllPoints();
    MainMenuExpBar:SetWidth(512);
    MainMenuExpBar:SetPoint("TOP", -256, 0 );
	ExhaustionTick:Hide();
	ExhaustionTick.Show = function () end
	ExhaustionLevelFillBar:SetVertexColor(0.0, 0.0, 0.0, 0.0);

	-- Adjust REP Bar
	ReputationWatchBar:SetWidth(512);
	ReputationWatchBar:ClearAllPoints();
	ReputationWatchBar:SetPoint("TOP", -256, 0 );
	ReputationWatchBar.ClearAllPoints = function () end
	ReputationWatchBar.SetPoint = function () end
	ReputationWatchStatusBar:SetWidth(512);
	ReputationWatchStatusBar:ClearAllPoints();
    ReputationWatchStatusBar:SetPoint("TOP", 0, 0 );
    ReputationWatchStatusBar.ClearAllPoints = function () end
	ReputationWatchStatusBar.SetPoint = function () end

	for i = 1, 19 do -- Remove EXP Dividers
    	local texture = _G["MainMenuXPBarDiv"..i]
    	if texture then
        	texture:Hide()
    	end
	end

	for i = 0, 3 do
		local texture = _G["ReputationXPBarTexture"..i]
		if( texture ) then
			texture:Hide()
			texture.Show = function () end
		end
	end

	for i = 0, 3 do
		local texture = _G["ReputationWatchBarTexture"..i]
		if( texture ) then
			texture:Hide()
			texture.Show = function () end
		end
	end

	for i = 0, 3 do
		local texture = _G["MainMenuMaxLevelBar"..i]
		if( texture ) then
			texture:Hide();
			texture.Show = function () end
		end
	end

    MainMenuBarPageNumber:Hide();
    ActionBarDownButton:Hide();
    ActionBarUpButton:Hide();
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, -1, -300);
    CharacterMicroButton:ClearAllPoints();
    CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, 0, 5000);
    CharacterMicroButton.ClearAllPoints = function () end;
    CharacterMicroButton.SetPoint = function () end;
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

	if( event == "UNIT_EXITED_VEHICLE" or event == "PLAYER_ENTERING_WORLD" ) then
		SetBars();
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
end

-- Initalise
Bars_Init();