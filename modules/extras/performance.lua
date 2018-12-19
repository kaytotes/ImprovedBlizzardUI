--[[
	modules\extras\performance.lua
	An FPS and Latency monitor above the minimap
]]
local ImpUI_Performance = ImpUI:NewModule('ImpUI_Performance', 'AceEvent-3.0', 'AceTimer-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions

-- Local Variables
local performance;

function ImpUI_Performance:Tick()
    -- CHECK CONFIG TODO

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
    performance.text:SetText(' ');
    
    if(true) then
        performance.text:SetText(latencyHome..' / '..latencyWorld..' ms - '..frameRate..' fps');
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Performance:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Performance:OnEnable()
    performance = CreateFrame('Frame', nil, MinimapCluster);

    performance.text = performance:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
    performance.elapsed = 0;
    performance.delay = 2;
    performance:SetFrameStrata('BACKGROUND');
    performance:SetWidth(32);
    performance:SetHeight(32);
    performance:SetPoint('TOP', 10, 25);

    -- Text positioning
    performance.text:SetPoint('CENTER', 0, 0);

    font = LSM:Fetch('font', 'Improved Blizzard UI');

    performance.text:SetFont(font, 14, 'THINOUTLINE');

    self.perfTimer = self:ScheduleRepeatingTimer('Tick', 1);
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Performance:OnDisable()
end