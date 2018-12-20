--[[
    modules\misc\grid.lua
    Displays a grid for helping display units.
]]
local ImpUI_Grid = ImpUI:NewModule('ImpUI_Grid');

-- Local Functions
local GetScreenWidth = GetScreenWidth;
local GetScreenHeight = GetScreenHeight;

-- Local Variables
local grid;

-- Toggles the display of a grid to aid in placing UI elements.
function ImpUI_Grid:ToggleGrid()
    -- Grid already exists. Kill it.
    if (grid) then
        grid:Hide();
        grid = nil;
        return;
    end

    -- Otherwise create it.
    grid = CreateFrame('Frame', nil, UIParent);
    grid:SetAllPoints(UIParent);

    local width = GetScreenWidth() / 128;
    local height = GetScreenHeight() / 72;

    -- Horizontal First
    for i = 0, 128 do
        local tex = grid:CreateTexture(nil, 'BACKGROUND');
        
        -- Half way point, colour it red.
        if (i == 64) then
            tex:SetColorTexture(1, 0, 0, 0.75);
        else
            if (i % 2 == 0) then
                tex:SetColorTexture(1, 1, 1, 0.5);
            else
                tex:SetColorTexture(1, 1, 1, 0.25);
            end
        end

        tex:SetPoint('TOPLEFT', grid, 'TOPLEFT', i * width - 1, 0);
        tex:SetPoint('BOTTOMRIGHT', grid, 'BOTTOMLEFT', i * width + 1, 0);
    end

    -- Vertical
    for i = 0, 72 do
        local tex = grid:CreateTexture(nil, 'BACKGROUND');

        -- Half way point, colour it red.
        if (i == 36) then
            tex:SetColorTexture(1, 0, 0, 0.75);
        else
            if (i % 2 == 0) then
                tex:SetColorTexture(1, 1, 1, 0.5);
            else
                tex:SetColorTexture(1, 1, 1, 0.25);
            end
        end

        tex:SetPoint('TOPLEFT', grid, 'TOPLEFT', 0, -i * height + 1)
        tex:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -i * height - 1)
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Grid:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Grid:OnEnable()
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Grid:OnDisable()
end