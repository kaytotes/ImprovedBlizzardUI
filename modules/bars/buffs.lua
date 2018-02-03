--[[
    modules\bars\buffs.lua
]]
local addonName, Loc = ...;

local Buffs = CreateFrame('Frame', nil, UIParent);

Buffs.buffPoint = BuffFrame.SetPoint;
Buffs.buffScale = BuffFrame.SetScale;

local function MoveBuffs()
    BuffFrame:ClearAllPoints();
    Buffs.buffPoint(BuffFrame, 'TOPLEFT', MinimapCluster, -55, -2);
    Buffs.buffScale(BuffFrame, BarsDB.buffScale);
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_LOGIN') then
        MoveBuffs();
    end    
end

-- Register the Modules Events
Buffs:SetScript('OnEvent', HandleEvents);
Buffs:RegisterEvent('PLAYER_LOGIN');

hooksecurefunc( BuffFrame, 'SetPoint', function(frame) MoveBuffs() end);
hooksecurefunc( BuffFrame, 'SetScale', function(frame) MoveBuffs() end)