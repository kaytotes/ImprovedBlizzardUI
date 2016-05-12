--[[
    ImpBlizzardUI/core.lua
    Handles the misc functions of the addon that don't quite fit into any other category.
    Current Features: Development Grid Overlay
    Todo: AFK Camera, Performance Statistics, Player Co-Ordinates,
]]

local _, ImpBlizz = ...;

local AddonVersion = GetAddOnMetadata("ImpBlizzardUI", "Version");

local Core = CreateFrame("Frame", "ImpCore", UIParent); -- Create the Core frame, doesn't ever get drawn just logic

-- Get Font references
local DamageFont = "Interface\\Addons\\ImpBlizzardUI\\media\\damage.ttf";
local MenuFont = "Interface\\Addons\\ImpBlizzardUI\\media\\impfont.ttf";
local CoreFont = "Fonts\\FRIZQT__.TTF";

-- Just draws an overlay grid to aid in placing stuff
local function DrawDevGrid()
	-- Grid Already Drawn?
	if( grid ) then
		grid:Hide();
		grid = nil; -- Kill Grid
	else
		grid = CreateFrame( 'Frame', nil, UIParent );
		grid:SetAllPoints( UIParent );

		local cellSizeX = 32;
		local cellSizeY = 18;

		local screenWidth = GetScreenWidth() / cellSizeX;
		local screenHeight = GetScreenHeight() / cellSizeY;

		for columns = 0, cellSizeX do
			local line = grid:CreateTexture(nil, 'BACKGROUND');
			if( columns == cellSizeX / 2 ) then -- Half Way Line
				line:SetTexture(1, 0, 0, 0.5 );
			else
				line:SetTexture(0, 0, 0, 0.5 );
			end
			line:SetPoint('TOPLEFT', grid, 'TOPLEFT', columns * screenWidth - 1, 0);
			line:SetPoint('BOTTOMRIGHT', grid, 'BOTTOMLEFT', columns * screenWidth + 1, 0);
		end
		for rows = 0, cellSizeY do
			local line = grid:CreateTexture(nil, 'BACKGROUND');
			if( rows == cellSizeY / 2 ) then -- Half Way Line
				line:SetTexture(1, 0, 0, 0.5 );
			else
				line:SetTexture(0, 0, 0, 0.5 );
			end
			line:SetPoint('TOPLEFT', grid, 'TOPLEFT', 0, -rows * screenHeight + 1);
			line:SetPoint('BOTTOMRIGHT', grid, 'TOPRIGHT', 0, -rows * screenHeight - 1)
		end
	end
end

local function HandleEvents(self, event, unit)
	if(event == "ADDON_LOADED") then --Doesn't check that it's this addon, don't want any other addon overriding it. Will make it a config option soon.
		DAMAGE_TEXT_FONT = DamageFont;
	end
end

-- Handle any of the core /impblizz commands issued by the player
local function HandleCommands(input)
    local command = string.lower(input);

    if(command == "grid") then
        DrawGrid();
    end
end

-- Initialises the Core module and its relevant submodules
local function Init()
    SLASH_IMPBLIZZ1 = "/impblizz";
    SlashCmdList["IMPBLIZZ"] = HandleCommands; -- Set up the slash commands handler

    Core:SetScript("OnEvent", HandleEvents); -- Set the Event Handler

    -- Register the Core Events
    Core:RegisterEvent("ADDON_LOADED");

    -- Init Finished
    print("|cffffff00Improved Blizzard UI " .. AddonVersion .. " Initialised");
end

-- End of File, Call Init
Init();
