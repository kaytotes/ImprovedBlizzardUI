--[[
    modules\misc\orderhall.lua
    Replaces the Blizzard Order Hall bar with one that isn't completely ugly.
]]
ImpUI_OrderHall = ImpUI:NewModule('ImpUI_OrderHall', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local orderbar;

--[[
	Gets and formats the Order hall related currency / troops.
	
    @ return void
]]
function ImpUI_OrderHall:RefreshInfo()
    -- Refresh Currency
    local currency = C_Garrison.GetCurrencyTypes(LE_GARRISON_TYPE_7_0)
    local name, amount, texture = GetCurrencyInfo(currency);
    orderbar.resourcesText:SetText('|T'..texture..':12:12:0:0:60:60:4:60:4:60|t'..' '..amount);

    -- Refresh Troops etc
    local troopText = '';
    local info = C_Garrison.GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0);
    for i, troop in ipairs(info) do
        troopText = troopText..'|T'.. troop.icon ..':12:12:0:0:60:60:4:60:4:60|t ';
        troopText = troopText.. troop.count .. '/'.. troop.limit..'    ';
    end
    orderbar.troopsText:SetText(troopText);
end

--[[
	Applies the visual styling to the Order hall bar.
	
    @ return void
]]
function ImpUI_OrderHall:StyleFrame()
    local font = LSM:Fetch('font', ImpUI.db.char.primaryInterfaceFont);
    local size = 14;

    orderbar.locationText:SetFont(font, size, 'THINOUTLINE');
    orderbar.resourcesText:SetFont(font, size, 'THINOUTLINE');
    orderbar.troopsText:SetFont(font, size, 'THINOUTLINE');

    -- Tweak Location Colour
    local classColour = RAID_CLASS_COLORS[select(2, UnitClass('player'))];
    classColour = format('|cff%02x%02x%02x', classColour.r*255, classColour.g*255, classColour.b*255);

    -- Get the name of the current order hall and set it with class colouring
    orderbar.locationText:SetText(classColour.._G['ORDER_HALL_'..select(2, UnitClass('player'))]);
end

--[[
	Kills the blizzard order hall bar.
	
    @ return void
]]
function ImpUI_OrderHall:ADDON_LOADED(event, ...)
    if (... == 'Blizzard_OrderHallUI') then
		local OrderHall = OrderHallCommandBar;
		OrderHall:UnregisterAllEvents();
		OrderHall:SetScript('OnShow', OrderHall.Hide);
		OrderHall:Hide();
		GarrisonLandingPageTutorialBox:SetClampedToScreen(true);
		self:UnregisterEvent('ADDON_LOADED');
    end 
end

--[[
	Player entering the world. Prep the bar.
	
    @ return void
]]
function ImpUI_OrderHall:PLAYER_ENTERING_WORLD()
    ImpUI_OrderHall:PrepBar();
end

--[[
	Fires when the players auras change.
	
    @ return void
]]
function ImpUI_OrderHall:UNIT_AURA(event, ...)
    if (unit == 'player') then
        ImpUI_OrderHall:PrepBar();
    end
end

--[[
	Fires when the players Phase changes.
	
    @ return void
]]
function ImpUI_OrderHall:UNIT_PHASE(event, ...)
    if (unit == 'player') then
        ImpUI_OrderHall:RefreshInfo();
    end
end

--[[
	Hides the Order Hall Bar if we're not in the Order hall and pulls info.
	
    @ return void
]]
function ImpUI_OrderHall:PrepBar()
    orderbar:SetShown(C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0));

    -- Refresh Info
    if (C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0)) then
        C_Garrison.RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0);

        ImpUI_OrderHall:RefreshInfo();
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_OrderHall:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_OrderHall:OnEnable()
    if (Helpers.IsClassic()) then return end

    orderbar = CreateFrame('Frame', nil, UIParent);

    -- Set the Position
    orderbar:SetFrameStrata('BACKGROUND');
    orderbar:SetWidth(32);
    orderbar:SetHeight(32);
    orderbar:SetPoint('TOP', 0, 0);

    -- Create the Location Text and Assign Font
    orderbar.locationText = orderbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    orderbar.locationText:SetPoint('CENTER', 0, 0);

    -- Create the Order Hall Resources Text and Assign a Font
    orderbar.resourcesText = orderbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    orderbar.resourcesText:SetPoint('CENTER', -200, 0);

    -- Create the Order Hall Troops Text and Assign a Font
    orderbar.troopsText = orderbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    orderbar.troopsText:SetPoint('CENTER', 300, 0);

    ImpUI_OrderHall:StyleFrame();

    -- Register Events
    self:RegisterEvent('ADDON_LOADED');
    self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'RefreshInfo');
    self:RegisterEvent('GARRISON_FOLLOWER_CATEGORIES_UPDATED', 'RefreshInfo');
    self:RegisterEvent('GARRISON_FOLLOWER_ADDED', 'RefreshInfo');
    self:RegisterEvent('GARRISON_FOLLOWER_REMOVED', 'RefreshInfo');
    self:RegisterEvent('GARRISON_TALENT_UPDATE', 'RefreshInfo');
    self:RegisterEvent('GARRISON_TALENT_COMPLETE', 'RefreshInfo');
    self:RegisterEvent('PLAYER_ENTERING_WORLD', 'PrepBar');
    self:RegisterEvent('UNIT_AURA');
    self:RegisterEvent('UNIT_PHASE');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_OrderHall:OnDisable()
end