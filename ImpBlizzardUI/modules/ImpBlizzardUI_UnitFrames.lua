--[[
    ImpBlizzardUI/modules/ImpBlizzardUI_UnitFrames
    Handles and modifies the Blizzard unit frames
    Current Features: Player Frame, Target Frame, Focus Frame, Party Frames, Boss Frames, Arena Frames
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
        ModifyFrame(PlayerFrame, "CENTER", nil, -265, -150, 1.40); -- Player Frame
        ModifyFrame(TargetFrame, "CENTER", nil, 265, -150, 1.40); -- Target Frame
        TargetFrame.buffsOnTop = true;
        ModifyFrame(FocusFrame, "TOPLEFT", nil, 300, -200, 1.25); -- Focus Frame

        -- Party Frames
        ModifyFrame(PartyMemberFrame1, "LEFT", nil, 100, 125, 1.6); -- Move the first one (Others are children)
        for i = 2, 4 do _G["PartyMemberFrame"..i]:SetScale(1.6); end -- Resize the other children

        -- Boss Frames
        for i = 1, 5 do -- Scale Them
            _G["Boss"..i.."TargetFrame"]:SetParent(UIParent);
            _G["Boss"..i.."TargetFrame"]:SetScale(0.95);
            _G["Boss"..i.."TargetFrame"]:SetFrameStrata("BACKGROUND");
        end
        for i = 2, 5 do -- Adjust Positions
            _G["Boss"..i.."TargetFrame"]:SetPoint("TOPLEFT", _G["Boss"..(i-1).."TargetFrame"], "BOTTOMLEFT", 0, 15);
        end

        -- Arena Frames
        for i=1, 5 do
            _G["ArenaPrepFrame"..i]:SetScale(1.75);
        end
        ArenaEnemyFrames:SetScale(1.75);
    end
end

local function HandleEvents(self, event, ...)
    if(event == "PLAYER_ENTERING_WORLD") then
        AdjustUnitFrames();
    end

    if(event == "UNIT_EXITED_VEHICLE" or event == "UNIT_ENTERED_VEHICLE") then
        if(UnitControllingVehicle("player") or UnitHasVehiclePlayerFrameUI("player")) then
            SetUnitFrames();
        end
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
