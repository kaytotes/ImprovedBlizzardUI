--[[
    modules\bars\extraactionbutton.lua
    Repositions the Extra Action Button
]]
local addonName, Loc = ...;

local ExtraButtonFrame = CreateFrame('Frame', nil, UIParent);

ExtraActionButton1:HookScript('OnShow', function() 
    if(MultiBarBottomRight:IsShown()) then
        ExtraActionButton1:SetPoint('CENTER', 0, 100);
    end
end)