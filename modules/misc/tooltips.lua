--[[
    modules\misc\tooltips.lua
    Numerous tweaks and changes to the Tooltips Frames
]]
ImpUI_Tooltips = ImpUI:NewModule('ImpUI_Tooltips', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local unitClassification = {
    minus = L['Trivial'],
    trivial = L['Trivial'],
    normal =  L['Normal'],
    rare = L['Rare'],
    elite = L['Elite'],
    rareelite = L['Rare Elite'],
    worldboss = L['World Boss'],
};

-- Default we can fall back too.
local borderColour = {
    r = 0.8,
    g = 0.8,
    b = 0.8,
};

-- Default we can fall back too.
local backgroundColour = {
    r = 0,
    g = 0,
    b = 0
};

-- Local Functions
local UnitIsAFK = UnitIsAFK;
local UnitIsDND = UnitIsDND;
local GetMouseFocus = GetMouseFocus;
local GetUnitName = GetUnitName;
local GetGuildInfo = GetGuildInfo;
local UnitRace = UnitRace;
local UnitIsEnemy = UnitIsEnemy;
local UnitFactionGroup = UnitFactionGroup;
local UnitClassification = UnitClassification;
local UnitCreatureType = UnitCreatureType;
local UnitLevel = UnitLevel;
local GetQuestDifficultyColor = GetQuestDifficultyColor;
local UnitIsFriend = UnitIsFriend;
local UnitName = UnitName;
local UnitExists = UnitExists;
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local GetItemInfo = GetItemInfo;

--[[
	Get whether the Unit is AFK and return a string amendment.
	
    @ return void
]]
local function AFKStatus(unit)
    return UnitIsAFK(unit) and '|cffAAAAAA<AFK>|r ' or UnitIsDND(unit) and '|cffAAAAAA<DND>|r ' or '';
end

--[[
	Resets some styling back to Blizzard defaults
	
    @ return void
]]
function ImpUI_Tooltips:ResetStyle()
    -- Bail out on config 
    if (ImpUI.db.char.styleTooltips == true) then return; end

    GameTooltipStatusBar:SetHeight(8);
    GameTooltipStatusBar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-TargetingFrame-BarFill');

    GameTooltipStatusBar:ClearAllPoints();
    GameTooltipStatusBar:SetPoint('BOTTOMLEFT', 0, -10);
	GameTooltipStatusBar:SetPoint('BOTTOMRIGHT', 0, -10);
end

--[[
	Styles a normal "Unit" tooltip.
	
    @ return void
]]
function ImpUI_Tooltips:StyleNormalTooltip(tip)
    -- Bail out on config 
    if (ImpUI.db.char.styleTooltips == false) then return; end

    -- Check for forbidden tooltip.
    if (tip:IsForbidden()) then return end

    -- Get the Unit
    local name, unit = tip:GetUnit()
	if (not unit) then
		unit = GetMouseFocus() and GetMouseFocus():GetAttribute('unit');
	end
    if not unit then return end

    -- Get the info we're gonna need
    local numLines = tip:NumLines();
    local line = 1;
	name = GetUnitName(unit);
	local guild, rank = GetGuildInfo(unit);
    local race = UnitRace(unit) or '';
    local canAttack = UnitIsEnemy('player', unit);
    local playerFaction = UnitFactionGroup('player');
    local faction = UnitFactionGroup(unit) or canAttack and '' or playerFaction;
	local classification = UnitClassification(unit);
	local creatureType = UnitCreatureType(unit);
    local factionGroup = select(1, UnitFactionGroup(unit));
    local target = unit .. "target";

    -- Unit Level
    local level = UnitLevel(unit);
	local levelColor = GetQuestDifficultyColor(level);
	if (level == -1) then
        level = '??';
        levelColor = Helpers.colour_pack(1, 0, 0, 1);
    end

    -- Friend Status
    local isFriend = UnitIsFriend('player', unit);
    local friendColor = Helpers.colour_pack(1, 1, 1, 1);
    
    if (not isFriend) then
        friendColor = Helpers.colour_pack(1, 0.15, 0, 1);
    else
        friendColor = Helpers.colour_pack(0, 0.55, 1, 1);
    end

    -- Faction Group
    if (factionGroup == 'Horde') then
        factionColour = Helpers.colour_pack(1, 0.15, 0, 1);
    else
        factionColour = Helpers.colour_pack(0, 0.55, 1, 1);
    end

    -- Set the Background Colour
    local backdrop = GameTooltip:GetBackdrop();
	if backdrop.insets.left == 5 then
		backdrop.insets.left = 3;
		backdrop.insets.right = 3;
		backdrop.insets.top = 3;
		backdrop.insets.bottom = 3;
    end
    tip:SetBackdrop(backdrop);
    tip:SetBackdropColor(backgroundColour.r, backgroundColour.g, backgroundColour.b);

    -- Hostility Border
    if (ImpUI.db.char.tooltipHostileBorder) then
        tip:SetBackdropBorderColor(friendColor.r, friendColor.g, friendColor.b);
    else
        tip:SetBackdropBorderColor(borderColour.r, borderColour.g, borderColour.b);
    end

    -- Build the Tooltip
    local lines = {};
	lines[1] = GameTooltipTextLeft1:GetText();

    if (UnitIsPlayer(unit)) then
        -- Class Coloured
        if (ImpUI.db.char.tooltipNameClassColours) then
            GameTooltipTextLeft1:SetFormattedText('|cff%s%s|r %s', Helpers.RGBPercToHex(Helpers.GetClassColour(unit)), UnitName(unit), AFKStatus(unit));
        else
            GameTooltipTextLeft1:SetFormattedText('%s%s', UnitName(unit), AFKStatus(unit));
        end
        
        if (guild) then
            GameTooltipTextLeft2:SetFormattedText('|cff%s%s|r', Helpers.RGBPercToHex(ImpUI.db.char.tooltipGuildColour), guild);
            GameTooltipTextLeft3:SetFormattedText('|cff%s%s|r |cff%s%s|r', Helpers.RGBPercToHex(levelColor), level, Helpers.RGBPercToHex(friendColor), race);
        else
            GameTooltip:AddLine('', 1, 1, 1);
			GameTooltipTextLeft2:SetFormattedText('|cff%s%s|r |cff%s%s|r', Helpers.RGBPercToHex(levelColor), level, Helpers.RGBPercToHex(friendColor), race);
        end

        for i = 2, numLines do
            local line = _G['GameTooltipTextLeft'..i];
            if not line or not line:GetText() then break end

            if (factionGroup and line:GetText():find('^'..factionGroup)) then
                line:SetFormattedText('|cff%s%s|r', Helpers.RGBPercToHex(factionColour), factionGroup);
            end

            if (line:GetText():find('^'..PVP_ENABLED)) then
                line:SetFormattedText('|cff%s%s|r', Helpers.RGBPercToHex(friendColor), PVP_ENABLED);
            end
        end
    else
        for i = 2, numLines do
			local line = _G['GameTooltipTextLeft'..i];
            if not line or not line:GetText() then break end
            
            if (level and line:GetText():find('^'..LEVEL) or (creatureType and line:GetText():find('^'..creatureType))) then
                line:SetFormattedText('|cff%s%s %s|r |cff%s%s|r', Helpers.RGBPercToHex(levelColor), level, unitClassification[classification], Helpers.RGBPercToHex(friendColor), creatureType or 'Unknown');
            end
            
            if (line:GetText():find('^'..PVP_ENABLED)) then
                line:SetFormattedText('|cff%s%s|r', Helpers.RGBPercToHex(friendColor), PVP_ENABLED);
            end
		end
    end

    -- Target of Target
    if (UnitExists(target) and ImpUI.db.char.tooltipToT) then
        local name, _ = UnitName(target);
        local colour = Helpers.GetClassColour(target);

        GameTooltip:AddLine(format("%s: %s", L['Target'], name), colour.r, colour.g, colour.b);
    end

    -- Update Health Bar
    local hp = UnitHealth(unit)
	local max = UnitHealthMax(unit)
    
    -- Set Tooltip Unit.
    GameTooltipStatusBar.unit = unit;
	GameTooltipStatusBar:SetMinMaxValues(0, max);
    GameTooltipStatusBar:SetValue(hp);

    -- Style and Position
	GameTooltipStatusBar:ClearAllPoints();
    GameTooltipStatusBar:SetPoint('BOTTOMLEFT', 5, 5);
	GameTooltipStatusBar:SetPoint('BOTTOMRIGHT', -5, 5);
	GameTooltipStatusBar:SetHeight(5);
    GameTooltipStatusBar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar');

    if (ImpUI.db.char.tooltipHealthClassColours) then
        Helpers.ApplyClassColours(GameTooltipStatusBar, unit);
    end
end

--[[
	Styles an Item template to set the border colour by rarity.
	
    @ return void
]]
function ImpUI_Tooltips:StyleItemTooltip(tip)
    -- Bail out on config 
    if (ImpUI.db.char.styleTooltips == false) then return; end

    local _, item = tip:GetItem();

    if (item) then
        local _, _, rarity = GetItemInfo(item);
        if (rarity) then
            local colour = ITEM_QUALITY_COLORS[rarity];
            tip:SetBackdropBorderColor(colour.r, colour.g, colour.b)
        end
    end
end

--[[
	Forces the tooltip to be anchored to the mouse based on config.
	
    @ return void
]]
function ImpUI_Tooltips:AnchorTooltip(tip, parent)
    if (ImpUI.db.char.anchorMouse) then
        tip:SetOwner(parent, 'ANCHOR_CURSOR');
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Tooltips:OnInitialize()
    --	Disable fade-out effect
    GameTooltip.FadeOut = GameTooltip.Hide;
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Tooltips:OnEnable()
    -- Hook Tooltips
    ImpUI_Tooltips:SecureHook('GameTooltip_SetDefaultAnchor', 'AnchorTooltip');
    ImpUI_Tooltips:HookScript(GameTooltip, 'OnTooltipSetUnit', 'StyleNormalTooltip');
    ImpUI_Tooltips:HookScript(GameTooltip, 'OnTooltipSetItem', 'StyleItemTooltip');
    ImpUI_Tooltips:HookScript(ItemRefTooltip, 'OnTooltipSetItem', 'StyleItemTooltip');
    ImpUI_Tooltips:SecureHook('GameTooltip_SetBackdropStyle', 'StyleItemTooltip');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Tooltips:OnDisable()
end