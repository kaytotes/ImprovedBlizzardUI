--[[
    modules\frames\target\health.lua
    Essentially re-adds the Target Frame Health Text.
]]
local ImpUI_Target_Health = ImpUI:NewModule('ImpUI_Target_Health', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local UnitExists = UnitExists;
local UnitIsPlayer = UnitIsPlayer;
local UnitIsDead = UnitIsDead;
local UnitGUID = UnitGUID;

-- Local Variables
local frame;
local display;
local us;
local them;

function ImpUI_Target_Health:UpdateLeftText(current, max)
    if (UnitIsPlayer('target') and us ~= them) then
        display = 'PERCENT';
    end

    if (display ~= 'BOTH' or UnitIsDead('target')) then 
        frame.left:SetText('');
        return
    end

    frame.left:SetText(format('%u%%', Helpers.to_percentage(current, max)));
end

function ImpUI_Target_Health:UpdateRightText(current, max)
    if (UnitIsPlayer('target') and us ~= them) then
        display = 'PERCENT';
    end

    if (display ~= 'BOTH' or UnitIsDead('target')) then 
        frame.right:SetText('');
        return
    end

    frame.right:SetText(current);
end

function ImpUI_Target_Health:UpdateMiddleText(current, max)
    if (UnitIsPlayer('target') and us ~= them) then
        display = 'PERCENT';
    end

    if (display == 'NONE' or display == 'BOTH' or UnitIsDead('target')) then 
        frame.middle:SetText('');
        return
    end

    if (display == 'NUMERIC') then
        frame.middle:SetText(format('%u / %u', current, max));
        return
    end

    if (display == 'PERCENT') then
        frame.middle:SetText(format('%u%%', Helpers.to_percentage(current, max)));
        return
    end
    
    -- Fallback
    frame.middle:SetText('');
end

function ImpUI_Target_Health:SetTexts()
    if (UnitExists('target') == false) then return end

    display = GetCVar('statusTextDisplay');
    us = UnitGUID('player');
    them = UnitGUID('target');

    local current = UnitHealth('target');
    local max = UnitHealthMax('target');

    ImpUI_Target_Health:UpdateMiddleText(current, max);
    ImpUI_Target_Health:UpdateLeftText(current, max);
    ImpUI_Target_Health:UpdateRightText(current, max);
end

--[[
	Fires when the Targets health changes.
	
    @ return void
]]
function ImpUI_Target_Health:UNIT_HEALTH(event, unit)
    if (unit ~= 'target') then return end

    ImpUI_Target_Health:SetTexts();
end

--[[
	Fires when the Player changes target.
	
    @ return void
]]
function ImpUI_Target_Health:PLAYER_TARGET_CHANGED()
    ImpUI_Target_Health:SetTexts();
end

function ImpUI_Target_Health:StyleFont()
    local font = Helpers.get_styled_font(ImpUI.db.profile.primaryInterfaceFont);

    frame.middle:SetTextColor(font.r, font.g, font.b, font.a);
    frame.middle:SetFont(font.font, 10, font.flags);
    frame.left:SetTextColor(font.r, font.g, font.b, font.a);
    frame.left:SetFont(font.font, 10, font.flags);
    frame.right:SetTextColor(font.r, font.g, font.b, font.a);
    frame.right:SetFont(font.font, 10, font.flags);
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Target_Health:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Target_Health:OnEnable()
    if (Helpers.IsRetail()) then return end

    frame = CreateFrame('Frame', nil, TargetFrame);
    frame:SetWidth(32);
    frame:SetHeight(32);
    frame:SetPoint('CENTER', -50, 6);

    frame.middle = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    frame.left = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    frame.right = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    frame.middle:SetPoint('CENTER', 0, 0);
    frame.left:SetPoint('LEFT', TargetFrame, 'LEFT', 7, 3);
    frame.right:SetPoint('RIGHT', TargetFrame, 'RIGHT', -110, 3);

    ImpUI_Target_Health:StyleFont();

    frame.middle:SetText('');
    frame.left:SetText('');
    frame.right:SetText('');

    self:RegisterEvent('UNIT_HEALTH');
    self:RegisterEvent('PLAYER_TARGET_CHANGED');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Target_Health:OnDisable()
end