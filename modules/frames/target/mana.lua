--[[
    modules\frames\target\mana.lua
    Essentially re-adds the Target Frame Mana Text.
]]
local ImpUI_Target_Mana = ImpUI:NewModule('ImpUI_Target_Mana', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local UnitExists = UnitExists;
local UnitIsPlayer = UnitIsPlayer;
local UnitIsDead = UnitIsDead;
local UnitGUID = UnitGUID;

-- Local Variables
local frame;
local display;
local us;
local them;

function ImpUI_Target_Mana:UpdateLeftText(current, max)
    if (UnitIsPlayer('target') and us ~= them) then
        display = 'PERCENT';
    end

    if (display ~= 'BOTH' or UnitIsDead('target')) then 
        frame.left:SetText('');
        return
    end

    if (current == 0 and max == 0) then
        frame.left:SetText(format('%u%%', 0));
        return
    end

    frame.left:SetText(format('%u%%', Helpers.to_percentage(current, max)));
end

function ImpUI_Target_Mana:UpdateRightText(current, max)
    if (UnitIsPlayer('target') and us ~= them) then
        display = 'PERCENT';
    end

    if (display ~= 'BOTH' or UnitIsDead('target')) then 
        frame.right:SetText('');
        return
    end

    frame.right:SetText(current);
end

function ImpUI_Target_Mana:UpdateMiddleText(current, max)
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
        if (current == 0 and max == 0) then
            frame.middle:SetText(format('%u%%', 0));
            return
        end

        frame.middle:SetText(format('%u%%', Helpers.to_percentage(current, max)));
        return
    end
    
    -- Fallback
    frame.middle:SetText('');
end

function ImpUI_Target_Mana:SetTexts()
    if (UnitExists('target') == false) then return end

    display = GetCVar('statusTextDisplay');
    us = UnitGUID('player');
    them = UnitGUID('target');

    local current = UnitPower('target');
    local max = UnitPowerMax('target');

    ImpUI_Target_Mana:UpdateMiddleText(current, max);
    ImpUI_Target_Mana:UpdateLeftText(current, max);
    ImpUI_Target_Mana:UpdateRightText(current, max);
end

--[[
	Fires when the Targets health changes.
	
    @ return void
]]
function ImpUI_Target_Mana:UNIT_POWER_UPDATE(event, unit, type)
    if (unit ~= 'target') then return end

    ImpUI_Target_Mana:SetTexts();
end

--[[
	Fires when the Player changes target.
	
    @ return void
]]
function ImpUI_Target_Mana:PLAYER_TARGET_CHANGED()
    ImpUI_Target_Mana:SetTexts();
end

function ImpUI_Target_Mana:StyleFont()
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
function ImpUI_Target_Mana:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Target_Mana:OnEnable()
    if (Helpers.IsRetail()) then return end

    frame = CreateFrame('Frame', nil, TargetFrame);
    frame:SetWidth(32);
    frame:SetHeight(32);
    frame:SetPoint('CENTER', -50, 6);

    frame.middle = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    frame.left = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    frame.right = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    frame.middle:SetPoint('CENTER', 0, -14);
    frame.left:SetPoint('LEFT', TargetFrame, 'LEFT', 7, -8);
    frame.right:SetPoint('RIGHT', TargetFrame, 'RIGHT', -110, -8);

    ImpUI_Target_Mana:StyleFont();

    frame.middle:SetText('');
    frame.left:SetText('');
    frame.right:SetText('');

    self:RegisterEvent('UNIT_POWER_UPDATE');
    self:RegisterEvent('PLAYER_TARGET_CHANGED');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Target_Mana:OnDisable()
end