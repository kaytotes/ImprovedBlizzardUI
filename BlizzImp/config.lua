local config = {};

local configFont = "Fonts\\FRIZQT__.TTF";
local checkButtonFontSize = 14
local checkButtonOffset = -30;

local headerFontSize = 16;

local function OkayButton()
	
	bClassIcon = config.panel.classChkBtn:GetChecked();
	bAutoRepair = config.panel.repairChkBtn:GetChecked();
	bAutoSell = config.panel.sellChkBtn:GetChecked();
	bHealthWarning = config.panel.healthChkBtn:GetChecked();
	bShowStats = config.panel.statsChkBtn:GetChecked();
	bShowCoords = config.panel.coordsChkBtn:GetChecked();
	bKillTracker = config.panel.trackerChkBtn:GetChecked();
	bKillingBlow = config.panel.killChkBtn:GetChecked();
	bAFKMode = config.panel.afkChkBtn:GetChecked();
	bClassColours = config.panel.colourChkBtn:GetChecked();

	ReloadUI();
end

local function CancelButton()
	config.panel.classChkBtn:SetChecked( bClassIcon );
	config.panel.repairChkBtn:SetChecked( bAutoRepair );
	config.panel.sellChkBtn:SetChecked( bAutoSell );
	config.panel.healthChkBtn:SetChecked( bHealthWarning );
	config.panel.statsChkBtn:SetChecked( bShowStats );
	config.panel.coordsChkBtn:SetChecked( bShowCoords );
	config.panel.trackerChkBtn:SetChecked( bKillTracker );
	config.panel.killChkBtn:SetChecked( bKillingBlow );
	config.panel.afkChkBtn:SetChecked( bAFKMode );
	config.panel.colourChkBtn:SetChecked( bClassColours );
end

local function DefaultButton()
	config.panel.classChkBtn:SetChecked( true );
	config.panel.repairChkBtn:SetChecked( true );
	config.panel.sellChkBtn:SetChecked( true );
	config.panel.healthChkBtn:SetChecked( true );
	config.panel.statsChkBtn:SetChecked( true );
	config.panel.coordsChkBtn:SetChecked( true );
	config.panel.killChkBtn:SetChecked( true );
	config.panel.afkChkBtn:SetChecked( true );
	config.panel.colourChkBtn:SetChecked( true );
end

local function LoadOptions()
	if( bClassIcon ~= nil )then
		config.panel.classChkBtn:SetChecked( bClassIcon );
	end
	if( bAutoRepair ~= nil )then
		config.panel.repairChkBtn:SetChecked( bAutoRepair );
	end
	if( bAutoSell ~= nil )then
		config.panel.sellChkBtn:SetChecked( bAutoSell );
	end
	if( bHealthWarning ~= nil)then
		config.panel.healthChkBtn:SetChecked( bHealthWarning );
	end
	if( bShowStats ~= nil)then
		config.panel.statsChkBtn:SetChecked( bShowStats );
	end
	if( bShowCoords ~= nil)then
		config.panel.coordsChkBtn:SetChecked( bShowCoords );
	end
	if( bKillTracker ~= nil)then
		config.panel.trackerChkBtn:SetChecked( bKillTracker );
	end
	if( bKillingBlow ~= nil)then
		config.panel.killChkBtn:SetChecked( bKillingBlow );
	end
	if( bAFKMode ~= nil)then
		config.panel.afkChkBtn:SetChecked( bAFKMode );
	end
	if( bClassColours ~= nil)then
		config.panel.colourChkBtn:SetChecked( bClassColours );
	end
end

local function Config_HandleEvents( self, event, ...)
	if( event == "ADDON_LOADED" and ... == "BlizzImp")then
		-- If Variable Not Set, Create Default
		if( bClassIcon == nil )then
			bClassIcon = true;
		end
		if( bAutoRepair == nil )then
			bAutoRepair = true;
		end
		if( bAutoSell == nil )then
			bAutoSell = true;
		end
		if( bHealthWarning == nil)then
			bHealthWarning = true;
		end
		if ( bShowStats == nil)then
			bShowStats = true;
		end
		if ( bShowCoords == nil)then
			bShowCoords = true;
		end
		if( bKillTracker == nil)then
			bKillTracker = true;
		end
		if( bKillingBlow == nil)then
			bKillingBlow = true;
		end
		if( bAFKMode == nil)then
			bAFKMode = true;
		end
		if( bClassColours == nil)then
			bClassColours = true;
		end

		LoadOptions();
	end
end

local function CreateLayout()
	-- Options Menu Title
	config.panel.titleText = config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal" );
	config.panel.titleText:SetFont(configFont, 18, "OUTLINE");
	config.panel.titleText:SetPoint("TOPLEFT", 5, -10)
	config.panel.titleText:SetText("|cffffff00 Improved Blizzard UI:- " ..GetAddOnMetadata("BlizzImp", "Version"));

	-- Combat Header
	config.panel.combatHeader = config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	config.panel.combatHeader:SetFont(configFont, headerFontSize, "OUTLINE");
	config.panel.combatHeader:SetPoint("TOPLEFT", 5, -40);
	config.panel.combatHeader:SetText("|cffffff00 - Combat -");

	-- Combat Check Boxes Start ==============

	-- Class Icon Check Box
	config.panel.classChkBtn = CreateFrame("CheckButton", "ClassCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.classChkBtn:ClearAllPoints();
	config.panel.classChkBtn:SetPoint("TOPLEFT", 5, -60 );
	_G[config.panel.classChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.classChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Display Class Icon");

	-- Display Health Warnings Check Box
	config.panel.healthChkBtn = CreateFrame("CheckButton", "HealthCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.healthChkBtn:ClearAllPoints();
	config.panel.healthChkBtn:SetPoint("TOPLEFT", 5, -90 );
	_G[config.panel.healthChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.healthChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Display Health Warnings");

	-- Display PvP Kill Tracker Check Box
	config.panel.trackerChkBtn = CreateFrame("CheckButton", "PvPCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.trackerChkBtn:ClearAllPoints();
	config.panel.trackerChkBtn:SetPoint("TOPLEFT", 5, -120 );
	_G[config.panel.trackerChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.trackerChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Display PvP Kill Tracker");

	-- Display Killing Blows Check Box
	config.panel.killChkBtn = CreateFrame("CheckButton", "KillCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.killChkBtn:ClearAllPoints();
	config.panel.killChkBtn:SetPoint("TOPLEFT", 5, -150 );
	_G[config.panel.killChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.killChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Display PvP Killing Blow Indicator");

	-- Display Class Colours Check Box
	config.panel.colourChkBtn = CreateFrame("CheckButton", "ColCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.colourChkBtn:ClearAllPoints();
	config.panel.colourChkBtn:SetPoint("TOPLEFT", 5, -180 );
	_G[config.panel.colourChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.colourChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Display Class Colours");


	-- Combat Check Boxes End ==============

	-- Misc Header
	config.panel.miscHeader = config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	config.panel.miscHeader:SetFont(configFont, headerFontSize, "OUTLINE");
	config.panel.miscHeader:SetPoint("TOPLEFT", 5, -230);
	config.panel.miscHeader:SetText("|cffffff00 - Miscellaneous -");

	-- Misc Check Boxes Start ==============

	-- Auto Repair Check Box
	config.panel.repairChkBtn = CreateFrame("CheckButton", "RepairCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.repairChkBtn:ClearAllPoints();
	config.panel.repairChkBtn:SetPoint("TOPLEFT", 5, -250);
	_G[config.panel.repairChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.repairChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Auto Repair");

	-- Auto Sell Greys Check Box
	config.panel.sellChkBtn = CreateFrame("CheckButton", "SellCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.sellChkBtn:ClearAllPoints();
	config.panel.sellChkBtn:SetPoint("TOPLEFT", 5, -280);
	_G[config.panel.sellChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.sellChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Auto Sell Trash");

	-- Auto Sell Greys Check Box
	config.panel.afkChkBtn = CreateFrame("CheckButton", "AFKCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.afkChkBtn:ClearAllPoints();
	config.panel.afkChkBtn:SetPoint("TOPLEFT", 5, -310);
	_G[config.panel.afkChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.afkChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - AFK Mode");

	-- Misc Check Boxes End ==============

	-- UI Header
	config.panel.uiHeader = config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	config.panel.uiHeader:SetFont(configFont, headerFontSize, "OUTLINE");
	config.panel.uiHeader:SetPoint("TOPLEFT", 5, -360);
	config.panel.uiHeader:SetText("|cffffff00 - User Interface -");

	-- UI Check Boxes Start ==============

	-- Display Net / FPS Stats Check Box
	config.panel.statsChkBtn = CreateFrame("CheckButton", "StatsCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.statsChkBtn:ClearAllPoints();
	config.panel.statsChkBtn:SetPoint("TOPLEFT", 5, -380 );
	_G[config.panel.statsChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.statsChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Display System Stats");

	-- Display Co-Ordinates Check Box
	config.panel.coordsChkBtn = CreateFrame("CheckButton", "CoordsCheckButton", config.panel, "UICheckButtonTemplate");
	config.panel.coordsChkBtn:ClearAllPoints();
	config.panel.coordsChkBtn:SetPoint("TOPLEFT", 5, -410 );
	_G[config.panel.coordsChkBtn:GetName().."Text"]:SetFont(configFont, checkButtonFontSize, "OUTLINE")
	_G[config.panel.coordsChkBtn:GetName().."Text"]:SetText("|cffFFFFFF - Display Player Co-Ordinates");

	-- UI Check Boxes End ==============
end

-- Interface Options Panel
config.panel = CreateFrame( "Frame", "impConfig", UIParent );
config.panel.name = "Improved Blizzard UI";
config.panel.okay = OkayButton;
config.panel.cancel = CancelButton;
config.panel.default = DefaultButton

config.panel:SetScript("OnEvent", Config_HandleEvents)
config.panel:RegisterEvent("ADDON_LOADED");

CreateLayout();

InterfaceOptions_AddCategory(config.panel)

