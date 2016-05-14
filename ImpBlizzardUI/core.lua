--[[
    ImpBlizzardUI/core.lua
    Handles the misc functions of the addon that don't quite fit into any other category.
    Current Features: Development DevGrid Overlay
    Todo: AFK Camera, Performance Statistics, Player Co-Ordinates, Auto Repair, Auto Sell, ,
]]

local _, ImpBlizz = ...;

local AddonVersion = GetAddOnMetadata("ImpBlizzardUI", "Version");

local Core = CreateFrame("Frame", "ImpCore", UIParent); -- Create the Core frame, doesn't ever get drawn just logic

-- Get Font references
local DamageFont = "Interface\\Addons\\ImpBlizzardUI\\media\\damage.ttf";
local MenuFont = "Interface\\Addons\\ImpBlizzardUI\\media\\impfont.ttf";
local CoreFont = "Fonts\\FRIZQT__.TTF";

-- Development Grid
local DevGrid;

-- AFK Camera
local AFKCamera;

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
				line:SetTexture(1, 0, 0, 0.5 );
			else
				line:SetTexture(0, 0, 0, 0.5 );
			end
			line:SetPoint('TOPLEFT', DevGrid, 'TOPLEFT', columns * screenWidth - 1, 0);
			line:SetPoint('BOTTOMRIGHT', DevGrid, 'BOTTOMLEFT', columns * screenWidth + 1, 0);
		end
		for rows = 0, cellSizeY do
			local line = DevGrid:CreateTexture(nil, 'BACKGROUND');
			if( rows == cellSizeY / 2 ) then -- Half Way Line
				line:SetTexture(1, 0, 0, 0.5 );
			else
				line:SetTexture(0, 0, 0, 0.5 );
			end
			line:SetPoint('TOPLEFT', DevGrid, 'TOPLEFT', 0, -rows * screenHeight + 1);
			line:SetPoint('BOTTOMRIGHT', DevGrid, 'TOPRIGHT', 0, -rows * screenHeight - 1)
		end
	end
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
	AFKCamera.fadeIn:SetDuration(0.25);
	AFKCamera.fadeIn:SetChange(1);
	AFKCamera.fadeIn:SetOrder(1);
	AFKCamera.fadeInAnim:SetScript("OnFinished", function() AFKCamera:SetAlpha(1) end );

	AFKCamera.fadeOutAnim = AFKCamera:CreateAnimationGroup();
	AFKCamera.fadeOut = AFKCamera.fadeOutAnim:CreateAnimation("Alpha");
	AFKCamera.fadeOut:SetDuration(0.25);
	AFKCamera.fadeOut:SetChange(-1);
	AFKCamera.fadeOut:SetOrder(1);
	AFKCamera.fadeOutAnim:SetScript("OnFinished", function() AFKCamera:SetAlpha(0) end );
end

-- Handle any of the core /impblizz commands issued by the player
local function HandleCommands(input)
    local command = string.lower(input);

    if(command == "DevGrid") then
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

    -- Init Finished
    print("|cffffff00Improved Blizzard UI " .. AddonVersion .. " Initialised");
end

-- End of File, Call Init
Init();
