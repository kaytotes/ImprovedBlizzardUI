--[[
    modules\bars\orderhall.lua
    A complete replacement for the Blizzard Order Hall Bar
]]
local addonName, Loc = ...;

local OrderHallFrame = CreateFrame('Frame', nil, UIParent);

-- Set the Position
OrderHallFrame:SetFrameStrata('BACKGROUND');
OrderHallFrame:SetWidth(32);
OrderHallFrame:SetHeight(32);
OrderHallFrame:SetPoint('TOP', 0, 0);

-- Create the Location Text and Assign Font
OrderHallFrame.locationText = OrderHallFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
OrderHallFrame.locationText:SetPoint('CENTER', 0, 0);
OrderHallFrame.locationText:SetFont(ImpFont, 14, 'THINOUTLINE');

-- Tweak Location Colour
local classColour = RAID_CLASS_COLORS[select(2, UnitClass('player'))]
classColour = format('|cff%02x%02x%02x', classColour.r*255, classColour.g*255, classColour.b*255)

-- Get the name of the current order hall and set it with class colouring
OrderHallFrame.locationText:SetText(classColour.._G['ORDER_HALL_'..select(2, UnitClass('player'))]);

-- Create the Order Hall Resources Text and Assign a Font
OrderHallFrame.resourcesText = OrderHallFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
OrderHallFrame.resourcesText:SetPoint('CENTER', -200, 0);
OrderHallFrame.resourcesText:SetFont(ImpFont, 14, 'THINOUTLINE');

-- Create the Order Hall Troops Text and Assign a Font
OrderHallFrame.troopsText = OrderHallFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
OrderHallFrame.troopsText:SetPoint('CENTER', 300, 0);
OrderHallFrame.troopsText:SetFont(ImpFont, 14, 'THINOUTLINE');

--[[
    Gathers data and refreshes the Order Hall text
    @ return void
]]
local function RefreshInfo()
    -- Refresh Currency
    local currency = C_Garrison.GetCurrencyTypes(LE_GARRISON_TYPE_7_0)
    local name, amount, texture = GetCurrencyInfo(currency);
    OrderHallFrame.resourcesText:SetText('|T'..texture..':12:12:0:0:60:60:4:60:4:60|t'..' '..amount);

    -- Refresh Troops etc
    local troopText = '';
    local info = C_Garrison.GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0);
    for i, troop in ipairs(info) do
        troopText = troopText..'|T'.. troop.icon ..':12:12:0:0:60:60:4:60:4:60|t ';
        troopText = troopText.. troop.count .. '/'.. troop.limit..'    ';
    end
    OrderHallFrame.troopsText:SetText(troopText);
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    -- Stop the Order Hall bar from ever showing
	if (event == 'ADDON_LOADED' and ... == 'Blizzard_OrderHallUI') then
		local OrderHall = OrderHallCommandBar;
		OrderHall:UnregisterAllEvents();
		OrderHall:SetScript('OnShow', OrderHall.Hide);
		OrderHall:Hide();
		GarrisonLandingPageTutorialBox:SetClampedToScreen(true);
		self:UnregisterEvent('ADDON_LOADED');
    end
    
    if event == 'UNIT_AURA' or event == 'PLAYER_ENTERING_WORLD' then
		-- Hide Order Hall Bar if we're not in the Order Hall
		self:SetShown(C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0));

        -- Refresh Info
		if (C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0)) then
			C_Garrison.RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0);

			RefreshInfo();
		end
	end

	-- Refresh Information
	if(event == 'CURRENCY_DISPLAY_UPDATE' or event == 'GARRISON_TALENT_COMPLETE' or event == 'GARRISON_TALENT_UPDATE' or event == 'UNIT_PHASE' or event == 'GARRISON_FOLLOWER_CATEGORIES_UPDATED' or event == 'GARRISON_FOLLOWER_ADDED' or event == 'GARRISON_FOLLOWER_REMOVED') then
		RefreshInfo();
	end
end

-- Register the Modules Events
OrderHallFrame:SetScript('OnEvent', HandleEvents);
OrderHallFrame:RegisterEvent('CURRENCY_DISPLAY_UPDATE');
OrderHallFrame:RegisterEvent('GARRISON_FOLLOWER_CATEGORIES_UPDATED');
OrderHallFrame:RegisterEvent('GARRISON_FOLLOWER_ADDED');
OrderHallFrame:RegisterEvent('GARRISON_FOLLOWER_REMOVED');
OrderHallFrame:RegisterEvent('GARRISON_TALENT_UPDATE');
OrderHallFrame:RegisterEvent('GARRISON_TALENT_COMPLETE');
OrderHallFrame:RegisterUnitEvent('UNIT_AURA', 'player');
OrderHallFrame:RegisterUnitEvent('UNIT_PHASE', 'player');
OrderHallFrame:RegisterEvent('PLAYER_ENTERING_WORLD');
OrderHallFrame:RegisterEvent('ADDON_LOADED');