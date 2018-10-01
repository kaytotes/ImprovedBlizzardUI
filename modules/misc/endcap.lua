--[[
    modules\misc\endcap.lua
    Show/Hides the Action Bar end caps & provides additonal framework for end caps.
]]
local addonName, Loc = ...;

local BarArtFrame = CreateFrame('Frame', nil, UIParent);

-- Hide the Action Bar End's according to configuration.
local function HideBarArt()
        MainMenuBarArtFrame.LeftEndCap:Hide();
        MainMenuBarArtFrame.RightEndCap:Hide();
    end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
	if (event == 'ADDON_LOADED' and ... == 'ImprovedBlizzardUIPlus') then
		if (... == 'ImprovedBlizzardUIPlus') then
			if (PrimaryDB.HideActionBarArt) then
				HideBarArt();
			end
		end
	end

	if (event == 'PLAYER_LOGIN') then
        if (PrimaryDB.HideActionBarArt) then
            HideBarArt();
        end
	end
end

-- Register the Modules Events
BarArtFrame:SetScript('OnEvent', HandleEvents);
BarArtFrame:RegisterEvent('ADDON_LOADED');
BarArtFrame:RegisterEvent('PLAYER_ENTERING_WORLD');
BarArtFrame:RegisterEvent('PLAYER_LOGIN');