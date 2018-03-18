--[[
    modules\maps\coords.lua
    Displays mouse Coords on the World Map
]]
local addonName, Loc = ...;

local MapCoordsFrame = CreateFrame('Frame', nil, WorldMapFrame.BorderFrame);

MapCoordsFrame:SetWidth(100);	
MapCoordsFrame:SetHeight(16);
MapCoordsFrame:SetPoint('TOPRIGHT', -150, -4);

MapCoordsFrame.text = MapCoordsFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
MapCoordsFrame.text:SetFont(ImpFont, 14, 'THINOUTLINE');
MapCoordsFrame.text:SetAllPoints();

local function UpdateCoords(self, elapsed)
    if (WorldMapFrame:IsVisible() and FramesDB.showCursorCoords) then
        WorldMapFrameTitleText:SetFont(ImpFont, 14, 'THINOUTLINE');
        local scale = WorldMapDetailFrame:GetEffectiveScale();
        local width = WorldMapDetailFrame:GetWidth();
        local height = WorldMapDetailFrame:GetHeight();
        local cenx, ceny = WorldMapDetailFrame:GetCenter();
        local x, y = GetCursorPosition();
        local vmapx = (x / scale - (cenx - (width/2))) / width;
        local vmapy = (ceny + (height/2) - y / scale) / height;

        local coords = string.format('(%d:%d)', (floor(vmapx * 1000 + 0.5)) / 10, (floor(vmapy * 1000 + 0.5)) / 10);

        if (vmapx >= 0  and vmapy >= 0 and vmapx <=1 and vmapy <=1) then
            MapCoordsFrame.text:SetFormattedText(coords);
        else
            MapCoordsFrame.text:SetText('(0:0)');
        end
    end
end

MapCoordsFrame:SetScript('OnUpdate', UpdateCoords)

MapCoordsFrame:Show();