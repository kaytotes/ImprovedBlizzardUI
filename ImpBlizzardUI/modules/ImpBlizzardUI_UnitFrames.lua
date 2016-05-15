--[[
    ImpBlizzardUI/modules/ImpBlizzardUI_UnitFrames
    Handles and modifies the Blizzard unit frames
    Current Features:
    Todo: All rescaling
]]
local _, ImpBlizz = ...;

local UnitFrames = CreateFrame("Frame", nil, UIParent);

-- Helper function for moving a Blizzard frame that has a SetMoveable flag
local function ModifyFrame(frame, anchor, parent, posX, posY, scale)
    frame:SetMovable(true);
    frame:ClearAllPoints();
    if(parent == nil) then frame:SetPoint(anchor, posX, posY) else frame:SetPoint(anchor, parent, posX, posY) end
    if(scale ~= nil) then frame:SetScale(scale) end
    frame:SetUserPlaced(true);
    frame:SetMovable(false);
end

-- Helper function for moving a Blizzard frame that does NOT have a SetMoveable flag
local function ModifyBasicFrame(frame, anchor, parent, posX, posY, scale)
    frame:ClearAllPoints();
    if(parent == nil) then frame:SetPoint(anchor, posX, posY) else frame:SetPoint(anchor, parent, posX, posY) end
    if(scale ~= nil) then frame:SetScale(scale) end
end

-- Does the bulk of the tweaking to the unit frames
local function AdjustUnitFrames()
    if(InCombatLockdown() == false) then
        ModifyFrame(PlayerFrame, "CENTER", nil, -265, -150, 1.45); -- Player Frame
        ModifyFrame(TargetFrame, "CENTER", nil, 265, -150, 1.45); -- Target Frame
    end
end

local function HandleEvents(self, event, ...)
    if( event == "PLAYER_ENTERING_WORLD" ) then
        AdjustUnitFrames();
    end
end

-- Sets up Event Handlers etc
local function Init()
    UnitFrames:SetScript("OnEvent", HandleEvents);
    LoadAddOn("Blizzard_ArenaUI");

    UnitFrames:RegisterEvent("PLAYER_ENTERING_WORLD");
    UnitFrames:RegisterEvent("ADDON_LOADED");
    UnitFrames:RegisterEvent("UNIT_EXITED_VEHICLE");
    UnitFrames:RegisterEvent("UNIT_ENTERED_VEHICLE");
    UnitFrames:RegisterEvent("PLAYER_TARGET_CHANGED");
    UnitFrames:RegisterEvent("UNIT_FACTION");
    UnitFrames:RegisterEvent("GROUP_ROSTER_UPDATE");
    UnitFrames:RegisterEvent("PLAYER_FOCUS_CHANGED");
end

-- End of file, call Init
Init();
