--[[
    modules\frames\party.lua
]]
local addonName, Loc = ...;

local PartyFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'PLAYER_ENTERING_WORLD') then
        local offset = 60;

        local file, size, flags = PlayerFrameHealthBarTextLeft:GetFont();
        local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

        for i = 1, 4 do
            Imp.ModifyFrame(_G["PartyMemberFrame"..i], "TOPLEFT", PlayerFrame, -115, offset * i, FramesDB.primaryScale + 0.2);
            
            if (FramesDB.stylePrimaryFrames) then
                _G["PartyMemberFrame"..i.."Name"]:SetTextColor(r, g, b, a);
                _G["PartyMemberFrame"..i.."Name"]:SetFont(ImpFont, 10, flags);
                
                _G["PartyMemberFrame"..i.."HealthBarText"]:SetFont(ImpFont, 8, flags);
                _G["PartyMemberFrame"..i.."HealthBarTextLeft"]:SetFont(ImpFont, 8, flags);
                _G["PartyMemberFrame"..i.."HealthBarTextRight"]:SetFont(ImpFont, 8, flags);

                _G["PartyMemberFrame"..i.."ManaBarText"]:SetFont(ImpFont, 8, flags);
                _G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetFont(ImpFont, 8, flags);
                _G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetFont(ImpFont, 8, flags);
            end
        end
    end
end

-- Register the Modules Events
PartyFrame:SetScript('OnEvent', HandleEvents);
PartyFrame:RegisterEvent('PLAYER_ENTERING_WORLD');