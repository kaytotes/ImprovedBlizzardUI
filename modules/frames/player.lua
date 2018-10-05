--[[
    modules\frames\player.lua
    Styles, Scales and Repositions the Player Unit Frame.
    Disables Player Portrait Spam
]]
local addonName, Loc = ...;

local PlayerUnitFrame = CreateFrame('Frame', nil, UIParent);  

local confPlayerClassColours = false;

--[[
    Whenever the Portrait Damage text appears instantly override it

    @ param Frame $self The Frame that is handling the event
    @ param string $event The message eg 'IMMUNE', 'HEAL', 'BLOCK'
    @ param string $flags Extra information eg 'CRITICAL', 'RESIST'
    @ param int $amount THe amount of Damage or Healing done
    @ param int $type Honestly unsure, apparently sets it to black if > 0 but I've never seen this actually happen in game.
]]
local function CombatFeedback_OnCombatEvent_Hook(self, event, flags, amount, type)
    if(FramesDB.playerPortraitSpam) then
        self.feedbackText:SetText(' ');
    end
end

--[[
    Hides the Player Frame when you are out of combat, have no target and are at full health.

    @ param boolean $hide Should we hide the frame
    @ return void
]]
local function HidePlayer(hide)
    if (InCombatLockdown() == false and FramesDB.playerHideOOC) then
        if (hide and UnitHealth('player') == UnitHealthMax('player') and UnitExists('target') == false) then
            PlayerFrame:Hide();
        else
            PlayerFrame:Show();
        end
    end
end

local function StyleFrames()

    if (FramesDB.stylePrimaryFrames == false) then return end
    if (InCombatLockdown() == true) then return end

    PlayerFrameHealthBar:SetWidth(119);
    PlayerFrameHealthBar:SetHeight(29);
    PlayerFrameHealthBar:SetPoint('TOPLEFT',106,-22);
    PlayerFrameHealthBarText:SetPoint('CENTER',50,6);
    PlayerFrameTexture:SetTexture('Interface\\AddOns\\ImprovedBlizzardUIPlus\\media\\UI-TargetingFrame');
    PlayerStatusTexture:SetTexture('Interface\\AddOns\\ImprovedBlizzardUIPlus\\media\\UI-Player-Status');

    local file, size, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

    PlayerName:SetFont(ImpFont, 11, flags);
    -- 10
    PlayerFrameHealthBarText:SetFont(ImpFont, 10, flags);
    PlayerFrameHealthBarTextLeft:SetFont(ImpFont, 10, flags);
    PlayerFrameHealthBarTextRight:SetFont(ImpFont, 10, flags);

    PlayerFrameManaBarText:SetFont(ImpFont, 10, flags);
    PlayerFrameManaBarTextLeft:SetFont(ImpFont, 10, flags);
    PlayerFrameManaBarTextRight:SetFont(ImpFont, 10, flags);

    PlayerFrameAlternateManaBarText:SetFont(ImpFont, 10, flags);
    PlayerFrameAlternateManaBar.RightText:SetFont(ImpFont, 10, flags);
    PlayerFrameAlternateManaBar.LeftText:SetFont(ImpFont, 10, flags);

    PlayerName:SetTextColor(r, g, b, a);

    PetName:SetFont(ImpFont, 11, flags);
    PetName:SetTextColor(r, g, b, a);
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_LOGIN' or (event == 'ADDON_LOADED' and ... == 'ImprovedBlizzardUIPlus')) then
        confPlayerClassColours = FramesDB.playerClassColours;

        -- Position (Lets re-unlock the frame so it can be moved!)
        PlayerFrame:SetMovable(true);
        PlayerFrame:SetScale(FramesDB.primaryScale);

        HidePlayer(true);
        
        -- Style Frame
        if (FramesDB.stylePrimaryFrames) then
            StyleFrames();
        end
    end

    if (event == 'PLAYER_REGEN_DISABLED') then
        HidePlayer(false);
    elseif (event == 'PLAYER_REGEN_ENABLED' or event == 'UNIT_HEALTH') then
        HidePlayer(true);
    end

    if (event == 'PLAYER_TARGET_CHANGED') then
        if (UnitExists('target')) then
            HidePlayer(false);
        else
            HidePlayer(true);
        end
    end

    if (event == 'UNIT_EXITED_VEHICLE' and ... == 'player') then
        StyleFrames();
    end

    if (event == 'UNIT_ENTERED_VEHICLE' and ... == 'player') then
        StyleFrames();
    end
end

-- Register the Modules Events
PlayerUnitFrame:SetScript('OnEvent', HandleEvents);
PlayerUnitFrame:RegisterEvent('PLAYER_ENTERING_WORLD');
PlayerUnitFrame:RegisterEvent('PLAYER_LOGIN');
PlayerUnitFrame:RegisterEvent('UNIT_HEALTH');
PlayerUnitFrame:RegisterEvent('PLAYER_REGEN_DISABLED');
PlayerUnitFrame:RegisterEvent('PLAYER_REGEN_ENABLED');
PlayerUnitFrame:RegisterEvent('PLAYER_TARGET_CHANGED');
PlayerUnitFrame:RegisterEvent('UNIT_EXITED_VEHICLE');
PlayerUnitFrame:RegisterEvent('UNIT_ENTERED_VEHICLE');
PlayerUnitFrame:RegisterEvent('ADDON_LOADED');

-- Hook Blizzard Functions
hooksecurefunc('CombatFeedback_OnCombatEvent', CombatFeedback_OnCombatEvent_Hook);
hooksecurefunc('UnitFrameHealthBar_Update', function(self)
    if (confPlayerClassColours and self.unit == 'player') then
        Imp.ApplyClassColours(self, self.unit);
    end
end);
hooksecurefunc('HealthBar_OnValueChanged', function(self)
    if (confPlayerClassColours and self.unit == 'player') then
        Imp.ApplyClassColours(self, self.unit);
    end
end);

hooksecurefunc('PlayerFrame_Update', StyleFrames);