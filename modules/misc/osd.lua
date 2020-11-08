--[[
    modules\misc\osd.lua
    On Screen Display used by other modules to display information
    in the center of the screen.
]]
local ImpUI_OSD = ImpUI:NewModule('ImpUI_OSD', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Variables
local osd;
local dragFrame;

--[[
    Entry point for the rest of the addon. Parameters are pretty
    self explanatory.
	
    @ return void
]]
function ImpUI_OSD:AddMessage(message, font, size, r, g, b, duration)
    -- Update the Font.
    osd.text:SetFont(LSM:Fetch('font', font), size, 'OUTLINE');

    -- Set the Colour
    osd.text:SetTextColor(r, g, b, 1.0);

    -- Set the Message.
    osd.text:SetText(message);

    -- Play the Animation
    if (osd.hidden) then
        osd.fadeInAnim:Play();
    end

    -- Cancel Fading if Needed
    if ( osd.fadeTimer ~= nil ) then
        osd.fadeTimer:Cancel();
    end

    -- Set Fade Timer
    osd.fadeTimer = C_Timer.NewTimer(duration, function()
        osd.fadeOutAnim:Play();
    end);
end

-- Called when unlocking the UI.
function ImpUI_OSD:Unlock()
    dragFrame:Show();

    osd:SetParent(dragFrame);

    -- Display a Test Message.
    self:AddMessage(L['Test String Output'], 'Improved Blizzard UI', 26, 1, 1, 0, 30.0);
end

-- Called when Locking the UI.
function ImpUI_OSD:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    -- Store Position
    ImpUI.db.profile.osdPosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    osd:SetParent(UIParent);

    dragFrame:Hide();
end

--[[
	Loads the position of the OSD from SavedVariables.
]]
function ImpUI_OSD:LoadPosition()
    dragFrame:ClearAllPoints();
    dragFrame:SetPoint(ImpUI.db.profile.osdPosition.point, ImpUI.db.profile.osdPosition.relativeTo, ImpUI.db.profile.osdPosition.relativePoint, ImpUI.db.profile.osdPosition.x, ImpUI.db.profile.osdPosition.y);
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_OSD:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_OSD:OnEnable()
    -- Build OSD and Animations
    osd = CreateFrame('Frame', 'ImpUI_OSD', UIParent);
    
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_OSD_DragFrame', 64, 64, L['On Screen Display']);
    osd:SetParent(dragFrame);

    ImpUI_OSD:LoadPosition();

    osd:SetParent(UIParent);

    osd.text = osd:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    osd:SetWidth(32);
    osd:SetHeight(32);
    osd:SetFrameStrata('BACKGROUND');
    osd:SetPoint('CENTER', dragFrame, 'CENTER', 0, 0);
    osd.text:SetPoint('CENTER', 0, 0);

    osd.text:SetFont(LSM:Fetch('font', 'Improved Blizzard UI'), 26, 'OUTLINE');

    osd.hidden = true;
    osd.fadeTimer = nil;

    -- Initialise the fadein / out anims
    osd.fadeInAnim = osd:CreateAnimationGroup();
    osd.fadeIn = osd.fadeInAnim:CreateAnimation('Alpha');
    osd.fadeIn:SetDuration(0.20);
    osd.fadeIn:SetFromAlpha(0);
    osd.fadeIn:SetToAlpha(1);
    osd.fadeIn:SetOrder(1);

    osd.fadeInAnim:SetScript('OnFinished', function() 
        osd:SetAlpha(1);
        osd.hidden = false;
    end);

    osd.fadeOutAnim = osd:CreateAnimationGroup();
    osd.fadeOut = osd.fadeOutAnim:CreateAnimation('Alpha');
    osd.fadeOut:SetDuration(0.20);
    osd.fadeOut:SetFromAlpha(1);
    osd.fadeOut:SetToAlpha(0);
    osd.fadeOut:SetOrder(1);

    osd.fadeOutAnim:SetScript('OnFinished', function() 
        osd:SetAlpha(0);
        osd.hidden = true;
        osd.text:SetText('');
    end);
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_OSD:OnDisable()
end