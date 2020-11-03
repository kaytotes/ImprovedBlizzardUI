--[[
    modules\misc\afkmode.lua
    After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.
]]
local ImpUI_AFK = ImpUI:NewModule('ImpUI_AFK', 'AceEvent-3.0');

-- Create the AFK Frame (that everything is parented too).
local AFKFrame = CreateFrame('Frame', nil, WorldFrame);

-- Local Functions
local CreateFrame = CreateFrame;
local InCombatLockdown = InCombatLockdown;
local MoveViewRightStart = MoveViewRightStart;
local MoveViewRightStop = MoveViewRightStop;
local UnitIsAFK = UnitIsAFK;
local UnitIsDead = UnitIsDead;

--[[
	Handles the creating of the various frames needed.
	
    @ return void
]]
function ImpUI_AFK:BuildFrames()
	AFKFrame:SetAllPoints();
    AFKFrame:SetAlpha(0);
    AFKFrame.width, AFKFrame.height = AFKFrame:GetSize();
    AFKFrame.hidden = true;

    -- Set Up the Player Model
    AFKFrame.playerModel = CreateFrame('PlayerModel', nil, AFKFrame);
    AFKFrame.playerModel:SetSize(AFKFrame.height * 0.8, AFKFrame.height * 1.3);
    AFKFrame.playerModel:SetPoint('BOTTOMRIGHT', AFKFrame.height * 0.1, -AFKFrame.height * 0.4);

    -- Pet model for Hunters, Warlocks etc
    AFKFrame.petModel = CreateFrame('playerModel', nil, AFKFrame);
    AFKFrame.petModel:SetSize(AFKFrame.height * 0.7, AFKFrame.height);
    AFKFrame.petModel:SetPoint('BOTTOMLEFT', AFKFrame.height * 0.05, -AFKFrame.height * 0.3);

    -- Initialise the fadein / out anims
    AFKFrame.fadeInAnim = AFKFrame:CreateAnimationGroup();
    AFKFrame.fadeIn = AFKFrame.fadeInAnim:CreateAnimation('Alpha');
    AFKFrame.fadeIn:SetDuration(0.5);
    AFKFrame.fadeIn:SetFromAlpha(0);
    AFKFrame.fadeIn:SetToAlpha(1);
    AFKFrame.fadeIn:SetOrder(1);
    AFKFrame.fadeInAnim:SetScript('OnFinished', function() AFKFrame:SetAlpha(1) end );

    AFKFrame.fadeOutAnim = AFKFrame:CreateAnimationGroup();
    AFKFrame.fadeOut = AFKFrame.fadeOutAnim:CreateAnimation('Alpha');
    AFKFrame.fadeOut:SetDuration(0.5);
    AFKFrame.fadeOut:SetFromAlpha(1);
    AFKFrame.fadeOut:SetToAlpha(0);
    AFKFrame.fadeOut:SetOrder(1);
    AFKFrame.fadeOutAnim:SetScript('OnFinished', function() AFKFrame:SetAlpha(0) end );
end

--[[
	Handles turning on and off the AFK Mode.
	
    @ param boolean $spin Whether the spinning should be turned off
    @ return void
]]
function ImpUI_AFK:ToggleSpin(spin)
	-- If disabled in Config do nothing.
	if (ImpUI.db.profile.afkMode == false) then return; end

    -- If the Player is in combat then just do nothing
    if (InCombatLockdown()) then return; end

    if (spin) then
        -- Refresh and Set the Player Model anims
        AFKFrame.playerModel:SetUnit('player');
        AFKFrame.playerModel:SetAnimation(0);
        AFKFrame.playerModel:SetRotation(math.rad(-15));
        AFKFrame.playerModel:SetCamDistanceScale(1.2);

        -- Refresh and Set the Pet Model anims
        AFKFrame.petModel:SetUnit('pet');
        AFKFrame.petModel:SetAnimation(0);
        AFKFrame.petModel:SetRotation(math.rad(45));
        AFKFrame.petModel:SetCamDistanceScale(1.7);

        -- Hide the PVE Frame if it is shown
        if(PVEFrame and PVEFrame:IsShown()) then
            AFKFrame.PvEIsOpen = true; -- Store that it was open so that we can automatically reopen it after
            PVEFrame_ToggleFrame();
        else
            AFKFrame.PvEIsOpen = false;
        end

        -- Hide the UI and begin the camera spinning
        UIParent:Hide();
        AFKFrame.fadeInAnim:Play();
        AFKFrame.hidden = false;
        MoveViewRightStart(0.15);
    else
        if(AFKFrame.hidden == false) then
            MoveViewRightStop();
            UIParent:Show();
            AFKFrame.fadeOutAnim:Play();

            -- Reopen PVE Frame if it was open
            if(AFKFrame.PvEIsOpen) then
                PVEFrame_ToggleFrame();
            end

            AFKFrame.hidden = true;
        end
    end
end

--[[
	Disables or Enables the AFK Frame based on AFK Status.
	
	@ param string $event The event that was fired
	@ param [] $... The event parameters.
    @ return void
]]
function ImpUI_AFK:PLAYER_FLAGS_CHANGED(event, ...)
	if (... == 'player') then
		if (UnitIsAFK('player') and not UnitIsDead('player')) then
			ImpUI_AFK:ToggleSpin(true);
		else
			ImpUI_AFK:ToggleSpin(false);
		end
	end
end

--[[
	Disables the AFK Frame when players are teleporting.
	
    @ return void
]]
function ImpUI_AFK:PLAYER_LEAVING_WORLD()
	ImpUI_AFK:ToggleSpin(false);
end

--[[
	If the Player dies and is AFK disable the AFK Frame.
	
    @ return void
]]
function ImpUI_AFK:PLAYER_DEAD()
	if (UnitIsAFK('player')) then
		ImpUI_AFK:ToggleSpin(false);
	end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_AFK:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_AFK:OnEnable()
	ImpUI_AFK:BuildFrames();
	
	-- Register the Modules Events
	self:RegisterEvent('PLAYER_FLAGS_CHANGED');
	self:RegisterEvent('PLAYER_LEAVING_WORLD');
	self:RegisterEvent('PLAYER_DEAD');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_AFK:OnDisable()
end