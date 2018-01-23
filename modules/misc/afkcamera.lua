--[[
    modules\misc\afkcamera.lua
    After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.
]]
local addonName, Loc = ...;

-- Set Up AFK Camera
local AFKCamera = CreateFrame('Frame', nil, WorldFrame);
AFKCamera:SetAllPoints();
AFKCamera:SetAlpha(0);
AFKCamera.width, AFKCamera.height = AFKCamera:GetSize();
AFKCamera.hidden = true;

--[[
    Handles turning on and off the AFK Camera

    @ param boolean $spin Whether the spinning should be turned off
    @ return void
]]
local function ToggleSpin(spin)
    -- If the configuration is off or the player is in combat then just do nothing
    if (PrimaryDB.afkMode == false) then return; end

    if (spin) then
        -- Refresh and Set the Player Model anims
        AFKCamera.playerModel:SetUnit("player");
        AFKCamera.playerModel:SetAnimation(0);
        AFKCamera.playerModel:SetRotation(math.rad(-15));
        AFKCamera.playerModel:SetCamDistanceScale(1.2);

        -- Refresh and Set the Pet Model anims
        AFKCamera.petModel:SetUnit("pet");
        AFKCamera.petModel:SetAnimation(0);
        AFKCamera.petModel:SetRotation(math.rad(45));
        AFKCamera.petModel:SetCamDistanceScale(1.7);

        -- Hide the PVE Frame if it is shown
        if(PVEFrame and PVEFrame:IsShown()) then
            AFKCamera.PvEIsOpen = true; -- Store that it was open so that we can automatically reopen it after
            PVEFrame_ToggleFrame();
        else
            AFKCamera.PvEIsOpen = false;
        end

        -- Hide the UI and begin the camera spinning
        UIParent:Hide();
        AFKCamera.fadeInAnim:Play();
        AFKCamera.hidden = false;
        MoveViewRightStart(0.15);
    else
        if(AFKCamera.hidden == false) then
            MoveViewRightStop();
            UIParent:Show();
            AFKCamera.fadeOutAnim:Play();

            -- Reopen PVE Frame if it was open
            if(AFKCamera.PvEIsOpen) then
                PVEFrame_ToggleFrame();
            end

            AFKCamera.hidden = true;
        end
    end
end

-- Set Up the Player Model
AFKCamera.playerModel = CreateFrame('PlayerModel', nil, AFKCamera);
AFKCamera.playerModel:SetSize(AFKCamera.height * 0.8, AFKCamera.height * 1.3);
AFKCamera.playerModel:SetPoint('BOTTOMRIGHT', AFKCamera.height * 0.1, -AFKCamera.height * 0.4);

-- Pet model for Hunters, Warlocks etc
AFKCamera.petModel = CreateFrame('playerModel', nil, AFKCamera);
AFKCamera.petModel:SetSize(AFKCamera.height * 0.7, AFKCamera.height);
AFKCamera.petModel:SetPoint('BOTTOMLEFT', AFKCamera.height * 0.05, -AFKCamera.height * 0.3);

-- Initialise the fadein / out anims
AFKCamera.fadeInAnim = AFKCamera:CreateAnimationGroup();
AFKCamera.fadeIn = AFKCamera.fadeInAnim:CreateAnimation('Alpha');
AFKCamera.fadeIn:SetDuration(0.5);
AFKCamera.fadeIn:SetFromAlpha(0);
AFKCamera.fadeIn:SetToAlpha(1);
AFKCamera.fadeIn:SetOrder(1);
AFKCamera.fadeInAnim:SetScript('OnFinished', function() AFKCamera:SetAlpha(1) end );

AFKCamera.fadeOutAnim = AFKCamera:CreateAnimationGroup();
AFKCamera.fadeOut = AFKCamera.fadeOutAnim:CreateAnimation('Alpha');
AFKCamera.fadeOut:SetDuration(0.5);
AFKCamera.fadeOut:SetFromAlpha(1);
AFKCamera.fadeOut:SetToAlpha(0);
AFKCamera.fadeOut:SetOrder(1);
AFKCamera.fadeOutAnim:SetScript('OnFinished', function() AFKCamera:SetAlpha(0) end );

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_FLAGS_CHANGED') then
		if (... =='player') then
			if (UnitIsAFK(...) and not UnitIsDead(...)) then
				ToggleSpin(true);
			else
				ToggleSpin(false);
			end
		end
	elseif (event == 'PLAYER_LEAVING_WORLD') then
		ToggleSpin(false);
	elseif (event == 'PLAYER_DEAD') then
		if (UnitIsAFK('player')) then
			ToggleSpin(false);
		end
    end
end

-- Register the Modules Events
AFKCamera:SetScript('OnEvent', HandleEvents);
AFKCamera:RegisterEvent('PLAYER_FLAGS_CHANGED');
AFKCamera:RegisterEvent('PLAYER_LEAVING_WORLD');
AFKCamera:RegisterEvent('PLAYER_DEAD');