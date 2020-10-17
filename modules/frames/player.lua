--[[
    modules\frames\player.lua
    Styles, Scales and Repositions the Player Unit Frame.
    Disables Player Portrait Spam
]]
ImpUI_Player = ImpUI:NewModule('ImpUI_Player', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local dragFrame;

-- Local Functions
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local UnitExists = UnitExists;
local InCombatLockdown = InCombatLockdown;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;

--[[
    Either applies class colours or resets to blizzards. Called from config.lua
    @ return void
]]
function ImpUI_Player:ToggleClassColours(enabled)
    if (enabled) then
        ImpUI_Player:HealthBarChanged(PlayerFrameHealthBar);
    else
        PlayerFrameHealthBar:SetStatusBarColor(0, 0.99, 0); -- Blizz Default.
    end
end

--[[
    Whenever the Portrait Damage text appears instantly override it
    @ param Frame $self The Frame that is handling the event
    @ param string $event The message eg 'IMMUNE', 'HEAL', 'BLOCK'
    @ param string $flags Extra information eg 'CRITICAL', 'RESIST'
    @ param int $amount THe amount of Damage or Healing done
    @ param int $type Honestly unsure, apparently sets it to black if > 0 but I've never seen this actually happen in game.
]]
function ImpUI_Player:CombatFeedback_OnCombatEvent(self, event, flags, amount, type)
    if(ImpUI.db.profile.playerHidePortraitSpam) then
        self.feedbackText:SetText(' ');
    end
end

--[[
    Hides the Player Frame when you are out of combat, have no target and are at full health.
    @ param boolean $hide Should we hide the frame
    @ return void
]]
function ImpUI_Player:TogglePlayer(toggle)
    if (InCombatLockdown() == false) then
        local maxHealth = UnitHealth('player') == UnitHealthMax('player');
        local maxMana = UnitPower('player', 0) == UnitPowerMax('player', 0);
        local hasTarget = UnitExists('target') == false;

        if (Helpers.IsRetail()) then
            maxMana = true;
        end

        if (toggle and maxHealth and maxMana and hasTarget and ImpUI.db.profile.playerHideOOC) then
            PlayerFrame:Hide();
        else
            PlayerFrame:Show();
        end
    end
end

--[[
	Fires when the Players mana changes.
	
    @ return void
]]
function ImpUI_Player:UNIT_POWER_UPDATE(...)
    ImpUI_Player:TogglePlayer(true);
end

--[[
	When the health bar changes in any way, reapply class colours.
	
    @ return void
]]
function ImpUI_Player:HealthBarChanged(bar)
    if (ImpUI.db.profile.playerClassColours and bar.unit == 'player') then
        Helpers.ApplyClassColours(bar, bar.unit);
    end
end


--[[
	Applies the actual styling.
	
    @ return void
]]
function ImpUI_Player:StyleFrame()
    if (ImpUI.db.profile.styleUnitFrames == false) then return; end

    -- Change Texture
    PlayerFrameTexture:SetTexture('Interface\\AddOns\\ImprovedBlizzardUI\\media\\UI-TargetingFrame');
    PlayerStatusTexture:SetTexture('Interface\\AddOns\\ImprovedBlizzardUI\\media\\UI-Player-Status');

    -- Update Health Bar Size
    PlayerFrameHealthBar:SetWidth(119);
    PlayerFrameHealthBar:SetHeight(29);
    PlayerFrameHealthBar:SetPoint('TOPLEFT',106,-22);
    PlayerFrameHealthBarText:SetPoint('CENTER',50,6);

    -- Apply Fonts and Colours
    local font = LSM:Fetch('font', ImpUI.db.profile.primaryInterfaceFont);
    local _, _, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

    PlayerName:SetFont(font, 11, flags);

    PlayerFrameHealthBarText:SetFont(font, 10, flags);
    PlayerFrameHealthBarTextLeft:SetFont(font, 10, flags);
    PlayerFrameHealthBarTextRight:SetFont(font, 10, flags);

    PlayerFrameManaBarText:SetFont(font, 10, flags);
    PlayerFrameManaBarTextLeft:SetFont(font, 10, flags);
    PlayerFrameManaBarTextRight:SetFont(font, 10, flags);

    if (Helpers.IsRetail()) then
        PlayerFrameAlternateManaBarText:SetFont(font, 10, flags);
        PlayerFrameAlternateManaBar.RightText:SetFont(font, 10, flags);
        PlayerFrameAlternateManaBar.LeftText:SetFont(font, 10, flags);
    end

    PlayerName:SetTextColor(r, g, b, a);

    PetName:SetFont(font, 11, flags);
    PetName:SetTextColor(r, g, b, a);
    PetFrameHealthBarTextLeft:SetFont(font, 10, flags);
    PetFrameHealthBarTextRight:SetFont(font, 10, flags);
    PetFrameManaBarTextLeft:SetFont(font, 10, flags);
    PetFrameManaBarTextRight:SetFont(font, 10, flags);

    point, relativeTo, relativePoint, xOfs, yOfs = PlayerLevelText:GetPoint();
    local level = UnitLevel('player');

    if(level < 100) then
        xOfs = -61.5;
    end

    PlayerLevelText:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs);

    PlayerLevelText:SetFont(font, 10, flags);
    PlayerLevelText:SetTextColor(r, g, b, a);

    self:HealthBarChanged(PlayerFrameHealthBar);
end

--[[
	Fires when the Player Logs In.
	
    @ return void
]]
function ImpUI_Player:PLAYER_LOGIN()
    ImpUI_Player:LoadPosition();
    ImpUI_Player:TogglePlayer(true);

    ImpUI_Player:StyleFrame();
end


--[[
	Fires when the Players health changes.
	
    @ return void
]]
function ImpUI_Player:UNIT_HEALTH()
    ImpUI_Player:TogglePlayer(true);
end

--[[
	Fires when the Player health regen stops.
	
    @ return void
]]
function ImpUI_Player:PLAYER_REGEN_DISABLED()
    ImpUI_Player:TogglePlayer(false);
end

--[[
	Fires when the Player begins gaining health.
	
    @ return void
]]
function ImpUI_Player:PLAYER_REGEN_ENABLED()
    ImpUI_Player:TogglePlayer(true);
end


--[[
	Fires when the Player changes target.
	
    @ return void
]]
function ImpUI_Player:PLAYER_TARGET_CHANGED()
    if (UnitExists('target')) then
        ImpUI_Player:TogglePlayer(false);
    else
        ImpUI_Player:TogglePlayer(true);
    end
end

--[[
	Fires when the Player exits a vehicle.
	
    @ return void
]]
function ImpUI_Player:UNIT_EXITED_VEHICLE(event, ...)
    if (... == 'player') then
        ImpUI_Player:StyleFrame();
    end
end

--[[
	Fires when the Player enters a vehicle.
	
    @ return void
]]
function ImpUI_Player:UNIT_ENTERED_VEHICLE(event, ...)
    if (... == 'player') then
        ImpUI_Player:StyleFrame();
    end
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_Player:Unlock()
    dragFrame:Show();
end

--[[
	Called when locking the UI.
]]
function ImpUI_Player:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    ImpUI.db.profile.playerFramePosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the Player Frame from SavedVariables.
]]
function ImpUI_Player:LoadPosition()
    local pos = ImpUI.db.profile.playerFramePosition;
    local scale = ImpUI.db.profile.playerFrameScale;
    
    -- Set Drag Frame Position
    dragFrame:ClearAllPoints();
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
function ImpUI_Player:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Player:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_Player_DragFrame', 205, 90, L['Player Frame']);

    ImpUI_Player:LoadPosition();

    ImpUI_Player:StyleFrame();

    ImpUI_Player:TogglePlayer(true);

    -- Register Events
    self:RegisterEvent('PLAYER_LOGIN');
    self:RegisterEvent('UNIT_HEALTH');
    self:RegisterEvent('UNIT_POWER_UPDATE');
    self:RegisterEvent('PLAYER_REGEN_DISABLED');
    self:RegisterEvent('PLAYER_REGEN_ENABLED');
    self:RegisterEvent('PLAYER_TARGET_CHANGED');

    if (Helpers.IsRetail()) then
        self:RegisterEvent('UNIT_EXITED_VEHICLE');
        self:RegisterEvent('UNIT_ENTERED_VEHICLE');
    end

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
function ImpUI_Player:OnDisable()
end