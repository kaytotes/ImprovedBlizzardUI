--[[
    modules\frames\player.lua
    Styles, Scales and Repositions the Player Unit Frame.
    Disables Player Portrait Spam
]]
local addonName, Loc = ...;

local PlayerUnitFrame = CreateFrame('Frame', nil, UIParent);  

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

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_ENTERING_WORLD') then
        -- Position
        PlayerFrame:SetMovable(true);
        PlayerFrame:ClearAllPoints();
        PlayerFrame:SetPoint('CENTER', -FramesDB.primaryOffsetX, -FramesDB.primaryOffsetY);
        PlayerFrame:SetScale(FramesDB.primaryScale);
        PlayerFrame:SetUserPlaced(true);
        PlayerFrame:SetMovable(false);

        HidePlayer(true);
        
        -- Style Frame
        if (FramesDB.stylePrimaryFrames) then
            PlayerFrameHealthBar:SetWidth(119);
            PlayerFrameHealthBar:SetHeight(29);
            PlayerFrameHealthBar:SetPoint('TOPLEFT',106,-22);
            PlayerFrameHealthBarText:SetPoint('CENTER',50,6);
            PlayerFrameTexture:SetTexture('Interface\\AddOns\\ImprovedBlizzardUI\\media\\UI-TargetingFrame');
            PlayerStatusTexture:SetTexture('Interface\\AddOns\\ImprovedBlizzardUI\\media\\UI-Player-Status');

            local file, size, flags = PlayerFrameHealthBarTextLeft:GetFont();
            local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

            PlayerName:SetFont(ImpFont, 11, flags);
            PlayerFrameHealthBarTextLeft:SetFont(ImpFont, 11, flags);
            PlayerName:SetTextColor(r, g, b, a);
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
end

-- Register the Modules Events
PlayerUnitFrame:SetScript('OnEvent', HandleEvents);
PlayerUnitFrame:RegisterEvent('PLAYER_ENTERING_WORLD');
PlayerUnitFrame:RegisterEvent('UNIT_HEALTH');
PlayerUnitFrame:RegisterEvent('PLAYER_REGEN_DISABLED');
PlayerUnitFrame:RegisterEvent('PLAYER_REGEN_ENABLED');
PlayerUnitFrame:RegisterEvent('PLAYER_TARGET_CHANGED');

-- Hook Blizzard Functions
hooksecurefunc('CombatFeedback_OnCombatEvent', CombatFeedback_OnCombatEvent_Hook);
hooksecurefunc('UnitFrameHealthBar_Update', function(self)
    if (FramesDB.playerClassColours and self.unit == 'player') then
        Imp.ApplyClassColours(self, self.unit);
    end
end);
hooksecurefunc('HealthBar_OnValueChanged', function(self)
    if (FramesDB.playerClassColours and self.unit == 'player') then
        Imp.ApplyClassColours(self, self.unit);
    end
end);