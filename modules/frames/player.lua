--[[
    modules\frames\player.lua
    Styles, Scales and Repositions the Player Unit Frame.
    Disables Player Portrait Spam
]]
ImpUI_PlayerFrame = ImpUI:NewModule('ImpUI_PlayerFrame', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local dragFrame;

-- Local Functions
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local UnitExists = UnitExists;
local InCombatLockdown = InCombatLockdown;

--[[
    Whenever the Portrait Damage text appears instantly override it
    @ param Frame $self The Frame that is handling the event
    @ param string $event The message eg 'IMMUNE', 'HEAL', 'BLOCK'
    @ param string $flags Extra information eg 'CRITICAL', 'RESIST'
    @ param int $amount THe amount of Damage or Healing done
    @ param int $type Honestly unsure, apparently sets it to black if > 0 but I've never seen this actually happen in game.
]]
function ImpUI_PlayerFrame:CombatFeedback_OnCombatEvent(self, event, flags, amount, type)
    if(ImpUI.db.char.playerHidePortraitSpam) then
        self.feedbackText:SetText(' ');
    end
end

--[[
    Hides the Player Frame when you are out of combat, have no target and are at full health.
    @ param boolean $hide Should we hide the frame
    @ return void
]]
local function TogglePlayer(toggle)
    if (InCombatLockdown() == false and ImpUI.db.char.playerHideOOC) then
        if (toggle and UnitHealth('player') == UnitHealthMax('player') and UnitExists('target') == false) then
            PlayerFrame:Hide();
        else
            PlayerFrame:Show();
        end
    end
end


--[[
	When the health bar changes in any way, reapply class colours.
	
    @ return void
]]
function ImpUI_PlayerFrame:HealthBarChanged(bar)
    if (ImpUI.db.char.playerClassColours and bar.unit == 'player') then
        Helpers.ApplyClassColours(bar, bar.unit);
    end
end


--[[
	Applies the actual styling.
	
    @ return void
]]
function ImpUI_PlayerFrame:StyleFrame()
    if (ImpUI.db.char.styleUnitFrames == false) then return; end
    if (InCombatLockdown() == true) then return end

    -- Change Texture
    PlayerFrameTexture:SetTexture('Interface\\AddOns\\ImprovedBlizzardUI\\media\\UI-TargetingFrame');
    PlayerStatusTexture:SetTexture('Interface\\AddOns\\ImprovedBlizzardUI\\media\\UI-Player-Status');

    -- Update Health Bar Size
    PlayerFrameHealthBar:SetWidth(119);
    PlayerFrameHealthBar:SetHeight(29);
    PlayerFrameHealthBar:SetPoint('TOPLEFT',106,-22);
    PlayerFrameHealthBarText:SetPoint('CENTER',50,6);

    -- Apply Fonts and Colours
    local font = LSM:Fetch('font', ImpUI.db.char.primaryInterfaceFont);
    local _, _, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

    PlayerName:SetFont(font, 11, flags);

    PlayerFrameHealthBarText:SetFont(font, 10, flags);
    PlayerFrameHealthBarTextLeft:SetFont(font, 10, flags);
    PlayerFrameHealthBarTextRight:SetFont(font, 10, flags);

    PlayerFrameManaBarText:SetFont(font, 10, flags);
    PlayerFrameManaBarTextLeft:SetFont(font, 10, flags);
    PlayerFrameManaBarTextRight:SetFont(font, 10, flags);

    PlayerFrameAlternateManaBarText:SetFont(font, 10, flags);
    PlayerFrameAlternateManaBar.RightText:SetFont(font, 10, flags);
    PlayerFrameAlternateManaBar.LeftText:SetFont(font, 10, flags);

    PlayerName:SetTextColor(r, g, b, a);

    PetName:SetFont(font, 11, flags);
    PetName:SetTextColor(r, g, b, a);

    PlayerLevelText:SetFont(font, 10, flags);
    PlayerLevelText:SetTextColor(r, g, b, a);
end

--[[
	Fires when the Player Logs In.
	
    @ return void
]]
function ImpUI_PlayerFrame:PLAYER_LOGIN()
    ImpUI_PlayerFrame:LoadPosition();
    TogglePlayer(true);

    ImpUI_PlayerFrame:StyleFrame();
end


--[[
	Fires when the Players health changes.
	
    @ return void
]]
function ImpUI_PlayerFrame:UNIT_HEALTH()
    TogglePlayer(true);
end

--[[
	Fires when the Player health regen stops.
	
    @ return void
]]
function ImpUI_PlayerFrame:PLAYER_REGEN_DISABLED()
    TogglePlayer(false);
end

--[[
	Fires when the Player begins gaining health.
	
    @ return void
]]
function ImpUI_PlayerFrame:PLAYER_REGEN_ENABLED()
    TogglePlayer(true);
end


--[[
	Fires when the Player changes target.
	
    @ return void
]]
function ImpUI_PlayerFrame:PLAYER_TARGET_CHANGED()
    if (UnitExists('target')) then
        TogglePlayer(false);
    else
        TogglePlayer(true);
    end
end

--[[
	Fires when the Player exits a vehicle.
	
    @ return void
]]
function ImpUI_PlayerFrame:UNIT_EXITED_VEHICLE(event, ...)
    if (... == 'player') then
        ImpUI_PlayerFrame:StyleFrame();
    end
end

--[[
	Fires when the Player enters a vehicle.
	
    @ return void
]]
function ImpUI_PlayerFrame:UNIT_ENTERED_VEHICLE(event, ...)
    if (... == 'player') then
        ImpUI_PlayerFrame:StyleFrame();
    end
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_PlayerFrame:Unlock()
    dragFrame:Show();
end

--[[
	Called when locking the UI.
]]
function ImpUI_PlayerFrame:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    ImpUI.db.char.playerFramePosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the OSD from SavedVariables.
]]
function ImpUI_PlayerFrame:LoadPosition()
    local pos = ImpUI.db.char.playerFramePosition;
    local scale = ImpUI.db.char.playerFrameScale;
    
    -- Set Drag Frame Position
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);

    -- Parent PlayerFrame to the Drag Frame.
    PlayerFrame:SetMovable(true);
    PlayerFrame:ClearAllPoints();
    PlayerFrame:SetPoint('CENTER', dragFrame, 'CENTER', -15, -5);
    PlayerFrame:SetScale(scale);
    PlayerFrame:SetUserPlaced(true);
    PlayerFrame:SetMovable(false);
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_PlayerFrame:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_PlayerFrame:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_PlayerFrame_DragFrame', 205, 90, L['Player Frame']);

    ImpUI_PlayerFrame:LoadPosition();

    ImpUI_PlayerFrame:StyleFrame();

    TogglePlayer(true);

    -- Register Events
    self:RegisterEvent('PLAYER_LOGIN');
    self:RegisterEvent('UNIT_HEALTH');
    self:RegisterEvent('PLAYER_REGEN_DISABLED');
    self:RegisterEvent('PLAYER_REGEN_ENABLED');
    self:RegisterEvent('PLAYER_TARGET_CHANGED');
    self:RegisterEvent('UNIT_EXITED_VEHICLE');
    self:RegisterEvent('UNIT_ENTERED_VEHICLE');

    -- Register Hooks
    self:SecureHook('CombatFeedback_OnCombatEvent', 'CombatFeedback_OnCombatEvent');
    self:SecureHook('UnitFrameHealthBar_Update', 'HealthBarChanged');
    self:SecureHook('HealthBar_OnValueChanged', 'HealthBarChanged');
    self:SecureHook('PlayerFrame_Update', 'StyleFrame');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_PlayerFrame:OnDisable()
end