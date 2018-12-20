--[[
    modules\frames\target.lua
    Styles, Scales and Repositions the Target Unit Frame.
]]
local ImpUI_TargetFrame = ImpUI:NewModule('ImpUI_TargetFrame', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local dragFrame;

-- Local Functions

--[[
	Fires when the Player Logs In.
	
    @ return void
]]
function ImpUI_TargetFrame:PLAYER_LOGIN()
    ImpUI_TargetFrame:LoadPosition();
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_TargetFrame:Unlock()
    dragFrame:Show();
end

--[[
	Called when locking the UI.
]]
function ImpUI_TargetFrame:Lock()

    ImpUI.db.char.targetFramePosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the OSD from SavedVariables.
]]
function ImpUI_TargetFrame:LoadPosition()
    local pos = ImpUI.db.char.targetFramePosition;
    local scale = ImpUI.db.char.targetFrameScale;
    
    -- Set Drag Frame Position
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);

    -- Parent PlayerFrame to the Drag Frame.
    TargetFrame:SetMovable(true);
    TargetFrame:ClearAllPoints();
    TargetFrame:SetPoint('CENTER', dragFrame, 'CENTER', 15, -5);
    TargetFrame:SetScale(scale);
    TargetFrame:SetUserPlaced(true);
    TargetFrame:SetMovable(false);
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_TargetFrame:OnInitialize()
    print('ImpUI_TargetFrame');
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_TargetFrame:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_TargetFrame_DragFrame', 205, 90, L['Target Frame']);

    ImpUI_TargetFrame:LoadPosition();

    -- Register Events
    self:RegisterEvent('PLAYER_LOGIN');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_TargetFrame:OnDisable()
end