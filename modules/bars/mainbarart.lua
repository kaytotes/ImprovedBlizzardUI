--[[
    modules\bars\mainbarart.lua
    Provides framework for hiding & changing various Main Bar Features.
]]
local addonName, Loc = ...;

local MainBarArtFrame = CreateFrame('Frame', nil, UIParent);

-- Hide the Main Bar End Caps (Gryphons, e.t.c) according to configuration.
local function EndCaps()
        MainMenuBarArtFrame.LeftEndCap:Hide();
        MainMenuBarArtFrame.RightEndCap:Hide(); end
    
-- Hide the Main Bar End Caps (Gryphons, e.t.c) according to configuration.
local function Background()
        MainMenuBarArtFrameBackground:Hide() end
    
-- Hide the Main Bar End Caps (Gryphons, e.t.c) according to configuration.
local function Arrows()
        ActionBarUpButton:Hide()
        ActionBarDownButton:Hide()
        MainMenuBarArtFrame.PageNumber:Hide() end

-- Hide the Stance Bar (Rogues Stealh Button e.t.c) according to configuration.
local function StanceFrame()
        StanceBarFrame:SetScript("OnUpdate", function(self) self:Hide() end)
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
		    if (BarsDB.hideEndCaps) then
                EndCaps(); end

            if (BarsDB.hideMainBarBackground) then
				Background(); end
            
            if (BarsDB.hideMainBarArrows) then
                Arrows(); end
                
            if (BarsDB.hideStanceFrame) then
				StanceFrame();
			end
		end
	end

	if (event == 'PLAYER_LOGIN') then
        if (BarsDB.hideEndCaps) then
            EndCaps(); end

        if (BarsDB.hideMainBarBackground) then
				Background(); end

        if (BarsDB.hideMainBarArrows) then
                Arrows(); end

        if (BarsDB.hideStanceFrame) then
			StanceFrame();
		end
	end
end

-- Register the Modules Events
MainBarArtFrame:SetScript('OnEvent', HandleEvents);
MainBarArtFrame:RegisterEvent('ADDON_LOADED');
MainBarArtFrame:RegisterEvent('PLAYER_ENTERING_WORLD'); -- is this needed?
MainBarArtFrame:RegisterEvent('PLAYER_LOGIN');