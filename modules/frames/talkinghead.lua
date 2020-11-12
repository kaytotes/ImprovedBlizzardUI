--[[
    modules\frames\talkinghead.lua
    Simply adjusts the position of the Talking Head Frame.
]]
ImpUI_TalkingHead = ImpUI:NewModule('ImpUI_TalkingHead', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local dragFrame;

function ImpUI_TalkingHead:Move()
    if (InCombatLockdown()) then return end
    print('Moving');

    TalkingHeadFrame.ignoreFramePositionManager = true;
    TalkingHeadFrame:ClearAllPoints();
    TalkingHeadFrame:SetPoint('CENTER', dragFrame, 'CENTER', 0, 0);
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_TalkingHead:Unlock()
    dragFrame:Show();
end

--[[
	Called when locking the UI.
]]
function ImpUI_TalkingHead:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    ImpUI.db.profile.talkingHeadPosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the Player Frame from SavedVariables.
]]
function ImpUI_TalkingHead:LoadPosition()
    local pos = ImpUI.db.profile.talkingHeadPosition;
    
    -- Set Drag Frame Position
    dragFrame:ClearAllPoints();
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);
end


--[[
	Fires when the Player hits a loading screen / transition.
	
    @ return void
]]
function ImpUI_TalkingHead:PLAYER_ENTERING_WORLD()
    ImpUI_TalkingHead:Move();
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_TalkingHead:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_TalkingHead:OnEnable()
    if (Helpers.IsClassic()) then return end

    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_TalkingHead_DragFrame', 300, 100, L['Talking Head Frame']);

    ImpUI_TalkingHead:LoadPosition();
    ImpUI_TalkingHead:Move();

    self:RegisterEvent('PLAYER_ENTERING_WORLD');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_TalkingHead:OnDisable()
end