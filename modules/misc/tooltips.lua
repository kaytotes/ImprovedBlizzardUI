--[[
    modules\misc\tooltips.lua
]]
local addonName, Loc = ...;

local TooltipFrame = CreateFrame('Frame', nil, UIParent);

local borderColour = {
    r = 0.8,
    g = 0.8,
    b = 0.8,
};

local backgroundColour = {
    r = 0,
    g = 0,
    b = 0
};

local unitClassification = {
    trivial = Loc['Trivial'],
    normal =  Loc['Normal'],
    rare = Loc['Rare'],
    elite = Loc['Elite'],
    rareelite = Loc['Rare Elite'],
    worldboss = Loc['World Boss'],
};

--	Disable fade-out effect
GameTooltip.FadeOut = GameTooltip.Hide;

local function AFKStatus(unit)
    return UnitIsAFK(unit) and '|cffAAAAAA<AFK>|r ' or UnitIsDND(unit) and '|cffAAAAAA<DND>|r ' or '';
end

function OnTooltipSetUnit_Hook(self)
    -- Quit if needed
    if (PrimaryDB.styleTooltips == false) then return end
    if (self:IsForbidden()) then return end
    
    -- Get the Unit
    local name, unit = self:GetUnit()
	if (not unit) then
		unit = GetMouseFocus() and GetMouseFocus():GetAttribute('unit');
	end
    if not unit then return end
    
    -- Get the info we're gonna need
    local numLines = self:NumLines();
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
		levelColor = { r = 1, g = 0, b = 0 };
    end
    
    -- Friend Status
    local isFriend = UnitIsFriend('player', unit);
    local friendColor = { r = 1, g = 1, b = 1 };
    
	if (not isFriend) then
		friendColor = { r = 1, g = 0.15, b = 0 };
	else
		friendColor = { r = 0, g = 0.55, b = 1 };
    end

    if (factionGroup == 'Horde') then
        factionColour = { r = 1, g = 0.15, b = 0 };
    else
        factionColour = { r = 0, g = 0.55, b = 1 };
    end

    -- Set the Background Colour
    local backdrop = GameTooltip:GetBackdrop();
	if backdrop.insets.left == 5 then
		backdrop.insets.left = 3;
		backdrop.insets.right = 3;
		backdrop.insets.top = 3;
		backdrop.insets.bottom = 3;
    end
    self:SetBackdrop(backdrop);
    self:SetBackdropColor(backgroundColour.r, backgroundColour.g, backgroundColour.b);

    -- Hostility Border
    if (PrimaryDB.hostileBorder) then
        self:SetBackdropBorderColor(friendColor.r, friendColor.g, friendColor.b);
    else
        self:SetBackdropBorderColor(borderColour.r, borderColour.g, borderColour.b);
    end

    -- Build the Tooltip
    local lines = {};
	lines[1] = GameTooltipTextLeft1:GetText();

    if (UnitIsPlayer(unit)) then
        -- Class Coloured
        if (PrimaryDB.nameClassColours) then
            GameTooltipTextLeft1:SetFormattedText('|cff%s%s|r %s', Imp.RGBPercToHex(Imp.GetClassColour(unit)), UnitName(unit), AFKStatus(unit));
        else
            GameTooltipTextLeft1:SetFormattedText('%s%s', UnitName(unit), AFKStatus(unit));
        end
        
        if (guild) then
            GameTooltipTextLeft2:SetFormattedText('|cff%s%s|r', Imp.ARGBToHex(PrimaryDB.guildColour), guild);
            GameTooltipTextLeft3:SetFormattedText('|cff%s%s|r |cff%s%s|r', Imp.RGBPercToHex(levelColor), level, Imp.RGBPercToHex(friendColor), race);
        else
            GameTooltip:AddLine('', 1, 1, 1);
			GameTooltipTextLeft2:SetFormattedText('|cff%s%s|r |cff%s%s|r', Imp.RGBPercToHex(levelColor), level, Imp.RGBPercToHex(friendColor), race);
        end

        for i = 2, numLines do
            local line = _G['GameTooltipTextLeft'..i];
            if not line or not line:GetText() then break end

            if (factionGroup and line:GetText():find('^'..factionGroup)) then
                line:SetFormattedText('|cff%s%s|r', Imp.RGBPercToHex(factionColour), factionGroup);
            end

            if (line:GetText():find('^'..PVP_ENABLED)) then
                line:SetFormattedText('|cff%s%s|r', Imp.RGBPercToHex(friendColor), PVP_ENABLED);
            end
        end
    else
        for i = 2, numLines do
			local line = _G['GameTooltipTextLeft'..i];
            if not line or not line:GetText() then break end
            
            if (level and line:GetText():find('^'..LEVEL) or (creatureType and line:GetText():find('^'..creatureType))) then
                line:SetFormattedText('|cff%s%s %s|r |cff%s%s|r', Imp.RGBPercToHex(levelColor), level, unitClassification[classification], Imp.RGBPercToHex(friendColor), creatureType or 'Unknown');
            end
            
            if (line:GetText():find('^'..PVP_ENABLED)) then
                line:SetFormattedText('|cff%s%s|r', Imp.RGBPercToHex(friendColor), PVP_ENABLED);
            end
		end
    end

    -- Target of Target
    if (UnitExists(target) and PrimaryDB.tooltipToT) then
        local name, _ = UnitName(target);
        local colour = Imp.GetClassColour(target);

        GameTooltip:AddLine(format("%s: %s", Loc['Target'], name), colour.r, colour.g, colour.b);
    end

    -- Update Health Bar
    local hp = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	
	GameTooltipStatusBar.unit = unit;
	GameTooltipStatusBar:SetMinMaxValues(0, max);
	GameTooltipStatusBar:SetValue(hp);
	GameTooltipStatusBar:ClearAllPoints();
    GameTooltipStatusBar:SetPoint('BOTTOMLEFT', 5, 5);
	GameTooltipStatusBar:SetPoint('BOTTOMRIGHT', -5, 5);
	GameTooltipStatusBar:SetHeight(5);
    GameTooltipStatusBar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar');

    if (PrimaryDB.tooltipClassHealth) then
        Imp.ApplyClassColours(GameTooltipStatusBar, unit);
    end
    
    -- Lastly, Set Fonts
    for i = 1, 20 do
		local line = _G['GameTooltipTextLeft'..i];
        if not line then break end

        line:SetFont(ImpFont, 13, 'OUTLINE');
	end
end

GameTooltip:HookScript('OnTooltipSetUnit', OnTooltipSetUnit_Hook)

hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self, parent)
    if (PrimaryDB.anchorMouse) then
        self:SetOwner(parent, 'ANCHOR_CURSOR');
    end
end)