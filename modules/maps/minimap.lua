--[[
    modules\frames\minimap.lua
    Slightly repositions and scales the Minimap frame.
    Adds Coords.
]]
ImpUI_MiniMap = ImpUI:NewModule('ImpUI_MiniMap', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local coords;

-- Local Functions
local Minimap_ZoomIn = Minimap_ZoomIn;
local Minimap_ZoomOut = Minimap_ZoomOut;
local IsInInstance = IsInInstance;

--[[
    On scrolling the mouse wheel zooms the minimap in or out.
    Replacement for the + and - buttons.
	
    @ return void
]]
function ImpUI_MiniMap:MinimapOnMouseWheel(self, delta)
    if(delta > 0) then
        Minimap_ZoomIn();
    else
        Minimap_ZoomOut();
    end
end

--[[
	Sets the font styling of minimap clock.
	
    @ return void
]]
function ImpUI_MiniMap:StyleClock()
    local font = ImpUI.db.profile.minimapClockFont;
    local size = ImpUI.db.profile.minimapClockSize;

    TimeManagerClockTicker:SetFont(LSM:Fetch('font', font), size, outline);
end

--[[
    Sets the position of the minimap as well as removing zoom buttons.
    Sets the style of the zone text too.
	
    @ return void
]]
function ImpUI_MiniMap:StyleMap()
    MinimapCluster:ClearAllPoints();
    
    if (ImpUI.db.profile.performanceFrame == true) then
        MinimapCluster:SetPoint('TOPRIGHT', -15, -32);
    else
        MinimapCluster:SetPoint('TOPRIGHT', -15, -16);
    end

    -- Replace Zoom Buttons with Mousewheel.
    MinimapZoomIn:Hide();
    MinimapZoomOut:Hide();
    Minimap:EnableMouseWheel(true);

    Minimap:SetScript('OnMouseWheel', function(self, delta)
        ImpUI_MiniMap:MinimapOnMouseWheel(self, delta);
    end);

    -- Check styling config here as rest is subjective
    local font = ImpUI.db.profile.minimapZoneTextFont;
    local size = ImpUI.db.profile.minimapZoneTextSize;

    MinimapZoneText:SetFont(LSM:Fetch('font', font), size, 'OUTLINE');
end

--[[
	Sets the font styling of the co-ordinates.
	
    @ return void
]]
function ImpUI_MiniMap:StyleCoords()
    local font = ImpUI.db.profile.minimapCoordsFont;
    local colour = ImpUI.db.profile.minimapCoordsColour;
    local size = ImpUI.db.profile.minimapCoordsSize;

    coords.text:SetFont(LSM:Fetch('font', font), size, 'OUTLINE');
    coords.text:SetTextColor(colour.r, colour.g, colour.b, colour.a);
end

--[[
	Fires every 0.5 seconds and updates the co-ordinates for the player.
	
    @ return void
]]
function ImpUI_MiniMap:UpdateCoords()
    local inInstance, instanceType = IsInInstance();

    -- If configuration disabled or we're in a dungeon then just set to blank.
    if (ImpUI.db.profile.showCoords == false or inInstance == true) then
        coords.text:SetText('');
        return;
    end

    local map = C_Map.GetBestMapForUnit('player');

    if(map) then
        if(Minimap:IsVisible()) then
            local position = C_Map.GetPlayerMapPosition(map, 'player');

            if (position == nil) then 
                coords.text:SetText('');
                return
            end

            local x, y = position:GetXY();
            
            if(x ~= 0 and y ~= 0) then
                coords.text:SetFormattedText('(%d:%d)', x * 100, y * 100);
            else
                coords.text:SetText('');
            end
        end
    else
        if(Minimap:IsVisible()) then
            coords.text:SetText('');
        end
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_MiniMap:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_MiniMap:OnEnable()
    -- Create Coords Frame
    coords = CreateFrame('Frame', nil, Minimap);
    coords.text = coords:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');

    -- Set the position and scale etc
    coords:SetFrameStrata('LOW');
    coords:SetWidth(32);
    coords:SetHeight(32);
    coords:SetPoint('BOTTOM', 3, 0);
    coords.text:SetPoint('CENTER', 0, 0);
    

    ImpUI_MiniMap:StyleMap();
    ImpUI_MiniMap:StyleCoords();
    ImpUI_MiniMap:StyleClock();

    self.coordsTimer = self:ScheduleRepeatingTimer('UpdateCoords', 0.5);
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_MiniMap:OnDisable()
end