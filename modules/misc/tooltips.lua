--[[
    modules\misc\tooltips.lua
    Numerous tweaks and changes to the Tooltips Frames
]]
local addonName, Loc = ...;

local TooltipFrame = CreateFrame('Frame', nil, UIParent);

local fontSize = 12;

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
    minus = Loc['Trivial'],
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

local function UpdateGameTooltipFonts(tooltip)
    local lines = tooltip:NumLines();

    for i = 1, lines do
        -- Left Text
        local line = _G['GameTooltipTextLeft'..i];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end
        
        -- Right Text
        local line = _G['GameTooltipTextRight'..i];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end

        -- Money Prefix 
        local line = _G['GameTooltipMoneyFrame'..i..'PrefixText'];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end

        -- Gold
        local line = _G['GameTooltipMoneyFrame'..i..'GoldButtonText'];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end

        -- Silver
        local line = _G['GameTooltipMoneyFrame'..i..'SilverButtonText'];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end

        -- Copper
        local line = _G['GameTooltipMoneyFrame'..i..'CopperButtonText'];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end
    end

    Tooltip_Small:SetFont(ImpFont, fontSize, 'NONE');
end



local function GameTooltip_OnTooltipSetUnit_Hook(self)
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

    UpdateGameTooltipFonts(self);
end

local function GameTooltip_OnTooltipSetItem_Hook(self)
    local _, item = self:GetItem();

    if (item) then
        local _, _, rarity = GetItemInfo(item);
        if (rarity) then
            self:SetBackdropBorderColor(GetItemQualityColor(rarity));
        end
    end

    UpdateGameTooltipFonts(self);
end

local function UpdateItemRefTooltipFonts(self)
    local lines = self:NumLines();

    -- Set Fonts
    for i = 1, lines do
        -- Left Text
        local line = _G['ItemRefTooltipTextLeft'..i];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end
        
        -- Right Text
        local line = _G['ItemRefTooltipTextRight'..i];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end

        -- Prefix 
        local line = _G['ItemRefTooltipMoneyFrame'..i..'PrefixText'];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end

        -- Gold
        local line = _G['ItemRefTooltipMoneyFrame'..i..'GoldButtonText'];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end

        -- Silver
        local line = _G['ItemRefTooltipMoneyFrame'..i..'SilverButtonText'];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end

        -- Copper
        local line = _G['ItemRefTooltipMoneyFrame'..i..'CopperButtonText'];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end
    end

    Tooltip_Small:SetFont(ImpFont, fontSize, 'NONE');
end

local function ItemRefTooltip_OnTooltipSetItem_Hook(self)
    local _, item = self:GetItem();

    if (item) then
        local _, _, rarity = GetItemInfo(item);
        if (rarity) then
            self:SetBackdropBorderColor(GetItemQualityColor(rarity));
        end
    end

    UpdateItemRefTooltipFonts(self);
end

local function StyleComparison(self)
    -- Quit if needed
    if (PrimaryDB.styleTooltips == false) then return end

    local _, item = self:GetItem();

    if (item) then
        local _, _, rarity = GetItemInfo(item);
        if (rarity) then
            self:SetBackdropBorderColor(GetItemQualityColor(rarity));
        end
    end

    local name = self:GetName();

    local lines = self:NumLines();

    for i = 1, lines do
        local line = _G[name..'TextLeft'..i];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end
        
        -- Right Text
        local line = _G[name..'TextRight'..i];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end
    end
    Tooltip_Small:SetFont(ImpFont, fontSize, 'OUTLINE');
end

local function StylePvPRewardItem(self)
    if (not self) then return end

    local name = self:GetName();
    local lines = self:NumLines();

    for i = 1, lines do
        local line = _G[name..'TextLeft'..i];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end
        
        -- Right Text
        local line = _G[name..'TextRight'..i];
        if (line ~= nil) then
            line:SetFont(ImpFont, fontSize, 'OUTLINE');
        end
    end
end

local function StylePvPRewardTooltip(self)
    self.RewardString:SetFont(ImpFont, fontSize, 'OUTLINE');
    self.Honor:SetFont(ImpFont, fontSize, 'OUTLINE');
    self.XP:SetFont(ImpFont, fontSize, 'OUTLINE');

    self.ItemTooltip.Text:SetFont(ImpFont, fontSize, 'OUTLINE');

    self.ItemTooltip.Tooltip:HookScript('OnTooltipSetItem', StylePvPRewardItem);
end

local function StylePvPConquestTooltip(self)
    local paddingX = 30; --counts both sides
    local paddingY = 70;

    self.Title:SetFont(ImpFont, fontSize, 'OUTLINE');

    self.WeeklyLabel:SetFont(ImpFont, fontSize, 'OUTLINE');
    self.WeeklyBest:SetFont(ImpFont, fontSize, 'OUTLINE');
	self.WeeklyGamesWon:SetFont(ImpFont, fontSize, 'OUTLINE');
	self.WeeklyGamesPlayed:SetFont(ImpFont, fontSize, 'OUTLINE');
    
    self.SeasonLabel:SetFont(ImpFont, fontSize, 'OUTLINE');
	self.SeasonBest:SetFont(ImpFont, fontSize, 'OUTLINE');
	self.SeasonWon:SetFont(ImpFont, fontSize, 'OUTLINE');
    self.SeasonGamesPlayed:SetFont(ImpFont, fontSize, 'OUTLINE');
    
    
    local width = max(
        self.Title:GetStringWidth(),
        self.WeeklyLabel:GetStringWidth(),
        self.WeeklyBest:GetStringWidth(),
        self.WeeklyGamesWon:GetStringWidth(),
        self.WeeklyGamesPlayed:GetStringWidth(),
        self.SeasonLabel:GetStringWidth(),
        self.SeasonBest:GetStringWidth(),
        self.SeasonWon:GetStringWidth(),
        self.SeasonGamesPlayed:GetStringWidth()
    );
    
    local height = fontSize * 9;

    self:SetWidth(width + paddingX);
    self:SetHeight(height + paddingY);
end

--[[
    Handles the WoW API Events Registered Below
    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_ENTERING_WORLD' or event == 'ADDON_LOADED') then
        fontSize = PrimaryDB.tooltipFontSize;
    end

    if (event == 'ADDON_LOADED' and ... == 'Blizzard_PVPUI') then
        fontSize = PrimaryDB.tooltipFontSize;
        StylePvPRewardTooltip(PVPRewardTooltip);

        PVPRewardTooltip:HookScript('OnShow', function ()
            StylePvPRewardTooltip(PVPRewardTooltip);
        end);

        ConquestTooltip:HookScript('OnShow', function ()
            StylePvPConquestTooltip(ConquestTooltip);
        end);

        
    end
end

GameTooltip:HookScript('OnTooltipSetUnit', GameTooltip_OnTooltipSetUnit_Hook)
GameTooltip:HookScript('OnTooltipSetItem', GameTooltip_OnTooltipSetItem_Hook);
GameTooltip:HookScript('OnTooltipSetSpell', UpdateGameTooltipFonts);
ItemRefTooltip:HookScript('OnTooltipSetItem', ItemRefTooltip_OnTooltipSetItem_Hook);
ShoppingTooltip1:HookScript('OnShow', StyleComparison);
ShoppingTooltip2:HookScript('OnShow', StyleComparison);
ItemRefShoppingTooltip1:HookScript('OnShow', StyleComparison);
ItemRefShoppingTooltip1:HookScript('OnShow', StyleComparison);

hooksecurefunc('GameTooltip_ShowCompareItem', function (self)
    StyleComparison(self);
end);

hooksecurefunc('GameTooltip_SetDefaultAnchor', function(self, parent)
    if (PrimaryDB.anchorMouse) then
        self:SetOwner(parent, 'ANCHOR_CURSOR');
    end
end);

-- Register the Modules Events
TooltipFrame:SetScript('OnEvent', HandleEvents);
TooltipFrame:RegisterEvent('PLAYER_ENTERING_WORLD');
TooltipFrame:RegisterEvent('ADDON_LOADED');