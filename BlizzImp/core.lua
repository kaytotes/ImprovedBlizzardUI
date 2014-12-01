local ADDON_VERSION = "014b";
local core = CreateFrame( "Frame", "ImprovCore", UIParent );

local damageFont = "Interface\\Addons\\BlizzImp\\media\\test.ttf";

local bagsHidden = true; -- Bags Toggle 

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
	{text = "|cffFFFFFFCharacter", func = function() ToggleCharacter( "PaperDollFrame" ) end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle' },
	{text = "|cffFFFFFFSpellbook", func = function() ToggleSpellBook( "spell" ) end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\MINIMAP\\TRACKING\\Class' },
	{text = "|cffFFFFFFTalents", func = function() ToggleTalentFrame() end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\MINIMAP\\TRACKING\\Profession' },
	{text = "|cffFFFFFFAchievements", func = function() ToggleAchievementFrame() end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\MINIMAP\\Minimap_shield_elite', },
	{text = "|cffFFFFFFQuest Log", func = function() ToggleFrame( WorldMapFrame )end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\GossipFrame\\ActiveQuestIcon' },
	{text = "|cffFFFFFFGuild", func = function() ToggleGuildFrame( 1 ) end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\GossipFrame\\TabardGossipIcon' },
	{text = "|cffFFFFFFGroup Finder", func = function() ToggleFrame( PVEFrame ) end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\LFGFRAME\\BattlenetWorking0' },
	{text = "|cffFFFFFFCollections", func = function() TogglePetJournal() end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster' },
	{text = "|cffFFFFFFDungeon Journal", func = function() ToggleEncounterJournal() end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' },
	{text = "|cffFFFFFFSwap Bags", func = function() ShowBagBar() end, notCheckable = true, fontObject = GameFontNormal, icon = 'Interface\\MINIMAP\\TRACKING\\Banker' },
	{text = "|cffffff00Log Out|r", func = function() Logout() end, notCheckable = true, fontObject = GameFontNormal },
	{text = "|cffFE2E2EForce Exit|r", func = function() ForceQuit() end, notCheckable = true, fontObject = GameFontNormal },
}

function HandleSlashCommands( command )
	if( string.lower( command ) == "test" ) then
		print("test");
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
				afkFrameHidden = true;
			end
		end
	end
end

-- Hide Leave Queue button for PvP
local function HideLeaveButton()
	PVPReadyDialog.enterButton:ClearAllPoints();
	PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25);
	PVPReadyDialog.label:SetPoint("TOP", 0, -22);
	PVPReadyDialog.leaveButton:HookScript("OnShow", PVPReadyDialog.leaveButton.Hide);
end

local function ModifyBuffs()
	BuffFrame:ClearAllPoints();
	BuffFrame:SetScale( 1.4 );
	BuffFrame:SetPoint( "TOPRIGHT", -175, -13 );
end

-- Tweak Minimap
local function ModifyMinimap()
	-- Hide Buttons
	MinimapZoomIn:Hide();
	MinimapZoomOut:Hide();

	MinimapCluster:ClearAllPoints();
	MinimapCluster:SetScale(1.15);
	MinimapCluster:SetPoint("TOPRIGHT", -15, -15)

	-- Allow and Handle Scrollwheel Zoom
	Minimap:EnableMouseWheel( true );
	Minimap:SetScript('OnMouseWheel', function( self, delta )
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
	end

	-- Auto Repair
	if( event == "MERCHANT_SHOW" and CanMerchantRepair() == true) then
		local repCost, bRepair = GetRepairAllCost();
		if(bRepair == true) and (repCost <= GetMoney()) then
			RepairAllItems();
			print("|cffffff00Items Repaired");
		end
	end

	-- Sell Grey Items
	if( event == "MERCHANT_SHOW" ) then
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
			print("|cffffff00Sold Trash Items: " .. GetCoinTextureString( moneyEarned ) );
		end
	end	

	-- AFK Camera Spin
	if( event == "PLAYER_FLAGS_CHANGED") then
		-- Check for AFK and Toggle Camera Spin
		if( unit == "player") then
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
end

local function Core_Init()
	core:SetScript( "OnEvent", Core_HandleEvents );

	core:RegisterEvent("ADDON_LOADED");
	core:RegisterEvent("PLAYER_ENTERING_WORLD");
	core:RegisterEvent("PLAYER_FLAGS_CHANGED");
	core:RegisterEvent("MERCHANT_SHOW");

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

Core_Init();