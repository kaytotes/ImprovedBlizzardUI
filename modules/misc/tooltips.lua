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
    return UnitIsAFK(unit) and '|cffAAAAAA<afk>|r ' or UnitIsDND(unit) and '|cffAAAAAA<dnd>|r ' or '';
end

--[[
	Resets some styling back to Blizzard defaults
	
    @ return void
]]
function ImpUI_Tooltips:ResetStyle()
    -- Bail out on config 
    if (ImpUI.db.profile.styleTooltips == true) then return; end

    GameTooltipStatusBar:SetHeight(8);
    GameTooltipStatusBar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-TargetingFrame-BarFill');

    GameTooltipStatusBar:ClearAllPoints();
    GameTooltipStatusBar:SetPoint('BOTTOMLEFT', 0, -10);
	GameTooltipStatusBar:SetPoint('BOTTOMRIGHT', 0, -10);
end

function ImpUI_Tooltips:AssignHostilityBorder(tip, unit)
    local friendColor = ImpUI_Tooltips:GetFriendColour(unit);
    local factionColour = ImpUI_Tooltips:GetFactionColour(unit);

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
    if (ImpUI.db.profile.tooltipHostileBorder) then
        tip:SetBackdropBorderColor(friendColor.r, friendColor.g, friendColor.b);
    else
        tip:SetBackdropBorderColor(borderColour.r, borderColour.g, borderColour.b);
    end
end


function ImpUI_Tooltips:AddTargetOfTarget(unit)
    local target = unit .. "target";

    -- Target of Target
    if (UnitExists(target) and ImpUI.db.profile.tooltipToT) then
        local name, _ = UnitName(target);
        local colour = Helpers.GetClassColour(target);

        GameTooltip:AddLine(format("%s: %s", L['Target'], name), colour.r, colour.g, colour.b);
    end
end

function ImpUI_Tooltips:StyleHealthBar(unit)
    -- Update Health Bar
    local hp = UnitHealth(unit);
    local max = UnitHealthMax(unit);

    if (UnitIsPlayer(unit) or (UnitCreatureType(unit) ~= nil)) then
        GameTooltipStatusBar:Show();
    else
        GameTooltipStatusBar.unit = nil;
        GameTooltipStatusBar:Hide();

        return;
    end

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

    if (ImpUI.db.profile.tooltipHealthClassColours) then
        Helpers.ApplyClassColours(GameTooltipStatusBar, unit);
    end
end

function ImpUI_Tooltips:FormatForPlayer(tip, unit)
    local name = GetUnitName(unit);
    local guild, rank = GetGuildInfo(unit);

    -- Name 
    if (ImpUI.db.profile.tooltipNameClassColours) then
        GameTooltip:AddLine(format('|cff%s%s|r %s', Helpers.RGBPercToHex(Helpers.GetClassColour(unit)), UnitName(unit), AFKStatus(unit)));
    else
        GameTooltip:AddLine(format('%s%s', UnitName(unit), AFKStatus(unit)));
    end

    -- Guild
    if (guild) then
        GameTooltip:AddLine(format('|cff%s%s|r', Helpers.RGBPercToHex(ImpUI.db.profile.tooltipGuildColour), guild));
    end
end

function ImpUI_Tooltips:FormatForCreature(tip, unit)
    local name = GetUnitName(unit);

    -- Name 
    if (ImpUI.db.profile.tooltipNameClassColours) then
        GameTooltip:AddLine(format('|cff%s%s|r', Helpers.RGBPercToHex(Helpers.GetClassColour(unit)), UnitName(unit)));
    else
        GameTooltip:AddLine(format('%s%s', UnitName(unit)));
    end
end

function ImpUI_Tooltips:GetFriendColour(unit)
    local isFriend = UnitIsFriend('player', unit);
    local friendColor = Helpers.colour_pack(1, 1, 1, 1);
    
    if (not isFriend) then
        friendColor = Helpers.colour_pack(1, 0.15, 0, 1);
    else
        friendColor = Helpers.colour_pack(0, 0.55, 1, 1);
    end

    return friendColor;
end

function ImpUI_Tooltips:GetFactionColour(unit)
    local factionGroup = select(1, UnitFactionGroup(unit));

    if (factionGroup == 'Horde') then
        factionColour = Helpers.colour_pack(1, 0.15, 0, 1);
    else
        factionColour = Helpers.colour_pack(0, 0.55, 1, 1);
    end

    return factionColour;
end

function ImpUI_Tooltips:AddLevel(tip, unit, isPlayer)
    local race = UnitRace(unit) or '';
    local canAttack = UnitIsEnemy('player', unit);
    local playerFaction = UnitFactionGroup('player');
    local faction = UnitFactionGroup(unit) or canAttack and '' or playerFaction;
	local classification = UnitClassification(unit);
	local creatureType = UnitCreatureType(unit);
    
    local level = UnitLevel(unit);
    local levelColor = GetQuestDifficultyColor(level);
    
	if (level == -1) then
        level = '??';
        levelColor = Helpers.colour_pack(1, 0, 0, 1);
    end

    local friendColor = ImpUI_Tooltips:GetFriendColour(unit);
    local out;

    if (isPlayer) then
        -- out = level;
        out = format('|cff%s%s|r |cff%s%s|r', Helpers.RGBPercToHex(levelColor), level, Helpers.RGBPercToHex(friendColor), race);
    else
        out = format('|cff%s%s %s|r |cff%s%s|r', Helpers.RGBPercToHex(levelColor), level, unitClassification[classification], Helpers.RGBPercToHex(friendColor), creatureType or 'Unknown');
    end
    
    GameTooltip:AddLine(out);
end

function ImpUI_Tooltips:AddFaction(tip, unit)
    local factionGroup = select(1, UnitFactionGroup(unit));

    if (factionGroup == nil) then return end

    local colour = ImpUI_Tooltips:GetFactionColour(unit);

    local out = format('|cff%s%s|r', Helpers.RGBPercToHex(colour), factionGroup);
    
    GameTooltip:AddLine(out);
end

--[[
	Styles a normal "Unit" tooltip.
	
    @ return void
]]
function ImpUI_Tooltips:StyleNormalTooltip(tip)
    -- Bail out on config 
    if (ImpUI.db.profile.styleTooltips == false) then return; end

    -- Check for forbidden tooltip.
    if (tip:IsForbidden()) then return end

    -- Get the Unit
    local _, unit = tip:GetUnit()
	if (not unit) then
		unit = GetMouseFocus() and GetMouseFocus():GetAttribute('unit');
	end
    if not unit then return end

    ImpUI_Tooltips:AssignHostilityBorder(tip, unit);

    GameTooltip:ClearLines();

    local isPlayer = UnitIsPlayer(unit);

    if (isPlayer) then
        ImpUI_Tooltips:FormatForPlayer(tip, unit)
    else
        ImpUI_Tooltips:FormatForCreature(tip, unit);
    end

    ImpUI_Tooltips:AddLevel(tip, unit, isPlayer);
    ImpUI_Tooltips:AddFaction(tip, unit);
    ImpUI_Tooltips:AddTargetOfTarget(unit);
    ImpUI_Tooltips:StyleHealthBar(unit);
end

--[[
	Styles an Item template to set the border colour by rarity.
	
    @ return void
]]
function ImpUI_Tooltips:StyleItemTooltip(tip)
    -- Bail out on config 
    if (ImpUI.db.profile.styleTooltips == false) then return; end
    if (ImpUI.db.profile.tooltipItemRarity == false) then return; end

    GameTooltipStatusBar.unit = nil;
    GameTooltipStatusBar:Hide();

    local _, item = tip:GetItem();

    if (item) then
        local _, _, rarity = GetItemInfo(item);
        if (rarity) then
            local colour = ITEM_QUALITY_COLORS[rarity];
            tip:SetBackdropBorderColor(colour.r, colour.g, colour.b)
        end
    end
end

function ImpUI_Tooltips:OnHide()
    GameTooltipStatusBar.unit = nil;
    GameTooltipStatusBar:Hide();
end

--[[
	Forces the tooltip to be anchored to the mouse based on config.
	
    @ return void
]]
function ImpUI_Tooltips:AnchorTooltip(tip, parent)
    if (ImpUI.db.profile.anchorMouse) then
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

    

    if (Helpers.IsClassic()) then
        ImpUI_Tooltips:SecureHook('GameTooltip_SetBackdropStyle', 'StyleItemTooltip');
    else
        ImpUI_Tooltips:HookScript(GameTooltip, 'OnHide', 'OnHide');
    end
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Tooltips:OnDisable()
end