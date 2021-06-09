--[[
    modules\frames\party.lua
    Styles and Repositions the Blizzard Party Frames.
]]
ImpUI_Party = ImpUI:NewModule('ImpUI_Party', 'AceEvent-3.0', 'AceHook-3.0');

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

    -- Style Each Party Frame
    for i = 1, 4 do
        -- Update Fonts
        _G["PartyMemberFrame"..i.."Name"]:SetTextColor(font.r, font.g, font.b, font.a);
        _G["PartyMemberFrame"..i.."Name"]:SetFont(font.font, 10, font.flags);
        
        _G["PartyMemberFrame"..i.."HealthBarText"]:SetFont(font.font, 8, font.flags);
        _G["PartyMemberFrame"..i.."HealthBarTextLeft"]:SetFont(font.font, 8, font.flags);
        _G["PartyMemberFrame"..i.."HealthBarTextRight"]:SetFont(font.font, 8, font.flags);

        _G["PartyMemberFrame"..i.."ManaBarText"]:SetFont(font.font, 8, font.flags);
        _G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetFont(font.font, 8, font.flags);
        _G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetFont(font.font, 8, font.flags);
    end
end

--[[
	Loads the position of the Party Frames from SavedVariables.
]]
function ImpUI_Party:LoadPosition()
    -- Known issues moving party frames in retail.
    -- if (Helpers.IsRetail()) then return end

    local pos = ImpUI.db.profile.partyFramePosition;
    local scale = ImpUI.db.profile.partyFrameScale;
    local offset = 0;

    if (pos.relativeTo == nil) then
        pos.relativeTo = UIParent;
    end
    
    -- Set Drag Frame Position
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);

    -- print(dragFrame:GetParent():GetName());
    -- print(dragFrame:IsRectValid());

    PartyMemberBackground:ClearAllPoints();
PartyMemberBackground:Hide();

    for i = 1, 4 do
        local partyFrame = _G["PartyMemberFrame"..i];

        partyFrame:ClearAllPoints();
        partyFrame:SetPoint('CENTER', dragFrame, 'BOTTOM', 0, 35 + offset);
        partyFrame:SetScale(scale);
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

    if (relativeTo == nil) then
        relativeTo = UIParent;
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
    -- if (Helpers.IsRetail()) then return end

    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_PartyFrame_DragFrame', 205, 350, L['Party Frames']);

    ImpUI_Party:LoadPosition();
    -- ImpUI_Party:StyleFrames();
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Party:OnDisable()
end
