--[[
    modules\frames\focus.lua
    Styles and Positions the Focus Frame.
]]
local ImpUI_Focus = ImpUI:NewModule('ImpUI_Focus', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions

-- Local Variables
local dragFrame;

--[[
	Actually does
]]
function ImpUI_Focus:StyleFrame()
    if (ImpUI.db.char.styleUnitFrames == false) then return; end

    if(UnitExists('focus') == false) then return; end

    local unitClassification = UnitClassification(FocusFrame.unit);

    -- Figure out what texture we need.
    local frameTexture;
    if ( unitClassification == 'worldboss' or unitClassification == 'elite' ) then
		frameTexture = 'Interface\\Addons\\ImprovedBlizzardUI\\media\\UI-TargetingFrame-Elite';
	elseif ( unitClassification == 'rareelite' ) then
		frameTexture = 'Interface\\Addons\\ImprovedBlizzardUI\\media\\UI-TargetingFrame-Rare-Elite';
	elseif ( unitClassification == 'rare' ) then
        frameTexture = 'Interface\\Addons\\ImprovedBlizzardUI\\media\\UI-TargetingFrame-Rare';
    else
        frameTexture = 'Interface\\Addons\\ImprovedBlizzardUI\\media\\UI-TargetingFrame';
	end

    -- Apply It
    FocusFrame.borderTexture:SetTexture(frameTexture);

    -- Update Health Bar Size
    FocusFrame.healthbar:SetHeight(29);
    FocusFrame.healthbar:SetPoint('TOPLEFT',7,-22);
    FocusFrame.healthbar.TextString:SetPoint('CENTER',-50,6);
    FocusFrame.healthbar:SetWidth(119);
    FocusFrame.deadText:SetPoint('CENTER',-50,6);
    FocusFrame.Background:SetPoint('TOPLEFT',7,-22);
    

    -- Hide Background
    FocusFrame.nameBackground:Hide();

    -- Class Colours
    if (ImpUI.db.char.focusClassColours) then
        Helpers.ApplyClassColours(FocusFrame.healthbar, FocusFrame.healthbar.unit);
    end
    FocusFrame.healthbar.lockColor = true;

    -- Set Fonts
    local font = LSM:Fetch('font', ImpUI.db.char.primaryInterfaceFont);
    local _, _, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

    FocusFrameTextureFrameName:SetFont(font, 11, flags);
    FocusFrameTextureFrameHealthBarText:SetTextColor(r, g, b, a);
    FocusFrameTextureFrameName:SetTextColor(r, g, b, a);

    if (FocusFrameTextureFramePVPIcon:IsShown()) then
        FocusFrameTextureFramePVPIcon:Hide();
    end

    -- Style Font
    if(FocusFrameToT:IsShown()) then
        FocusFrameToTTextureFrameName:SetFont(font, 11, flags);
        FocusFrameToTTextureFrameName:SetTextColor(r, g, b, a);
    end

    -- Buffs on Top
    if (ImpUI.db.char.focusBuffsOnTop) then
        FocusFrame.buffsOnTop = true;
    else
        FocusFrame.buffsOnTop = false;
    end
end

--[[
	When the health bar changes in any way, reapply class colours.
	
    @ return void
]]
function ImpUI_Focus:HealthBarChanged(bar)
    if (ImpUI.db.char.focusClassColours and bar.unit == 'focus') then
        Helpers.ApplyClassColours(bar, bar.unit);
    end
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_Focus:Unlock()
    dragFrame:Show();
end

--[[
	Called when locking the UI.
]]
function ImpUI_Focus:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    ImpUI.db.char.focusFramePosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the Focus Frame from SavedVariables.
]]
function ImpUI_Focus:LoadPosition()
    local pos = ImpUI.db.char.focusFramePosition;
    local scale = ImpUI.db.char.focusFrameScale;
    
    -- Set Drag Frame Position
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);

    -- Parent Focus Frame to the Drag Frame.
    FocusFrame:SetMovable(true);
    FocusFrame:ClearAllPoints();
    FocusFrame:SetPoint('CENTER', dragFrame, 'CENTER', 15, 0);
    FocusFrame:SetScale(scale);
    FocusFrame:SetUserPlaced(true);
    FocusFrame:SetMovable(false);
end


--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Focus:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Focus:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_FocusFrame_DragFrame', 205, 90, L['Focus Frame']);

    ImpUI_Focus:LoadPosition();

    ImpUI_Focus:StyleFrame();

    -- Register Hooks
    self:SecureHook('FocusFrame_UpdateBuffsOnTop', 'StyleFrame');
    self:SecureHook('FocusFrame_SetSmallSize', function ()
        ImpUI_Focus:LoadPosition();
        ImpUI_Focus:StyleFrame();
    end);
    self:SecureHook('UnitFrameHealthBar_Update', 'HealthBarChanged');
    self:SecureHook('HealthBar_OnValueChanged', 'HealthBarChanged');

    self:HookScript(FocusFrame, 'OnShow', 'StyleFrame');
    self:HookScript(FocusFrame, 'OnUpdate', 'StyleFrame');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Focus:OnDisable()
end