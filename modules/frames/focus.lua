--[[
    modules\frames\focus.lua
    Styles and Positions the Focus Frame.
]]
ImpUI_Focus = ImpUI:NewModule('ImpUI_Focus', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions

-- Local Variables
local dragFrame;

--[[
    Either applies class colours or resets to blizzards. Called from config.lua
    @ return void
]]
function ImpUI_Focus:ToggleClassColours(enabled)
    if (enabled) then
        ImpUI_Focus:HealthBarChanged(FocusFrame.healthbar);
        if(FocusFrameToT:IsShown()) then
            ImpUI_Focus:HealthBarChanged(FocusFrameToTHealthBar);
        end
    else
        FocusFrame.healthbar:SetStatusBarColor(0, 0.99, 0); -- Blizz Default.
        if(FocusFrameToT:IsShown()) then
            FocusFrameToTHealthBar:SetStatusBarColor(0, 0.99, 0);
        end
    end
end

--[[
	Adds Class Colours.
	
    @ return void
]]
function ImpUI_Focus:AddColours(bar)
    if (bar == nil) then return end
    if (bar.unit == nil) then return end
    if (bar.unit ~= 'focus' and bar.unit ~= 'focus-target') then return end

    if (ImpUI.db.profile.focusClassColours) then
        Helpers.ApplyClassColours(bar, bar.unit);
    end
end

--[[
	Applies the primary interface font to anything related to the Focus Frame.
	
    @ return void
]]
function ImpUI_Focus:AdjustFonts()
    -- Set Fonts
    local font = Helpers.get_styled_font(ImpUI.db.profile.primaryInterfaceFont);

    FocusFrameTextureFrameName:SetFont(font.font, 11, font.flags);
    FocusFrameTextureFrameHealthBarText:SetTextColor(font.r, font.g, font.b, font.a);
    FocusFrameTextureFrameName:SetTextColor(font.r, font.g, font.b, font.a);

    FocusFrameTextureFrameLevelText:SetTextColor(font.r, font.g, font.b, font.a);

    if (FocusFrameTextureFramePVPIcon:IsShown()) then
        FocusFrameTextureFramePVPIcon:Hide();
    end

    -- Style Font
    if(FocusFrameToT:IsShown()) then
        FocusFrameToTTextureFrameName:SetFont(font.font, 11, font.flags);
        FocusFrameToTTextureFrameName:SetTextColor(font.r, font.g, font.b, font.a);
    end
end

--[[
	Hides any background elements that should not appear.
	
    @ return void
]]
function ImpUI_Focus:AdjustBackgrounds()
    FocusFrame.nameBackground:Hide();
end

--[[
	Sets whether buffs appear on the top or bottom of the focus frame.
	
    @ return void
]]
function ImpUI_Focus:AdjustBuffs()
    if (ImpUI.db.profile.focusBuffsOnTop) then
        FocusFrame.buffsOnTop = true;
    else
        FocusFrame.buffsOnTop = false;
    end
end

--[[
	Figures out what texture to assign to the Focus Frame then applies it.
	
    @ return void
]]
function ImpUI_Focus:AdjustTexture()
    local frameTexture;

    local unitClassification = UnitClassification(FocusFrame.unit);

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
end

--[[
	Adjusts the size and position of the Focus Frame health bar.
	
    @ return void
]]
function ImpUI_Focus:AdjustHealth()
    FocusFrame.healthbar:SetHeight(29);
    FocusFrame.healthbar:SetPoint('TOPLEFT',7,-22);
    FocusFrame.healthbar.TextString:SetPoint('CENTER',-50,6);
    FocusFrame.healthbar:SetWidth(119);
    FocusFrame.deadText:SetPoint('CENTER',-50,6);
    FocusFrame.Background:SetPoint('TOPLEFT',7,-22);
end

--[[
	When the health bar changes in any way, reapply class colours.
	
    @ return void
]]
function ImpUI_Focus:HealthBarChanged(bar)
    ImpUI_Focus:AddColours(bar);

    if (bar == nil) then return end

    if (bar.unit == nil) then return end
    if (bar.unit ~= 'focus' and bar.unit ~= 'focus-target') then return end

    ImpUI_Focus:AdjustFonts();
end

function ImpUI_Focus:Style(delayed)

    if (delayed) then
        delay = 2.0;
    else
        delay = 0;
    end

    C_Timer.After(delay, function() 
        if(UnitExists('focus') == false) then return; end

        ImpUI_Focus:AdjustTexture();
        ImpUI_Focus:AdjustHealth();
        ImpUI_Focus:AdjustBackgrounds();
        ImpUI_Focus:AdjustFonts();
        ImpUI_Focus:AdjustBuffs();
        ImpUI_Focus:AddColours(FocusFrame.healthbar);
    end);
end

--[[
	Fired when the Player gains or loses focus of something else.
	
    @ return void
]]
function ImpUI_Focus:PLAYER_FOCUS_CHANGED()
    ImpUI_Focus:Style(false);
end

function ImpUI_Focus:PLAYER_ENTERING_WORLD()
    ImpUI_Focus:Style(true);
end

function ImpUI_Focus:RAID_ROSTER_UPDATE()
    ImpUI_Focus:Style(false);
end

function ImpUI_Focus:GROUP_ROSTER_UPDATE()
    ImpUI_Focus:Style(false);
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

    ImpUI.db.profile.focusFramePosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the Focus Frame from SavedVariables.
]]
function ImpUI_Focus:LoadPosition()
    local pos = ImpUI.db.profile.focusFramePosition;
    local scale = ImpUI.db.profile.focusFrameScale;
    
    -- Set Drag Frame Position
    dragFrame:ClearAllPoints();
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
    if (Helpers.IsClassic()) then return end

    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_FocusFrame_DragFrame', 205, 90, L['Focus Frame']);

    ImpUI_Focus:LoadPosition();

    self:RegisterEvent('PLAYER_FOCUS_CHANGED');
    self:RegisterEvent('PLAYER_ENTERING_WORLD');
    self:RegisterEvent('RAID_ROSTER_UPDATE');
    self:RegisterEvent('GROUP_ROSTER_UPDATE');

    self:SecureHook('UnitFrameHealthBar_Update', 'HealthBarChanged');
    self:SecureHook('HealthBar_OnValueChanged', 'HealthBarChanged');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Focus:OnDisable()
end