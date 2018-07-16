--[[
    modules\frames\minimap.lua
    Slightly repositions and scales the Minimap frame.
    Adds Coords.
]]
local addonName, Loc = ...;

local MapFrame = CreateFrame('Frame', nil, UIParent);

-- Co-ordinates Frame
local CoordsFrame = CreateFrame('Frame', nil, Minimap);
CoordsFrame.text = CoordsFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
CoordsFrame.delay = 0.5;
CoordsFrame.elapsed = 0;

-- Set the position and scale etc
CoordsFrame:SetFrameStrata('LOW');
CoordsFrame:SetWidth(32);
CoordsFrame:SetHeight(32);
CoordsFrame:SetPoint('BOTTOM', 3, 0);
CoordsFrame.text:SetPoint('CENTER', 0, 0);
CoordsFrame.text:SetFont(ImpFont, 14, 'OUTLINE');

-- Ticks every 0.5 seconds, purely to update the Co-ordinates display.
local function CoordsFrame_Tick(self, elapsed)
	CoordsFrame.elapsed = CoordsFrame.elapsed + elapsed; -- Increment the tick timer
	if(CoordsFrame.elapsed >= CoordsFrame.delay) then -- Matched tick delay?
		if(FramesDB.showMinimapCoords) then -- Update the Co-ords frame
			-- 7.1 Restricted this so it only works in the outside world. Lame.
			local inInstance, _ = IsInInstance();
			if(inInstance ~= true) then
				if(Minimap:IsVisible()) then
					local x, y = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY();
					if(x ~= 0 and y ~= 0) then
						CoordsFrame.text:SetFormattedText('(%d:%d)', x * 100, y * 100);
					end
				end
			end
		end
		CoordsFrame.elapsed = 0; -- Reset the timer
	end
end
CoordsFrame:SetScript('OnUpdate', CoordsFrame_Tick); -- Begin the Core_Tick

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_ENTERING_WORLD') then
        -- Move and Scale the entire Minimap frame
        MinimapCluster:ClearAllPoints();
        MinimapCluster:SetScale(1.00);
        
        if (FramesDB.showPerformance) then
            MinimapCluster:SetPoint('TOPRIGHT', -15, -20);
        else
            MinimapCluster:SetPoint('TOPRIGHT', -15, -15);
        end

        local file, size, flags = PlayerFrameHealthBarTextLeft:GetFont();
        local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

        MinimapZoneText:SetFont(ImpFont, 13, flags);

        if (FramesDB.replaceZoom) then
            MinimapZoomIn:Hide();
            MinimapZoomOut:Hide();
            Minimap:EnableMouseWheel(true);
            Minimap:SetScript('OnMouseWheel', function(self, delta)
                if(delta > 0) then
                    Minimap_ZoomIn();
                else
                    Minimap_ZoomOut();
                end
            end);
        end
    end
end

-- Register the Modules Events
MapFrame:SetScript('OnEvent', HandleEvents);
MapFrame:RegisterEvent('PLAYER_ENTERING_WORLD');