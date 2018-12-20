--[[
    modules\frames\player.lua
    Styles, Scales and Repositions the Player Unit Frame.
    Disables Player Portrait Spam
]]
local ImpUI_PlayerFrame = ImpUI:NewModule('ImpUI_PlayerFrame', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local dragFrame;

-- Local Functions

--[[
	Fires when the Player Logs In.
	
    @ return void
]]
function ImpUI_PlayerFrame:PLAYER_LOGIN()
    ImpUI_PlayerFrame:LoadPosition();
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

    print(point, relativeTo, relativePoint, xOfs, yOfs);

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
    print('ImpUI_PlayerFrame');
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_PlayerFrame:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_PlayerFrame_DragFrame', 205, 90, L['Player Frame']);

    ImpUI_PlayerFrame:LoadPosition();

    -- Register Events
    self:RegisterEvent('PLAYER_LOGIN');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_PlayerFrame:OnDisable()
end