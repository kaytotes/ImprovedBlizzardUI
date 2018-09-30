--[[
	modules\frames\performance.lua
	An FPS and Latency monitor above the minimap
]]
local addonName, Loc = ...;

local PerformanceFrame = CreateFrame('Frame', nil, MinimapCluster);

PerformanceFrame.text = PerformanceFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
PerformanceFrame.elapsed = 0;
PerformanceFrame.delay = 2;
PerformanceFrame:SetFrameStrata('BACKGROUND');
PerformanceFrame:SetWidth(32);
PerformanceFrame:SetHeight(32);
PerformanceFrame:SetPoint('TOP', 10, 25);

-- Text positioning
PerformanceFrame.text:SetPoint('CENTER', 0, 0);
PerformanceFrame.text:SetFont(ChatFont, 13, 'OUTLINE');

--[[
    Refresh and update frame
    @ return void
]]
local function PerformanceFrame_Tick(self, elapsed)
	PerformanceFrame.elapsed = PerformanceFrame.elapsed + elapsed; -- Increment Timer
	if(PerformanceFrame.elapsed >= PerformanceFrame.delay) then
		local _, _, latencyHome, latencyWorld = GetNetStats(); -- Get current Latency

		-- Colour Latency Strings
		if( latencyHome <= 75 )then
			latencyHome = format('|cff00CC00%s|r', latencyHome );
		elseif( latencyHome > 75 and latencyHome <= 250 )then
			latencyHome = format('|cffFFFF00%s|r', latencyHome );
		elseif( latencyHome > 250 )then
			latencyHome = format('|cffFF0000%s|r', latencyHome );
		end

		if( latencyWorld <= 75 )then
			latencyWorld = format('|cff00CC00%s|r', latencyWorld );
		elseif( latencyWorld > 75 and latencyWorld <= 250 )then
			latencyWorld = format('|cffFFFF00%s|r', latencyWorld );
		elseif( latencyWorld > 250 )then
			latencyWorld = format('|cffFF0000%s|r', latencyWorld );
		end

		local frameRate = floor(GetFramerate()); -- Get the current frame rate

		-- Colour Frame Rate
		if(frameRate >= 60) then
			frameRate = format('|cff00CC00%s|r', frameRate );
		elseif(frameRate >= 20 and frameRate <= 59) then
			frameRate = format('|cffFFFF00%s|r', frameRate );
		elseif(frameRate < 20) then
			frameRate = format('|cffFF0000%s|r', frameRate );
		end

		-- Write Text
        PerformanceFrame.text:SetText(' ');
        
		if(FramesDB.showPerformance) then
			PerformanceFrame.text:SetText(latencyHome..' / '..latencyWorld..' ms - '..frameRate..' fps');
		end
		PerformanceFrame.elapsed = 0;
	end
end
PerformanceFrame:SetScript('OnUpdate', PerformanceFrame_Tick);