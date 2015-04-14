local _, imp = ...;

local ADDON_VERSION = GetAddOnMetadata("BlizzImp", "Version");
local core = CreateFrame( "Frame", "ImprovCore", UIParent );

local damageFont = "Interface\\Addons\\BlizzImp\\media\\damage.ttf";
local fontArial = "Interface\\AddOns\\BlizzImp\\media\\impfont.ttf"
local menuFont = CreateFont("ImpMenuFont")
menuFont:SetFontObject(GameFontNormal);
menuFont:SetFont(fontArial, 12, nil );

local bagsHidden = true; -- Bags Toggle 
local PVEFrameOpen = false;

-- Buff Local Func
local locBuffPoint = BuffFrame.SetPoint;
local locBuffScale = BuffFrame.SetScale;
local buffPosX = -175;
local buffPosY = -11;
local buffScale = 1.4;

-- Consolidated Buffs
local locConBuffPoint = ConsolidatedBuffs.SetPoint;
local locConBuffScale = ConsolidatedBuffs.SetScale;

-- Stats Frame
local statsFont = "Fonts\\FRIZQT__.TTF";
local statsFrame = CreateFrame( "Frame", nil, UIParent );
statsFrame.latency = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal" );
local timeSinceLastUpdate = 0;
local updateDelay = 2;
local statsFrameX = -100;
local statsFrameY = -0;

-- Co-Ordinates 
local locationFrame = CreateFrame("Frame", nil, Minimap );
locationFrame.text = locationFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal" );
local locationDelay = 0.5;
local locationTimeElapsed = 0;
local locationFrameX = 3;
local locationFrameY = 0;

-- AFK Frame
local afkFrame = CreateFrame( "Frame", nil, WorldFrame );
afkFrame:SetAllPoints();
afkFrame:SetAlpha( 0 );
afkFrame.width, afkFrame.height = afkFrame:GetSize();

-- AFK Player Model
afkFrame.playerModel = CreateFrame( "PlayerModel", nil, afkFrame );
afkFrame.playerModel:SetSize( afkFrame.height * 0.8, afkFrame.height * 1.3 );
afkFrame.playerModel:SetPoint( "BOTTOMRIGHT", afkFrame.height * 0.1, -afkFrame.height * 0.4 );

-- AFK Pet Model
afkFrame.petModel = CreateFrame("PlayerModel", nil, afkFrame);
afkFrame.petModel:SetSize( afkFrame.height * 0.7, afkFrame.height );
afkFrame.petModel:SetPoint( "BOTTOMLEFT", afkFrame.height * 0.05, -afkFrame.height * 0.3 );
local afkFrameHidden = true;

-- AFK Frame Anims
local fadeInAnim = afkFrame:CreateAnimationGroup();
local fadeIn = fadeInAnim:CreateAnimation("Alpha");
fadeIn:SetDuration( 0.25 );
fadeIn:SetChange( 1 );
fadeIn:SetOrder( 1 );
fadeInAnim:SetScript("OnFinished", function() afkFrame:SetAlpha( 1 ) end );

local fadeOutAnim = afkFrame:CreateAnimationGroup();
local fadeOut = fadeOutAnim:CreateAnimation("Alpha");
fadeOut:SetDuration( 0.25 );
fadeOut:SetChange( -1 );
fadeOut:SetOrder( 1 );
fadeOutAnim:SetScript("OnFinished", function() afkFrame:SetAlpha( 0 ) end );

-- MicroMenu
local microMenu = CreateFrame("Frame", "RightClickMenu", UIParent, "UIDropDownMenuTemplate");

-- Dev Grid
local grid;

local function ShowBagBar()
	if( bagsHidden == true ) then
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, - 100, 0 );
		bagsHidden = false;
	else
		MainMenuBarBackpackButton:SetPoint( "BOTTOMRIGHT", UIParent, -1, -300 )
		bagsHidden = true;
	end
end

local microMenuList = {
	{text = "|cffFFFFFF"..imp["Character"], func = function() ToggleCharacter( "PaperDollFrame" ) end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle' },
	{text = "|cffFFFFFF"..imp["Spellbook"], func = function() ToggleFrame(SpellBookFrame) end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Class' },
	{text = "|cffFFFFFF"..imp["Talents"], func = function() ToggleTalentFrame() end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Profession' },
	{text = "|cffFFFFFF"..imp["Achievements"], func = function() ToggleAchievementFrame() end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\MINIMAP\\Minimap_shield_elite', },
	{text = "|cffFFFFFF"..imp["Quest Log"], func = function() ToggleFrame( WorldMapFrame )end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\GossipFrame\\ActiveQuestIcon' },
	{text = "|cffFFFFFF"..imp["Guild"], func = function() ToggleGuildFrame( 1 ) end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\GossipFrame\\TabardGossipIcon' },
	{text = "|cffFFFFFF"..imp["Group Finder"], func = function() PVEFrame_ToggleFrame() end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\LFGFRAME\\BattlenetWorking0' },
	{text = "|cffFFFFFF"..imp["Collections"], func = function() ToggleCollectionsJournal() end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster' },
	{text = "|cffFFFFFF"..imp["Dungeon Journal"], func = function() ToggleEncounterJournal() end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' },
	{text = "|cffFFFFFF"..imp["Swap Bags"], func = function() ShowBagBar() end, notCheckable = true, fontObject = menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Banker' },
	{text = "|cff00FFFF"..imp["BlizzImp Options"], func = function() InterfaceOptionsFrame_OpenToCategory("Improved Blizzard UI") end, notCheckable = true, fontObject = menuFont },
	{text = "|cffFFFF00"..imp["Log Out"], func = function() Logout() end, notCheckable = true, fontObject = menuFont },
	{text = "|cffFE2E2E"..imp["Force Exit"], func = function() ForceQuit() end, notCheckable = true, fontObject = menuFont },
}

function IsPVPOpen()
	if( PVEFrame and PVEFrame:IsShown() )then
		print("PVEFrame open");
		print(GroupFinderFrame_GetSelection(PVEFrame));
	end
end

-- Rotates the Camera around the Player when AFK
local function AFKSpin(spin)
	if( InCombatLockdown() == false ) then
		if( spin == true) then
			-- Refresh Anims / Model
			afkFrame.playerModel:SetUnit( "player"  );
			afkFrame.playerModel:SetAnimation( 0 );
			afkFrame.playerModel:SetRotation( math.rad( -15 ) );
			afkFrame.playerModel:SetCamDistanceScale( 1.2 );

			afkFrame.petModel:SetUnit( "pet" );
			afkFrame.petModel:SetAnimation( 0 );
			afkFrame.petModel:SetRotation( math.rad( 45 ) );
			afkFrame.petModel:SetCamDistanceScale( 1.7 );

			-- Hide PVE Frame If Shown
			if( PVEFrame and PVEFrame:IsShown() )then
				PVEFrameOpen = true;
				PVEFrame_ToggleFrame();
			else
				PVEFrameOpen = false;
			end

			-- Hide UI / Move Camera
			UIParent:Hide();
			fadeInAnim:Play();
			afkFrameHidden = false;
			MoveViewRightStart( 0.15 );
		else
			-- Show UI / Stop Camera Spin
			if( afkFrameHidden == false )then
				UIParent:Show();
				fadeOutAnim:Play();
				MoveViewRightStop();

				-- Was PVEFrame Open? If so reopen it
				if( PVEFrameOpen == true )then
					PVEFrame_ToggleFrame();
				end

				afkFrameHidden = true;
			end
		end
	end
end

-- Updates Player Co-ordinates
local function UpdateLocation()
	if( bShowCoords == true )then
		if( Minimap:IsVisible() )then
			local playerX, playerY = GetPlayerMapPosition("player");
			if( playerX ~= 0 and playerY ~= 0 )then
				locationFrame.text:SetFormattedText( "(%d:%d)", playerX * 100, playerY * 100 );
			end
		end
	end
end

function LocationFrame_Delay(self, elapsed)
	locationTimeElapsed = locationTimeElapsed + elapsed;
	if( locationTimeElapsed >= locationDelay )then
		UpdateLocation();
		locationTimeElapsed = 0;
	end
end

-- Updates Network Statistics. Throttled based on updateDelay.
local function UpdateStats(self, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed;
	if( timeSinceLastUpdate >= updateDelay )then
		local _, _, latencyHome, latencyWorld = GetNetStats();
		local homeString, worldString;

		-- Colour Latency Strings
		if( latencyHome <= 75 )then
			homeString = format("|cff00CC00%s|r", latencyHome );
		elseif( latencyHome > 75 and latencyHome <= 250 )then
			homeString = format("|cffFFFF00%s|r", latencyHome );
		elseif( latencyHome > 250 )then
			homeString = format("|cffFF0000%s|r", latencyHome );
		end

		if( latencyWorld <= 75 )then
			worldString = format("|cff00CC00%s|r", latencyWorld );
		elseif( latencyWorld > 75 and latencyWorld <= 250 )then
			worldString = format("|cffFFFF00%s|r", latencyWorld );
		elseif( latencyWorld > 250 )then
			worldString = format("|cffFF0000%s|r", latencyWorld );
		end

		local frameRate = floor(GetFramerate());
		--print(frameRate)
		statsFrame.latency:SetText(" ");
		if( bShowStats == true )then
			statsFrame.latency:SetText(homeString.. " / " ..worldString.. " ms - " ..frameRate.. " fps");
		end
		timeSinceLastUpdate = 0;
	end
end

-- Stats Frame Init
local function StatsInit()
	statsFrame:SetFrameStrata("BACKGROUND");
	statsFrame:SetWidth(32);
	statsFrame:SetHeight(32);
	statsFrame:SetPoint("TOPRIGHT", statsFrameX, statsFrameY);

	-- Latency
	statsFrame.latency:SetPoint("CENTER", 0, 0 );
	statsFrame.latency:SetFont( statsFont, 16, "OUTLINE" );
	--statsFrame.latency:SetText("0/0 ms"); -- debug

	statsFrame:SetScript("OnUpdate", UpdateStats);
end

-- Hide Leave Queue button for PvP
local function HideLeaveButton()
	PVPReadyDialog.enterButton:ClearAllPoints();
	PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25);
	PVPReadyDialog.label:SetPoint("TOP", 0, -22);
	PVPReadyDialog.leaveButton:Hide();
	PVPReadyDialog.leaveButton:HookScript("OnShow", PVPReadyDialog.leaveButton.Hide);
end

local function ModifyBuffs()
	BuffFrame:ClearAllPoints();
	locBuffPoint(BuffFrame, "TOPRIGHT", buffPosX, buffPosY );
	locBuffScale(BuffFrame, buffScale );

	ConsolidatedBuffs:ClearAllPoints();
	locConBuffPoint( ConsolidatedBuffs, "TOPRIGHT", buffPosX, buffPosY );
	locConBuffScale( ConsolidatedBuffs, buffScale);
end

-- Tweak Minimap and World Map
local function ModifyMinimap()
	-- Hide Buttons
	MinimapZoomIn:Hide();
	MinimapZoomOut:Hide();

	MinimapCluster:ClearAllPoints();
	MinimapCluster:SetScale(1.15);
	MinimapCluster:SetPoint("TOPRIGHT", -15, -25)

	-- Allow and Handle Scrollwheel Zoom
	Minimap:EnableMouseWheel( true );
	Minimap:SetScript("OnMouseWheel", function( self, delta )
	        if ( delta > 0 ) then
	            Minimap_ZoomIn();
	        else
	            Minimap_ZoomOut();
	        end
	end)

	-- Move Tracker Button
	MiniMapTracking:ClearAllPoints();
	MiniMapTracking:SetPoint("TOPRIGHT", 12, -70);

	Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
		EasyMenu(microMenuList, microMenu, "cursor", 0, 0, "MENU", 3);
	else
		Minimap_OnClick(self)
	end
	end)

	--Create Location Coords
	locationFrame:SetFrameStrata("LOW");
	locationFrame:SetWidth(32);
	locationFrame:SetHeight(32);
	locationFrame:SetPoint("BOTTOM", locationFrameX, locationFrameY);
	locationFrame.text:SetPoint("CENTER", 0, 0 );
	locationFrame.text:SetFont( statsFont, 14, "OUTLINE" );
end

local function Core_HandleEvents( self, event, unit )

	if( event == "ADDON_LOADED" ) then
		DAMAGE_TEXT_FONT = damageFont; -- Run with each addon load to stop it being replaced
	end

	if( event == "PLAYER_ENTERING_WORLD" ) then
		-- Set Max Zoom Out
		SetCVar( "CameraDistanceMaxFactor", 9 );

		if( InCombatLockdown() == false ) then
			HideLeaveButton();
			ModifyMinimap();
			ModifyBuffs();
		end
		StatsInit();
	end

	-- Auto Repair
	if( event == "MERCHANT_SHOW" and CanMerchantRepair() == true and bAutoRepair == true) then
		local repCost, bRepair = GetRepairAllCost();
		
		if( bGuildRepair == true )then
			if(CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repCost and GetGuildBankMoney() >= repCost) then
				if( repCost > 0 )then
					RepairAllItems( true );
					print("|cffffff00"..imp["Items Repaired from Guild Bank"]..": " ..GetCoinTextureString( repCost ));
				end
			else
				print("|cffffff00"..imp["Can not Repair from Guild Bank"]);
				if( repCost <= GetMoney() and repCost > 0 )then
					RepairAllItems( false );
					print("|cffffff00"..imp["Items Repaired from Own Money"]..": " ..GetCoinTextureString( repCost ));
				end
			end
		else
			if( repCost <= GetMoney() and repCost > 0 )then
				RepairAllItems( false );
				print("|cffffff00"..imp["Items Repaired from Own Money"]..": " ..GetCoinTextureString( repCost ));
			end
		end
	end

	-- Sell Grey Items
	if( event == "MERCHANT_SHOW" and bAutoSell == true) then
		local moneyEarned = 0;
		for bags = 0, 4 do
			for bagSlot = 1, GetContainerNumSlots( bags ) do
				local itemLink = GetContainerItemLink( bags, bagSlot );
				if( itemLink ) then
					local _,_,iQuality,_,_,_,_,_,_,_,iPrice = GetItemInfo( itemLink );
					local _, iCount = GetContainerItemInfo( bags, bagSlot );
					if( iQuality == 0 and iPrice ~= 0 ) then
						moneyEarned = moneyEarned + ( iPrice * iCount );
						UseContainerItem( bags, bagSlot );
					end
				end
			end
		end

		if( moneyEarned ~= 0 ) then
			print("|cffffff00"..imp["Sold Trash Items"]..": " .. GetCoinTextureString( moneyEarned ) );
		end
	end	

	-- AFK Camera Spin
	if( event == "PLAYER_FLAGS_CHANGED") then
		-- Check for AFK and Toggle Camera Spin
		if( unit == "player" and bAFKMode == true) then
			if( UnitIsAFK(unit) and not UnitIsDead(unit)) then
				AFKSpin( true );
			else
				AFKSpin( false );
			end
		end
	elseif( event == "PLAYER_LEAVING_WORLD") then
		AFKSpin( false );
	elseif( event == "PLAYER_DEAD") then
		if( UnitIsAFK("player")) then
			AFKSpin( false );
		end
	end

	if( event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" )then
		UpdateLocation();
	end

end

local function DrawDevGrid()
	-- Grid Already Drawn?
	if( grid ) then
		grid:Hide();
		grid = nil; -- Kill Grid
	else
		grid = CreateFrame( 'Frame', nil, UIParent );
		grid:SetAllPoints( UIParent );

		local cellSizeX = 32;
		local cellSizeY = 18;

		local screenWidth = GetScreenWidth() / cellSizeX;
		local screenHeight = GetScreenHeight() / cellSizeY;

		for columns = 0, cellSizeX do
			local line = grid:CreateTexture(nil, 'BACKGROUND');
			if( columns == cellSizeX / 2 ) then -- Half Way Line
				line:SetTexture(1, 0, 0, 0.5 );
			else
				line:SetTexture(0, 0, 0, 0.5 );
			end
			line:SetPoint('TOPLEFT', grid, 'TOPLEFT', columns * screenWidth - 1, 0);
			line:SetPoint('BOTTOMRIGHT', grid, 'BOTTOMLEFT', columns * screenWidth + 1, 0);
		end
		for rows = 0, cellSizeY do
			local line = grid:CreateTexture(nil, 'BACKGROUND');
			if( rows == cellSizeY / 2 ) then -- Half Way Line
				line:SetTexture(1, 0, 0, 0.5 );
			else
				line:SetTexture(0, 0, 0, 0.5 );
			end
			line:SetPoint('TOPLEFT', grid, 'TOPLEFT', 0, -rows * screenHeight + 1);
			line:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -rows * screenHeight - 1)
		end
	end
end

-- Slash Commands
function HandleSlashCommands( command )
	if( string.lower( command ) == "devgrid" ) then
		DrawDevGrid();
	end
end

local function Core_Init()
	core:SetScript( "OnEvent", Core_HandleEvents );

	core:RegisterEvent("ADDON_LOADED");
	core:RegisterEvent("PLAYER_ENTERING_WORLD");
	core:RegisterEvent("PLAYER_FLAGS_CHANGED");
	core:RegisterEvent("MERCHANT_SHOW");
	core:RegisterEvent("ZONE_CHANGED");
	core:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	core:RegisterEvent("ZONE_CHANGED_INDOORS");

	locationFrame:SetScript("OnUpdate", LocationFrame_Delay);

	SLASH_IMP1 = "/imp";
	SlashCmdList["IMP"] = HandleSlashCommands;

	print("|cffffff00Improved Blizzard Initialised - v" .. ADDON_VERSION);
end

-- Fixes taint from ToggleTalentFrame();
do
    local function hook()
        PlayerTalentFrame_Toggle = function() 
            if ( not PlayerTalentFrame:IsShown() ) then 
                ShowUIPanel(PlayerTalentFrame); 
                TalentMicroButtonAlert:Hide(); 
            else 
                PlayerTalentFrame_Close(); 
            end 
        end

        for i=1, 10 do
            local tab = _G["PlayerTalentFrameTab"..i];
            if not tab then break end
            tab:SetScript("PreClick", function()
                --print("PreClicked")
                for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
                    local frame = _G["StaticPopup"..index];
                    if(not issecurevariable(frame, "which")) then
                        local info = StaticPopupDialogs[frame.which];
                        if frame:IsShown() and info and not issecurevariable(info, "OnCancel") then
                            info.OnCancel()
                        end
                        frame:Hide()
                        frame.which = nil
                    end
                end
            end)
        end
    end

    if(IsAddOnLoaded("Blizzard_TalentUI")) then
        hook()
    else
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, addon)
            if(addon=="Blizzard_TalentUI")then
                self:UnregisterEvent("ADDON_LOADED")
                hook()
            end             
        end)
    end
end

do
	-- Secure Hooks for Buffs
	hooksecurefunc( BuffFrame, "SetPoint", function(frame)
		frame:ClearAllPoints();
		locBuffPoint(BuffFrame, "TOPRIGHT", buffPosX, buffPosY);
	end)
	hooksecurefunc( BuffFrame, "SetScale", function(frame)
		locBuffScale( buffScale );
	end)
	-- Consolidated Buffs
	hooksecurefunc( ConsolidatedBuffs, "SetPoint", function(frame)
		frame:ClearAllPoints();
		locConBuffPoint( ConsolidatedBuffs, "TOPRIGHT", buffPosX, buffPosY );
	end)
	hooksecurefunc( ConsolidatedBuffs, "SetScale", function(frame)
		locConBuffScale( buffScale );
	end)
end

-- CREDIT - !BlizzBugsSuck
-- Fix InterfaceOptionsFrame_OpenToCategory not actually opening the category (and not even scrolling to it)
-- Confirmed still broken in 6.0.3.19243
do
	local function get_panel_name(panel)
		local tp = type(panel)
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		if tp == "string" then
			for i = 1, #cat do
				local p = cat[i]
				if p.name == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel
					end
				end
			end
		elseif tp == "table" then
			for i = 1, #cat do
				local p = cat[i]
				if p == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel.name
					end
				end
			end
		end
	end

	local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
		if doNotRun or InCombatLockdown() then return end
		local panelName = get_panel_name(panel)
		if not panelName then return end -- if its not part of our list return early
		local noncollapsedHeaders = {}
		local shownpanels = 0
		local mypanel
		local t = {}
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, #cat do
			local panel = cat[i]
			if not panel.parent or noncollapsedHeaders[panel.parent] then
				if panel.name == panelName then
					panel.collapsed = true
					t.element = panel
					InterfaceOptionsListButton_ToggleSubCategories(t)
					noncollapsedHeaders[panel.name] = true
					mypanel = shownpanels + 1
				end
				if not panel.collapsed then
					noncollapsedHeaders[panel.name] = true
				end
				shownpanels = shownpanels + 1
			end
		end
		local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
		if shownpanels > 15 and Smin < Smax then
			local val = (Smax/(shownpanels-15))*(mypanel-2)
			InterfaceOptionsFrameAddOnsListScrollBar:SetValue(val)
		end
		doNotRun = true
		InterfaceOptionsFrame_OpenToCategory(panel)
		doNotRun = false
	end

	hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
end

Core_Init();