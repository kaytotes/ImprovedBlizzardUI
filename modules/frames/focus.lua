--[[
    modules\frames\party.lua
    Styling and Repositioning of the Focus Frame
]]
local addonName, Loc = ...;

local FocusUnitFrame = CreateFrame('Frame', nil, UIParent);  

--[[
    Set the Buffs on top of the Frame
    @ return void
]]
local function SetBuffs()
    FocusFrame.buffsOnTop = true;
end

--[[
    Apply textures and fonts
    @ return void
]]
local function StyleFocusFrame()
    if (FramesDB.stylePrimaryFrames == false) then return; end

    if(UnitExists('focus') == false) then return; end

    local unitClassification = UnitClassification(FocusFrame.unit);

    -- Set Sizes
    FocusFrame.healthbar:SetHeight(29);
    FocusFrame.healthbar:SetPoint('TOPLEFT',7,-22);
    FocusFrame.healthbar.TextString:SetPoint('CENTER',-50,6);
    FocusFrame.deadText:SetPoint('CENTER',-50,6);
    FocusFrame.nameBackground:Hide();
    FocusFrame.Background:SetPoint('TOPLEFT',7,-22);

    -- Add Dragons etc if needed
    local frameTexture;
    if ( unitClassification == 'worldboss' or unitClassification == 'elite' ) then
		frameTexture = 'Interface\\Addons\\ImprovedBlizzardUIClean\\media\\UI-TargetingFrame-Elite';
	elseif ( unitClassification == 'rareelite' ) then
		frameTexture = 'Interface\\Addons\\ImprovedBlizzardUIClean\\media\\UI-TargetingFrame-Rare-Elite';
	elseif ( unitClassification == 'rare' ) then
        frameTexture = 'Interface\\Addons\\ImprovedBlizzardUIClean\\media\\UI-TargetingFrame-Rare';
    else
        frameTexture = 'Interface\\Addons\\ImprovedBlizzardUIClean\\media\\UI-TargetingFrame';
	end

    FocusFrame.borderTexture:SetTexture(frameTexture);

    if (FramesDB.focusClassColours) then
        Imp.ApplyClassColours(FocusFrame.healthbar, FocusFrame.healthbar.unit);
    end

    local file, size, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

    FocusFrameTextureFrameName:SetFont(file, 11, flags);
    FocusFrameTextureFrameHealthBarText:SetTextColor(r, g, b, a);
    FocusFrameTextureFrameName:SetTextColor(r, g, b, a);

    FocusFrame.healthbar:SetWidth(119);
    FocusFrame.healthbar.lockColor = true;

    if (FocusFrameTextureFramePVPIcon:IsShown()) then
        FocusFrameTextureFramePVPIcon:Hide();
    end

    -- Style Font
    if(FocusFrameToT:IsShown()) then
        FocusFrameToTTextureFrameName:SetFont(ImpFont, 11, flags);
        FocusFrameToTTextureFrameName:SetTextColor(r, g, b, a);
    end

    SetBuffs();
end

--[[
    Moves the Focus Frame
    @ return void
]]
local function SetPosition()
    -- Position (Lets re-unlock the frame so it can be moved!)
    FocusFrame:SetMovable(true);
    FocusFrame:SetScale(FramesDB.primaryScale - 0.15);
end

--[[
    Don't allow rescaling
    @ return void
]]
local function FocusFrame_SetSmallSize_Hook(toggle)
    SetPosition();
    StyleFocusFrame();
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_ENTERING_WORLD') then

        SetPosition();

        SetBuffs();

        StyleFocusFrame();
    end
end

-- Register the Modules Events
FocusUnitFrame:SetScript('OnEvent', HandleEvents);
FocusUnitFrame:RegisterEvent('PLAYER_ENTERING_WORLD');

hooksecurefunc('FocusFrame_UpdateBuffsOnTop', SetBuffs);
hooksecurefunc('FocusFrame_SetSmallSize', FocusFrame_SetSmallSize_Hook);

FocusFrame:HookScript('OnShow', function()
    StyleFocusFrame();
end);

FocusFrame:HookScript('OnUpdate', function()
    StyleFocusFrame();
end)

hooksecurefunc('UnitFrameHealthBar_Update', function(self)
    if (FramesDB.focusFrameClassColours and self.unit == 'focus') then
        Imp.ApplyClassColours(self, self.unit);
    end
end);
hooksecurefunc('HealthBar_OnValueChanged', function(self)
    if (FramesDB.focusFrameClassColours and self.unit == 'focus') then
        Imp.ApplyClassColours(self, self.unit);
    end
end);