--[[
    modules\frames\castbar.lua
    
]]
local addonName, Loc = ...;

local CastingFrame = CreateFrame('Frame', nil, UIParent);

CastingBarFrame:HookScript('OnUpdate', function(self, elapsed)
    if not self.timer then return end

    if (self.updateDelay and self.updateDelay < elapsed) then
        if (self.casting) then
            self.timer:SetText(format("%.1f", max(self.maxValue - self.value, 0)))
        elseif (self.channeling) then
            self.timer:SetText(format("%.1f", max(self.value, 0)))
        else
            self.timer:SetText("")
        end
        self.updateDelay = 0.1
    else
        self.updateDelay = self.updateDelay - elapsed
    end
end);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'ADDON_LOADED') then -- Add Config
        if (ActionBarDB.barTimer) then
            CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil);
            CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE");
            CastingBarFrame.timer:SetPoint("TOP", CastingBarFrame, "BOTTOM", 0, 35);
            CastingBarFrame.updateDelay = 0.1;
        end

        CastingBarFrame:SetMovable(true);
        CastingBarFrame:ClearAllPoints();
        CastingBarFrame:SetPoint('CENTER', 0, -175);
        CastingBarFrame:SetScale(ActionBarDB.castingScale);
        CastingBarFrame:SetUserPlaced(true);
        CastingBarFrame:SetMovable(false);
    end    
end

-- (CastingBarFrame, "CENTER", nil, 0, -175, 1.1);

-- Register the Modules Events
CastingFrame:SetScript('OnEvent', HandleEvents);
CastingFrame:RegisterEvent('ADDON_LOADED');