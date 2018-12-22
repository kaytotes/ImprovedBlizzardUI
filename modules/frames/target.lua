--[[
    modules\frames\target.lua
    Styles, Scales and Repositions the Target Unit Frame.
]]
local ImpUI_TargetFrame = ImpUI:NewModule('ImpUI_TargetFrame', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local dragFrame;

-- Local Functions
local UnitClassification = UnitClassification;

--[[
	When the ToT health bar changes in any way, reapply class colours.
	
    @ return void
]]
function ImpUI_TargetFrame:TargetofTargetHealthCheck(self)
    if (ImpUI.db.char.targetOfTargetClassColours) then
        Helpers.ApplyClassColours(self.healthbar, self.healthbar.unit);
    end
end

--[[
	When the health bar changes in any way, reapply class colours.
	
    @ return void
]]
function ImpUI_TargetFrame:HealthBarChanged(bar)
    if (ImpUI.db.char.targetClassColours and bar.unit == 'target') then
        Helpers.ApplyClassColours(bar, bar.unit);
    end
end

--[[
	Applies the actual styling.
	
    @ return void
]]
function ImpUI_TargetFrame:StyleFrame()
    if (ImpUI.db.char.styleUnitFrames == false) then return; end

    local unitClassification = UnitClassification(TargetFrame.unit);

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
    TargetFrame.borderTexture:SetTexture(frameTexture);

    -- Update Health Bar Size
    TargetFrame.healthbar:SetHeight(29);
    TargetFrame.healthbar:SetPoint('TOPLEFT',7,-22);
    TargetFrame.healthbar.TextString:SetPoint('CENTER',-50,6);
    TargetFrame.deadText:SetPoint('CENTER',-50,6);
    TargetFrame.nameBackground:Hide();
    TargetFrame.Background:SetPoint('TOPLEFT',7,-22);

    -- Class Colours
    if (ImpUI.db.char.targetClassColours) then
        Helpers.ApplyClassColours(TargetFrame.healthbar, TargetFrame.healthbar.unit);
    end

    -- Buffs on Top.
    if (ImpUI.db.char.targetBuffsOnTop) then
        TargetFrame.buffsOnTop = true;
    else
        TargetFrame.buffsOnTop = false;
    end

    -- Fonts
    local font = LSM:Fetch('font', ImpUI.db.char.primaryInterfaceFont);
    local _, _, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

    TargetFrameTextureFrameHealthBarText:SetTextColor(r, g, b, a);
    TargetFrameTextureFrameName:SetTextColor(r, g, b, a);

    TargetFrameTextureFrameName:SetFont(font, 11, flags);

    TargetFrameTextureFrameHealthBarText:SetFont(font, 10, flags);
    TargetFrameTextureFrameHealthBarTextLeft:SetFont(font, 10, flags);
    TargetFrameTextureFrameHealthBarTextRight:SetFont(font, 10, flags);
    
    TargetFrameTextureFrameManaBarText:SetFont(font, 10, flags);
    TargetFrameTextureFrameManaBarTextLeft:SetFont(font, 10, flags);
    TargetFrameTextureFrameManaBarTextRight:SetFont(font, 10, flags);

    TargetFrame.healthbar:SetWidth(119);
    TargetFrame.healthbar.lockColor = true;

    TargetFrameTextureFrameLevelText:SetFont(font, 10, flags);
    TargetFrameTextureFrameLevelText:SetTextColor(r, g, b, a);
    TargetFrameTextureFrameLevelText:ClearAllPoints();
    TargetFrameTextureFrameLevelText:SetPoint('RIGHT', -41, -16);

    if ( TargetFrame.totFrame ) then
        TargetFrameToTTextureFrameName:SetFont(font, 11, flags);
        TargetFrameToTTextureFrameName:SetTextColor(r, g, b, a);
    end
end

--[[
	Fires when the Player Logs In.
	
    @ return void
]]
function ImpUI_TargetFrame:PLAYER_LOGIN()
    ImpUI_TargetFrame:LoadPosition();
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_TargetFrame:Unlock()
    dragFrame:Show();
end

--[[
	Called when locking the UI.
]]
function ImpUI_TargetFrame:Lock()

    ImpUI.db.char.targetFramePosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the OSD from SavedVariables.
]]
function ImpUI_TargetFrame:LoadPosition()
    local pos = ImpUI.db.char.targetFramePosition;
    local scale = ImpUI.db.char.targetFrameScale;
    
    -- Set Drag Frame Position
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);

    -- Parent PlayerFrame to the Drag Frame.
    TargetFrame:SetMovable(true);
    TargetFrame:ClearAllPoints();
    TargetFrame:SetPoint('CENTER', dragFrame, 'CENTER', 15, -5);
    TargetFrame:SetScale(scale);
    TargetFrame:SetUserPlaced(true);
    TargetFrame:SetMovable(false);
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_TargetFrame:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_TargetFrame:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_TargetFrame_DragFrame', 205, 90, L['Target Frame']);

    ImpUI_TargetFrame:LoadPosition();

    ImpUI_TargetFrame:StyleFrame();

    -- Register Events
    self:RegisterEvent('PLAYER_LOGIN');

    -- Register Hooks
    self:SecureHook('TargetFrame_CheckDead', 'StyleFrame');
    self:SecureHook('TargetFrame_Update', 'StyleFrame');
    self:SecureHook('TargetFrame_CheckFaction', 'StyleFrame');
    self:SecureHook('TargetFrame_CheckClassification', 'StyleFrame');
    self:SecureHook('TargetofTarget_Update', 'StyleFrame');
    self:SecureHook('TargetofTargetHealthCheck', 'TargetofTargetHealthCheck');
    self:SecureHook('UnitFrameHealthBar_Update', 'HealthBarChanged');
    self:SecureHook('HealthBar_OnValueChanged', 'HealthBarChanged');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_TargetFrame:OnDisable()
end