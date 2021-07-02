--[[
    modules\frames\party.lua
    Styles and Repositions the Blizzard Party Frames.
]]
ImpUI_Party = ImpUI:NewModule('ImpUI_Party', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions

-- Local Variables
local dragFrame;

--[[
	Applies the actual styling.
	
    @ return void
]]
function ImpUI_Party:StyleFrames()
    if (ImpUI.db.profile.styleUnitFrames == false) then return; end

    -- Fonts
    local font = Helpers.get_styled_font(ImpUI.db.profile.primaryInterfaceFont);
    local size = 10;

    -- Style Each Party Frame
    for i = 1, 4 do
        -- Update Fonts
        _G["PartyMemberFrame"..i.."Name"]:SetTextColor(font.r, font.g, font.b, font.a);
        _G["PartyMemberFrame"..i.."Name"]:SetFont(font.font, size, font.flags);
        
        if (Helpers.IsRetail()) then
            _G["PartyMemberFrame"..i.."HealthBarText"]:SetFont(font.font, 8, font.flags);
            _G["PartyMemberFrame"..i.."HealthBarTextLeft"]:SetFont(font.font, 8, font.flags);
            _G["PartyMemberFrame"..i.."HealthBarTextRight"]:SetFont(font.font, 8, font.flags);
    
            _G["PartyMemberFrame"..i.."ManaBarText"]:SetFont(font.font, 8, font.flags);
            _G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetFont(font.font, 8, font.flags);
            _G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetFont(font.font, 8, font.flags);
        end
    end

    ImpUI_Party:UpdateColours();
end

--[[
	Simply updates the class colouring for all party members.
	
    @ return void
]]
function ImpUI_Party:UpdateColours()
    if (IsInGroup() == false) then return end

    local font = Helpers.get_styled_font(ImpUI.db.profile.primaryInterfaceFont);
    local enabled = ImpUI.db.profile.partyClassColours;
    
    for i = 1, 4 do
        local unitName = "party"..i;
        if (UnitExists(unitName)) then
            if (UnitClass(unitName)) then
                local c = Helpers.GetClassColour(unitName);
                local nameFrame = _G["PartyMemberFrame"..i.."Name"];

                if (enabled) then
                    nameFrame:SetTextColor(c.r, c.g, c.b, 1);
                else
                    nameFrame:SetTextColor(font.r, font.g, font.b, font.a);
                end
            end
        end
    end
end

--[[
	Fires when the party a player is in changes / updates with new members.
	
    @ return void
]]
function ImpUI_Party:GROUP_ROSTER_UPDATE()
    ImpUI_Party:UpdateColours();
end

--[[
	Loads the position of the Party Frames from SavedVariables.
]]
function ImpUI_Party:LoadPosition()
    local pos = ImpUI.db.profile.partyFramePosition;
    local scale = ImpUI.db.profile.partyFrameScale;
    local offset = 0;

    -- Fixes Set Anchor Point
    if (pos.relativeTo == nil) then
        pos.relativeTo = 'UIParent';
    end
    
    -- Set Drag Frame Position
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);

    -- Fixes Drag Frame
    PartyMemberBackground:ClearAllPoints();
    PartyMemberBackground:Hide();

    for i = 1, 4 do
        _G["PartyMemberFrame"..i]:SetMovable(true);
        _G["PartyMemberFrame"..i]:ClearAllPoints();
        _G["PartyMemberFrame"..i]:SetPoint('CENTER', dragFrame, 'BOTTOM', 0, 35 + offset);
        _G["PartyMemberFrame"..i]:SetScale(scale);
        _G["PartyMemberFrame"..i]:SetUserPlaced(true);
        _G["PartyMemberFrame"..i]:SetMovable(false);
        offset = offset + 60;
    end
end

--[[
	Hides Debug Party Frames if not in Group.
]]
function HideFrames()
    if (IsInGroup()) then return end

    for i = 1, 4 do
        _G["PartyMemberFrame"..i]:Hide();
    end
end

--[[
	Shows Debug Party Frames if not in Group.
]]
function ShowFrames()
    if (IsInGroup()) then return end

    for i = 1, 4 do
        _G["PartyMemberFrame"..i]:Show();
    end
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_Party:Unlock()
    dragFrame:Show();

    ShowFrames();
end

--[[
	Called when locking the UI.
]]
function ImpUI_Party:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    -- Fixes Set Anchor Point
    if (relativeTo == nil) then
        relativeTo = 'UIParent';
    end

    ImpUI.db.profile.partyFramePosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    HideFrames();

    dragFrame:Hide();
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Party:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Party:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_PartyFrame_DragFrame', 205, 350, L['Party Frames']);

    ImpUI_Party:LoadPosition();
    ImpUI_Party:StyleFrames();

    self:RegisterEvent('GROUP_ROSTER_UPDATE');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Party:OnDisable()
end
