--[[
    modules\frames\player.lua
    Styles, Scales and Repositions the Player Unit Frame.
    Disables Player Portrait Spam
]]
local addonName, Loc = ...;

local TargetUnitFrame = CreateFrame('Frame', nil, UIParent);  

--[[
    Handles the actual styling and scaling of the Target frame.

    @ return void
]]
local function StyleTargetFrame()
    
    if (FramesDB.stylePrimaryFrames == false) then return; end

    local unitClassification = UnitClassification(TargetFrame.unit);

    -- Set Sizes
    if ( unitClassification == "minus" ) then -- The NPC's that display a "small" unit frame
        TargetFrame.healthbar:SetHeight(12);
        TargetFrame.healthbar:SetPoint("TOPLEFT",7,-41);
        TargetFrame.healthbar.TextString:SetPoint("CENTER",-50,4);
        TargetFrame.deadText:SetPoint("CENTER",-50,4);
        TargetFrame.Background:SetPoint("TOPLEFT",7,-41);
    else
        TargetFrame.healthbar:SetHeight(29);
        TargetFrame.healthbar:SetPoint("TOPLEFT",7,-22);
        TargetFrame.healthbar.TextString:SetPoint("CENTER",-50,6);
        TargetFrame.deadText:SetPoint("CENTER",-50,6);
        TargetFrame.nameBackground:Hide();
        TargetFrame.Background:SetPoint("TOPLEFT",7,-22);
    end

    -- Add Dragons etc if needed
    local frameTexture;
    if ( unitClassification == "worldboss" or unitClassification == "elite" ) then
		frameTexture = "Interface\\Addons\\ImprovedBlizzardUI\\media\\UI-TargetingFrame-Elite";
	elseif ( unitClassification == "rareelite" ) then
		frameTexture = "Interface\\Addons\\ImprovedBlizzardUI\\media\\UI-TargetingFrame-Rare-Elite";
	elseif ( unitClassification == "rare" ) then
        frameTexture = "Interface\\Addons\\ImprovedBlizzardUI\\media\\UI-TargetingFrame-Rare";
    else
        frameTexture = "Interface\\Addons\\ImprovedBlizzardUI\\media\\UI-TargetingFrame";
	end

    TargetFrame.borderTexture:SetTexture(frameTexture);

    if (FramesDB.targetClassColours) then
        Imp.ApplyClassColours(TargetFrame.healthbar, TargetFrame.healthbar.unit);
    end

    if (FramesDB.targetBuffsOnTop) then
        TargetFrame.buffsOnTop = true;
    end

    local file, size, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

    TargetFrameTextureFrameName:SetFont(file, 11, flags);
    TargetFrameTextureFrameHealthBarText:SetTextColor(r, g, b, a);
    TargetFrameTextureFrameName:SetTextColor(r, g, b, a);

    TargetFrame.healthbar:SetWidth(119);
    TargetFrame.healthbar.lockColor = true;

    if ( TargetFrame.totFrame ) then
        TargetFrameToTTextureFrameName:SetFont(file, 11, flags);
        TargetFrameToTTextureFrameName:SetTextColor(r, g, b, a);
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
        TargetFrame:SetMovable(true);
        TargetFrame:ClearAllPoints();
        TargetFrame:SetPoint('CENTER', FramesDB.primaryOffsetX, -FramesDB.primaryOffsetY);
        TargetFrame:SetScale(FramesDB.primaryScale);
        TargetFrame:SetUserPlaced(true);
        TargetFrame:SetMovable(false);

        -- Style Frame
        StyleTargetFrame();
    end
end

-- Register the Modules Events
TargetUnitFrame:SetScript('OnEvent', HandleEvents);
TargetUnitFrame:RegisterEvent('PLAYER_ENTERING_WORLD');

function TargetofTargetHealthCheck_Hook(self)
    if (FramesDB.targetOfTargetClassColours) then
        Imp.ApplyClassColours(self.healthbar, self.healthbar.unit);
    end
end

-- Hook a bunch of Blizzard functions
hooksecurefunc("TargetFrame_CheckDead", StyleTargetFrame);
hooksecurefunc("TargetFrame_Update", StyleTargetFrame);
hooksecurefunc("TargetFrame_CheckFaction", StyleTargetFrame);
hooksecurefunc("TargetFrame_CheckClassification", StyleTargetFrame);
hooksecurefunc("TargetofTarget_Update", StyleTargetFrame);

hooksecurefunc("TargetofTargetHealthCheck", TargetofTargetHealthCheck_Hook);