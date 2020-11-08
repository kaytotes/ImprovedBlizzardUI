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
	Attempts to find a tooltip line by the provided string.
	
    @ return nil|Frame
]]
local function FindLineBy(tip, search)
    for i = 1, select("#", tip:GetRegions()) do
        local region = select(i, tip:GetRegions())
        if region and region:GetObjectType() == "FontString" then
            local text = region:GetText() -- string or nil

            if (text ~= nil) then
                if (string.find(text, search)) then
                    return region;
                end
            end
        end
    end

    return nil;
end

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

--[[
    Colours the edge of the tooltip based on whether 
    the unit is hostile to the current player.
	
    @ return void
]]
function ImpUI_Tooltips:AssignHostilityBorder(tip, unit)
    local friendColor = ImpUI_Tooltips:GetFriendColour(unit);
    local factionColour = ImpUI_Tooltips:GetFactionColour(unit);

    ImpUI_Tooltips:AdjustBackdrop(tip);

    -- Hostility Border
    if (ImpUI.db.profile.tooltipHostileBorder) then
        tip:SetBackdropBorderColor(friendColor.r, friendColor.g, friendColor.b);
    else
        tip:SetBackdropBorderColor(borderColour.r, borderColour.g, borderColour.b);
    end
end

--[[
    Figure out who the tooltip unit is targetting and 
    add it to the tooltip.
	
    @ return void
]]
function ImpUI_Tooltips:AddTargetOfTarget(unit)
    local target = unit .. "target";

    -- Target of Target
    if (UnitExists(target) and ImpUI.db.profile.tooltipToT) then
        local name, _ = UnitName(target);
        local colour = Helpers.GetClassColour(target);

        GameTooltip:AddLine(format("%s: %s", L['Target'], name), colour.r, colour.g, colour.b);
    end
end

--[[
    Moves the Health bar and adds class colours.
	
    @ return void
]]
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

--[[
    Checks to see if they have a guild and if so recolour it.
	
    @ return void
]]
function ImpUI_Tooltips:FormatGuild(tip, unit)
    if (not UnitIsPlayer(unit)) then return end

    local guild, rank = GetGuildInfo(unit);

    if (guild == nil) then return end

    local out = format('|cff%s%s|r', Helpers.RGBPercToHex(ImpUI.db.profile.tooltipGuildColour), guild);

    if (Helpers.IsClassic()) then
        tip:AddLine(out);
        return
    end

    local target = FindLineBy(tip, guild);

    if (target) then
        target:SetText(out);
    end
end

--[[
    Formats the Name of the Unit.
	
    @ return void
]]
function ImpUI_Tooltips:FormatName(tip, unit)
    local name = UnitName(unit);
    local output;
    local afk;

    if (UnitIsPlayer(unit)) then
        afk = AFKStatus(unit);
    else
        afk = '';
    end

    -- Name 
    if (ImpUI.db.profile.tooltipNameClassColours) then
        output = format('|cff%s%s|r %s', Helpers.RGBPercToHex(Helpers.GetClassColour(unit)), name, afk);
    else
        output = format('%s%s', name, afk);
    end

    _G["GameTooltipTextLeft1"]:SetText(output);
end

--[[
    Finds the Units level, race, etc and styles the row accordingly.
	
    @ return void
]]
function ImpUI_Tooltips:FormatDetails(tip, unit)
    local target = FindLineBy(tip, "^"..LEVEL);

    if (target == nil) then return end

    local orig = target:GetText();

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

    if (UnitIsPlayer(unit)) then
        out = format('|cff%s%s|r |cff%s%s|r', Helpers.RGBPercToHex(levelColor), level, Helpers.RGBPercToHex(friendColor), race);
    else
        out = format('|cff%s%s %s|r |cff%s%s|r', Helpers.RGBPercToHex(levelColor), level, unitClassification[classification], Helpers.RGBPercToHex(friendColor), creatureType or 'Unknown');
    end

    target:SetText(out);
end

--[[
    Not all Units have a Faction Group yet do belong to a "Faction" eg 
    Zandalari Empire. To get this we must do some hacky nonsense
    to extract it from the tooltip.
	
    @ return void
]]
function ImpUI_Tooltips:InferFaction(tip, unit)
    local levelRow = FindLineBy(tip, "^"..LEVEL);

    if (levelRow == nil) then return end

    -- Get index of level row.
    local index = string.match(levelRow:GetName(), '%d[%d,.]*');

    -- Faction will always be after the level
    index = index + 1;

    local row = _G["GameTooltipTextLeft"..index];

    if (row == nil) then return end

    local content = row:GetText();

    if (content == nil or content == '') then return end

    -- If row below level contains "PvP" then no title.
    if (string.find(content, "^"..PVP)) then
        return;
    end

    -- Same with threat
    if (string.find(content, "^"..THREAT_TOOLTIP:gsub("%d%% ", ""))) then
        return;
    end

    local line = FindLineBy(tip, "^"..content);

    if (line == nil) then return end

    line:SetText(format('|cff%s%s|r', Helpers.RGBPercToHex(ImpUI.db.profile.tooltipFactionColour), content));
end

--[[
    Some NPC's have a title eg General Goods Vendor. Attempt 
    to find this title and colour it to match guild colours.
	
    @ return void
]]
function ImpUI_Tooltips:FormatTitle(tip, unit)
    local levelRow = FindLineBy(tip, "^"..LEVEL);

    if (levelRow == nil) then return end

    -- Title is always second so if level is in that place then they
    -- have no title.
    if (levelRow:GetName() == 'GameTooltipTextLeft2') then return end

    local target = _G["GameTooltipTextLeft2"];

    if (target == nil) then return end

    local faction = target:GetText();

    target:SetText(format('|cff%s%s|r', Helpers.RGBPercToHex(ImpUI.db.profile.tooltipGuildColour), faction));
end

--[[
    Finds the PvP status indicator and colours it based on friendly
    status.
	
    @ return void
]]
function ImpUI_Tooltips:FormatPvP(tip, unit)
    local target = FindLineBy(tip, "^"..PVP);

    if (target == nil) then return end

    local colour = ImpUI_Tooltips:GetFriendColour(unit);

    target:SetText(format('|cff%s%s|r', Helpers.RGBPercToHex(colour), PVP));
end

--[[
    If a unit has an explicit faction then just colour that by 
    our friend or foe status.
	
    @ return void
]]
function ImpUI_Tooltips:FormatFaction(tip, unit)
    local factionGroup = select(1, UnitFactionGroup(unit));

    if (factionGroup == nil) then return end

    local target = FindLineBy(tip, "^"..factionGroup);

    if (target == nil) then return end

    if (factionGroup == nil) then 
        factionGroup = target:GetText();
        colour = ImpUI.db.profile.tooltipGuildColour;
    else
        colour = ImpUI_Tooltips:GetFactionColour(unit);
    end

    if (factionGroup == nil) then return end

    local out = format('|cff%s%s|r', Helpers.RGBPercToHex(colour), factionGroup);

    target:SetText(out);
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

--[[
	Styles a normal "Unit" tooltip eg NPC / Players.
	
    @ return void
]]
function ImpUI_Tooltips:StyleUnitTooltip(tip)
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
    ImpUI_Tooltips:FormatName(tip, unit);
    ImpUI_Tooltips:FormatGuild(tip, unit);
    ImpUI_Tooltips:FormatTitle(tip, unit);
    ImpUI_Tooltips:InferFaction(tip, unit)
    ImpUI_Tooltips:FormatDetails(tip, unit);
    ImpUI_Tooltips:FormatFaction(tip, unit);
    ImpUI_Tooltips:FormatPvP(tip, unit);
    ImpUI_Tooltips:AddTargetOfTarget(unit);
    ImpUI_Tooltips:StyleHealthBar(unit);
end

--[[
	Prepares the tooltip for applying a border.
	
    @ return void
]]
function ImpUI_Tooltips:AdjustBackdrop(tip)
    local backdrop = GameTooltip:GetBackdrop();
	if backdrop.insets.left == 5 then
		backdrop.insets.left = 3;
		backdrop.insets.right = 3;
		backdrop.insets.top = 3;
		backdrop.insets.bottom = 3;
    end
    tip:SetBackdrop(backdrop);
    tip:SetBackdropColor(backgroundColour.r, backgroundColour.g, backgroundColour.b);
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
        ImpUI_Tooltips:AdjustBackdrop(tip);

        local _, _, rarity = GetItemInfo(item);
        if (rarity) then
            local colour = ITEM_QUALITY_COLORS[rarity];

            tip:SetBackdropBorderColor(colour.r, colour.g, colour.b);
        end
    end
end

--[[
    Resets the tooltip health bar when hiding so it's 
    fresh on next show.
	
    @ return void
]]
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
    ImpUI_Tooltips:HookScript(GameTooltip, 'OnTooltipSetUnit', 'StyleUnitTooltip');

    if (Helpers.IsClassic()) then
        ImpUI_Tooltips:SecureHook('GameTooltip_SetBackdropStyle', 'StyleItemTooltip');
    else
        ImpUI_Tooltips:HookScript(GameTooltip, 'OnHide', 'OnHide');
        ImpUI_Tooltips:SecureHook('SharedTooltip_SetBackdropStyle', 'StyleItemTooltip');
    end
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Tooltips:OnDisable()
end