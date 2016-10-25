--[[
    ImpBlizzardUI/core.lua
    Handles the misc functions of the addon that don't quite fit into any other category.
    Current Features: Development DevGrid Overlay, Auto Sell, Auto Repair, AFK Camera, Performance Statistics, Player Co-Ordinates, Minimap Tweaks
]]

local _, ImpBlizz = ...;

local Core = CreateFrame("Frame", "ImpCore", UIParent); -- Create the Core frame, doesn't ever get drawn just logic

-- Get Font references
local DamageFont = "Interface\\Addons\\ImpBlizzardUI\\media\\damage.ttf";
local MenuFont = "Interface\\Addons\\ImpBlizzardUI\\media\\impfont.ttf";
local CoreFont = "Interface\\Addons\\ImpBlizzardUI\\media\\impfont.ttf";

-- Development Grid
local DevGrid;

-- AFK Camera
local AFKCamera;

-- Co-ordinates Frame
local CoordsFrame;

-- Performance Counter
local PerformanceFrame;

-- Ticks every 0.5 seconds, purely to update the Co-ordinates display.
local function CoordsFrame_Tick(self, elapsed)
	CoordsFrame.elapsed = CoordsFrame.elapsed + elapsed; -- Increment the tick timer
	if(CoordsFrame.elapsed >= CoordsFrame.delay) then -- Matched tick delay?
		if(Conf_ShowCoords) then -- Update the Co-ords frame
			-- 7.1 Restricted this so it only works in the outside world. Lame.
			local inInstance, _ = IsInInstance();
			if(inInstance ~= true) then
				if(Minimap:IsVisible()) then
					local x, y = GetPlayerMapPosition("player");
					if(x ~= 0 and y ~= 0) then
						CoordsFrame.text:SetFormattedText("(%d:%d)", x * 100, y * 100);
					end
				end
			end
		end
		CoordsFrame.elapsed = 0; -- Reset the timer
	end
end

-- Tweaks the standard Blizzard minimap, hiding a few buttons and enabling Mouse Scroll.
-- Also Initialises the Co-Ords text
local function ModifyMinimap()
	-- Hide Minimap Zoom Buttons
	MinimapZoomIn:Hide();
	MinimapZoomOut:Hide();

	-- Move and Scale the entire Minimap frame
	MinimapCluster:ClearAllPoints();
	MinimapCluster:SetScale(1.15);
	MinimapCluster:SetPoint("TOPRIGHT", -15, -25);

	-- All and handle Mouse Scroll for minimap zooming
	Minimap:EnableMouseWheel(true);
	Minimap:SetScript("OnMouseWheel", function(self, delta)
		if(delta > 0) then
			Minimap_ZoomIn();
		else
			Minimap_ZoomOut();
		end
	end);
end

local function CreateCoords()
	-- Create the Co-Ordinates Frame
	CoordsFrame = CreateFrame("Frame", nil, Minimap);
	CoordsFrame.text = CoordsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	CoordsFrame.delay = 0.5;
	CoordsFrame.elapsed = 0;

	-- Set the position and scale etc
	CoordsFrame:SetFrameStrata("LOW");
	CoordsFrame:SetWidth(32);
	CoordsFrame:SetHeight(32);
	CoordsFrame:SetPoint("BOTTOM", 3, 0);
	CoordsFrame.text:SetPoint("CENTER", 0, 0);
	CoordsFrame.text:SetFont(CoreFont, 14, "OUTLINE");
	CoordsFrame:SetScript("OnUpdate", CoordsFrame_Tick); -- Begin the Core_Tick
end

-- Actually does the AFK Camera actions, begins spin, hides windows etc
local function AFKCamera_Spin(spin)
	if(InCombatLockdown() == false) then
		if(spin) then
			-- Refresh and Set the Player Model anims
			AFKCamera.playerModel:SetUnit("player");
			AFKCamera.playerModel:SetAnimation(0);
			AFKCamera.playerModel:SetRotation(math.rad(-15));
			AFKCamera.playerModel:SetCamDistanceScale(1.2);

			-- Refresh and Set the Pet Model anims
			AFKCamera.petModel:SetUnit("pet");
			AFKCamera.petModel:SetAnimation(0);
			AFKCamera.petModel:SetRotation(math.rad(45));
			AFKCamera.petModel:SetCamDistanceScale(1.7);

			-- Hide the PVE Frame if it is shown
			if(PVEFrame and PVEFrame:IsShown()) then
				AFKCamera.PvEIsOpen = true; -- Store that it was open so that we can automatically reopen it after
				PVEFrame_ToggleFrame();
			else
				AFKCamera.PvEIsOpen = false;
			end

			-- Hide the UI and begin the camera spinning
			UIParent:Hide();
			AFKCamera.fadeInAnim:Play();
			AFKCamera.hidden = false;
			MoveViewRightStart(0.15);
		else
			if(AFKCamera.hidden == false) then
				MoveViewRightStop();
				UIParent:Show();
				AFKCamera.fadeOutAnim:Play();

				-- Reopen PVE Frame if it was open
				if(AFKCamera.PvEIsOpen) then
					PVEFrame_ToggleFrame();
				end

				AFKCamera.hidden = true;
			end
		end
	end
end

-- Initialises the AFK Camera module
local function AFKCamera_Init()
	AFKCamera = CreateFrame("Frame", nil, WorldFrame);
	AFKCamera:SetAllPoints();
	AFKCamera:SetAlpha(0);
	AFKCamera.width, AFKCamera.height = AFKCamera:GetSize();

	-- Set Up the Player Model
	AFKCamera.playerModel = CreateFrame("PlayerModel", nil, AFKCamera);
	AFKCamera.playerModel:SetSize(AFKCamera.height * 0.8, AFKCamera.height * 1.3);
	AFKCamera.playerModel:SetPoint("BOTTOMRIGHT", AFKCamera.height * 0.1, -AFKCamera.height * 0.4);

	-- Pet model for Hunters, Warlocks etc
	AFKCamera.petModel = CreateFrame("playerModel", nil, AFKCamera);
	AFKCamera.petModel:SetSize(AFKCamera.height * 0.7, AFKCamera.height);
	AFKCamera.petModel:SetPoint("BOTTOMLEFT", AFKCamera.height * 0.05, -AFKCamera.height * 0.3);

	AFKCamera.hidden = true;

	-- Initialise the fadein / out anims
	AFKCamera.fadeInAnim = AFKCamera:CreateAnimationGroup();
	AFKCamera.fadeIn = AFKCamera.fadeInAnim:CreateAnimation("Alpha");
	AFKCamera.fadeIn:SetDuration(0.5);
	AFKCamera.fadeIn:SetFromAlpha(0);
	AFKCamera.fadeIn:SetToAlpha(1);
	AFKCamera.fadeIn:SetOrder(1);
	AFKCamera.fadeInAnim:SetScript("OnFinished", function() AFKCamera:SetAlpha(1) end );

	AFKCamera.fadeOutAnim = AFKCamera:CreateAnimationGroup();
	AFKCamera.fadeOut = AFKCamera.fadeOutAnim:CreateAnimation("Alpha");
	AFKCamera.fadeOut:SetDuration(0.5);
	AFKCamera.fadeOut:SetFromAlpha(1);
	AFKCamera.fadeOut:SetToAlpha(0);
	AFKCamera.fadeOut:SetOrder(1);
	AFKCamera.fadeOutAnim:SetScript("OnFinished", function() AFKCamera:SetAlpha(0) end );
end


-- Ticks every 2 seconds, updates the performance counter
local function PerformanceFrame_Tick(self, elapsed)
	PerformanceFrame.elapsed = PerformanceFrame.elapsed + elapsed; -- Increment Timer
	if(PerformanceFrame.elapsed >= PerformanceFrame.delay) then
		local _, _, latencyHome, latencyWorld = GetNetStats(); -- Get current Latency

		-- Colour Latency Strings
		if( latencyHome <= 75 )then
			latencyHome = format("|cff00CC00%s|r", latencyHome );
		elseif( latencyHome > 75 and latencyHome <= 250 )then
			latencyHome = format("|cffFFFF00%s|r", latencyHome );
		elseif( latencyHome > 250 )then
			latencyHome = format("|cffFF0000%s|r", latencyHome );
		end

		if( latencyWorld <= 75 )then
			latencyWorld = format("|cff00CC00%s|r", latencyWorld );
		elseif( latencyWorld > 75 and latencyWorld <= 250 )then
			latencyWorld = format("|cffFFFF00%s|r", latencyWorld );
		elseif( latencyWorld > 250 )then
			latencyWorld = format("|cffFF0000%s|r", latencyWorld );
		end

		local frameRate = floor(GetFramerate()); -- Get the current frame rate

		-- Colour Frame Rate
		if(frameRate >= 60) then
			frameRate = format("|cff00CC00%s|r", frameRate );
		elseif(frameRate >= 20 and frameRate <= 59) then
			frameRate = format("|cffFFFF00%s|r", frameRate );
		elseif(frameRate < 20) then
			frameRate = format("|cffFF0000%s|r", frameRate );
		end

		-- Write Text
		PerformanceFrame.text:SetText(" ");
		if(Conf_ShowStats) then
			PerformanceFrame.text:SetText(latencyHome.." / "..latencyWorld.." ms - "..frameRate.." fps");
		end
		PerformanceFrame.elapsed = 0;
	end
end

-- Initialises the Performance Counter
local function PerformanceFrame_Init()

	-- Create and Position the Performance Counter
	PerformanceFrame = CreateFrame("Frame", nil, UIParent);
	PerformanceFrame.text = PerformanceFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	PerformanceFrame.elapsed = 0;
	PerformanceFrame.delay = 2;
	PerformanceFrame:SetFrameStrata("BACKGROUND");
	PerformanceFrame:SetWidth(32);
	PerformanceFrame:SetHeight(32);
	PerformanceFrame:SetPoint("TOPRIGHT", -100, -0);

	-- Text positioning
	PerformanceFrame.text:SetPoint("CENTER", 0, 0);
	PerformanceFrame.text:SetFont(CoreFont, 16, "THINOUTLINE");

	PerformanceFrame:SetScript("OnUpdate", PerformanceFrame_Tick);
end

-- Just draws an overlay DevGrid to aid in placing stuff
local function DrawDevGrid()
	-- DevGrid Already Drawn?
	if( DevGrid ) then
		DevGrid:Hide();
		DevGrid = nil; -- Kill DevGrid
	else
		DevGrid = CreateFrame( 'Frame', nil, UIParent );
		DevGrid:SetAllPoints( UIParent );

		local cellSizeX = 32;
		local cellSizeY = 18;

		local screenWidth = GetScreenWidth() / cellSizeX;
		local screenHeight = GetScreenHeight() / cellSizeY;

		for columns = 0, cellSizeX do
			local line = DevGrid:CreateTexture(nil, 'BACKGROUND');
			if( columns == cellSizeX / 2 ) then -- Half Way Line
				line:SetColorTexture(1, 0, 0, 0.5 );
			else
				line:SetColorTexture(0, 0, 0, 0.5 );
			end
			line:SetPoint('TOPLEFT', DevGrid, 'TOPLEFT', columns * screenWidth - 1, 0);
			line:SetPoint('BOTTOMRIGHT', DevGrid, 'BOTTOMLEFT', columns * screenWidth + 1, 0);
		end
		for rows = 0, cellSizeY do
			local line = DevGrid:CreateTexture(nil, 'BACKGROUND');
			if( rows == cellSizeY / 2 ) then -- Half Way Line
				line:SetColorTexture(1, 0, 0, 0.5 );
			else
				line:SetColorTexture(0, 0, 0, 0.5 );
			end
			line:SetPoint('TOPLEFT', DevGrid, 'TOPLEFT', 0, -rows * screenHeight + 1);
			line:SetPoint('BOTTOMRIGHT', DevGrid, 'TOPRIGHT', 0, -rows * screenHeight - 1)
		end
	end
end

-- Handle any of the core /impblizz commands issued by the player
local function HandleCommands(input)
    local command = string.lower(input);

    if(command == "grid") then
        DrawDevGrid();
    end
end

-- Handle the Core Events
local function HandleEvents(self, event, unit)

	-- Auto Repair all Equipment. Uses Guild Bank when possible. Toggleable under Misc Config
	if(event == "MERCHANT_SHOW" and CanMerchantRepair() and Conf_AutoRepair) then
		local repCost, bRepair = GetRepairAllCost();

		if(Conf_GuildBankRepair == true) then
			if(CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repCost and GetGuildBankMoney() >= repCost) then
				if(repCost > 0) then
					RepairAllItems(true);
					print("|cffffff00"..ImpBlizz["Items Repaired from Guild Bank"]..": "..GetCoinTextureString(repCost));
				end
			else
				if(repCost <= GetMoney() and repCost > 0) then
					RepairAllItems(false);
					print("|cffffff00"..ImpBlizz["Items Repaired from Own Money"]..": "..GetCoinTextureString(repCost));
				end
			end
		else
			if(repCost <= GetMoney() and repCost > 0) then
				RepairAllItems(false);
				print("|cffffff00"..ImpBlizz["Items Repaired from Own Money"]..": "..GetCoinTextureString(repCost));
			end
		end
	end

	-- Auto sell all grey items whenever possible. Toggleable under Misc Config
	if( event == "MERCHANT_SHOW" and Conf_SellGreys == true) then
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
			print("|cffffff00"..ImpBlizz["Sold Trash Items"]..": " .. GetCoinTextureString( moneyEarned ) );
		end
	end

	-- Trigger the AFK Camera
	if(event == "PLAYER_FLAGS_CHANGED") then
		if(unit =="player" and Conf_AFKCamera) then
			if(UnitIsAFK(unit) and not UnitIsDead(unit)) then
				AFKCamera_Spin(true);
			else
				AFKCamera_Spin(false);
			end
		end
	elseif(event == "PLAYER_LEAVING_WORLD") then
		AFKCamera_Spin(false);
	elseif(event == "PLAYER_DEAD") then
		if(UnitIsAFK("player")) then
			AFKSpin(false);
		end
	end

	if(event == "PLAYER_ENTERING_WORLD") then
		ModifyMinimap();
	end
end

local function RefreshOrderHallInfo()
	-- Refresh Currency
	local currency = C_Garrison.GetCurrencyTypes(LE_GARRISON_TYPE_7_0)
	local name, amount, texture = GetCurrencyInfo(currency);
	Core.OrderBar.resourcesText:SetText("|T"..texture..":12:12:0:0:60:60:4:60:4:60|t".." "..amount);

	-- Refresh Troops etc
	local troopText = "";
	local info = C_Garrison.GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0);
	for i, troop in ipairs(info) do
		troopText = troopText.."|T".. troop.icon ..":12:12:0:0:60:60:4:60:4:60|t ";
		troopText = troopText.. troop.count .. "/".. troop.limit.."    ";
	end
	Core.OrderBar.troopsText:SetText(troopText);
end

-- Builds the replacement order hall bar
local function BuildOrderHallBar()
	-- Set the Position
	Core.OrderBar:SetFrameStrata("BACKGROUND");
	Core.OrderBar:SetWidth(32);
	Core.OrderBar:SetHeight(32);
	Core.OrderBar:SetPoint("TOP", 0, 0);

	-- Create the Location Text and Assign Font
	Core.OrderBar.locationText = Core.OrderBar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	Core.OrderBar.locationText:SetPoint("CENTER", 0, 0);
	Core.OrderBar.locationText:SetFont(CoreFont, 16, "THINOUTLINE");

	-- Tweak Location Colour
	local classColour = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
	classColour = format("|cff%02x%02x%02x", classColour.r*255, classColour.g*255, classColour.b*255)

	-- Get the name of the current order hall and set it with class colouring
	Core.OrderBar.locationText:SetText(classColour.._G["ORDER_HALL_"..select(2, UnitClass("player"))]);

	-- Create the Order Hall Resources Text and Assign a Font
	Core.OrderBar.resourcesText = Core.OrderBar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	Core.OrderBar.resourcesText:SetPoint("CENTER", -200, 0);
	Core.OrderBar.resourcesText:SetFont(CoreFont, 16, "THINOUTLINE");

	-- Create the Order Hall Resources Text and Assign a Font
	Core.OrderBar.troopsText = Core.OrderBar:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	Core.OrderBar.troopsText:SetPoint("CENTER", 200, 0);
	Core.OrderBar.troopsText:SetFont(CoreFont, 16, "THINOUTLINE");
end

-- Event Handler for the Class Order Hall Bar
local function OrderHallEvents(self, event, ...)
	-- Stop the Order Hall bar from ever showing
	if (event == "ADDON_LOADED" and ... == "Blizzard_OrderHallUI") then
		local OrderHall = OrderHallCommandBar;
		OrderHall:UnregisterAllEvents();
		OrderHall:SetScript("OnShow", OrderHall.Hide);
		OrderHall:Hide();
		GarrisonLandingPageTutorialBox:SetClampedToScreen(true);
		self:UnregisterEvent("ADDON_LOADED");
	end

	-- Check if we're in the order hall
	if event == "UNIT_AURA" or event == "PLAYER_ENTERING_WORLD" then
		-- Hide Order Hall Bar if we're not in the Order Hall
		self:SetShown(C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0))

		if C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0) then
			-- Trigger a refresh
			C_Garrison.RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)

			RefreshOrderHallInfo();
		end
	end

	-- Refresh Information
	if(event == "CURRENCY_DISPLAY_UPDATE" or event == "GARRISON_TALENT_COMPLETE" or event == "GARRISON_TALENT_UPDATE" or event == "UNIT_PHASE" or event == "GARRISON_FOLLOWER_CATEGORIES_UPDATED" or event == "GARRISON_FOLLOWER_ADDED" or event == "GARRISON_FOLLOWER_REMOVED") then
		RefreshOrderHallInfo();
	end
end

-- Initialises the Core module and its relevant submodules
local function Init()
    SLASH_IMPBLIZZ1 = "/impblizz";
    SlashCmdList["IMPBLIZZ"] = HandleCommands; -- Set up the slash commands handler

	AFKCamera_Init();

    Core:SetScript("OnEvent", HandleEvents); -- Set the Event Handler

    -- Register the Core Events
    Core:RegisterEvent("ADDON_LOADED");
	Core:RegisterEvent("PLAYER_FLAGS_CHANGED");
	Core:RegisterEvent("PLAYER_LEAVING_WORLD");
	Core:RegisterEvent("PLAYER_DEAD");
	Core:RegisterEvent("PLAYER_ENTERING_WORLD");
	Core:RegisterEvent("MERCHANT_SHOW");

	CreateCoords();
	PerformanceFrame_Init();

	-- Set up the Class Order Hall Bar
	Core.OrderBar = CreateFrame("Frame", "OrderBar", UIParent);
	BuildOrderHallBar();
	Core.OrderBar:SetScript("OnEvent", OrderHallEvents);
	Core.OrderBar:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
	Core.OrderBar:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED");
	Core.OrderBar:RegisterEvent("GARRISON_FOLLOWER_ADDED");
	Core.OrderBar:RegisterEvent("GARRISON_FOLLOWER_REMOVED");
	Core.OrderBar:RegisterEvent("GARRISON_TALENT_UPDATE");
	Core.OrderBar:RegisterEvent("GARRISON_TALENT_COMPLETE");
	Core.OrderBar:RegisterUnitEvent("UNIT_AURA", "player");
	Core.OrderBar:RegisterUnitEvent("UNIT_PHASE", "player");
	Core.OrderBar:RegisterEvent("PLAYER_ENTERING_WORLD");
	Core.OrderBar:RegisterEvent("ADDON_LOADED");

    -- Init Finished
    print("|cffffff00Improved Blizzard UI " .. GetAddOnMetadata("ImpBlizzardUI", "Version") .. " Initialised");
end

-- End of File, Call Init
Init();
