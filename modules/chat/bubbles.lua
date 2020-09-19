--[[
    modules\misc\bubbles.lua
    Re-Styles the Chat Bubbles.
]]
ImpUI_Bubbles = ImpUI:NewModule('ImpUI_Bubbles', 'AceEvent-3.0', 'AceHook-3.0');

local handler = CreateFrame('Frame');

local replacementTexture = "Interface\\AddOns\\ImprovedBlizzardUI\\media\\blank";

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

local function ToFixedScale(len)
    return GetScreenHeight() * len / 768
end

local function RotateCoordPair(x, y, ox, oy, a, asp)
    y = y / asp;
    oy = oy / asp;
    return ox + (x - ox) * math.cos(a) - (y - oy) * math.sin(a),
        (oy + (y - oy) * math.cos(a) + (x - ox) * math.sin(a)) * asp;
end

local function SetRotatedTexCoords(tex, left, right, top, bottom, width, height, angle, originx, originy)
    local ratio, angle, originx, originy = width / height, math.rad(angle), originx or 0.5, originy or 1;
    local LRx, LRy = RotateCoordPair(left, top, originx, originy, angle, ratio);
    local LLx, LLy = RotateCoordPair(left, bottom, originx, originy, angle, ratio);
    local ULx, ULy = RotateCoordPair(right, top, originx, originy, angle, ratio);
    local URx, URy = RotateCoordPair(right, bottom, originx, originy, angle, ratio);

    tex:SetTexCoord(LRx, LRy, LLx, LLy, ULx, ULy, URx, URy);
end

function ImpUI_Bubbles:Style(frame)
    print('Beginning Style');

    for i = 1, select("#", frame:GetRegions()) do
		local region = select(i, frame:GetRegions())
		if (region:GetObjectType() == "FontString") then
			frame.text = region;
		end
	end
	
    -- Font
    local font = LSM:Fetch('font', ImpUI.db.char.primaryInterfaceFont);
    local _, _, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local _, size, _ = frame.text:GetFont();

    frame.text:SetFont(font, size, flags);

    -- Border
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", frame.text, -10, 10)
    frame:SetPoint("BOTTOMRIGHT", frame.text, 10, -10)
    frame:SetBackdrop({
        edgeFile = replacementTexture,
        edgeSize = 1,
        insets = {
            top = nil,
            bottom = nil,
            left = nil,
            right = nil
        }
    });

    frame:SetBackdropBorderColor(0, 0, 0, 0);

    -- Tiling
    local bg = frame:CreateTexture(nil, "BACKGROUND");
    bg:SetAllPoints();
    bg:SetTexture(replacementTexture, false);
    bg:SetVertexColor(0, 0, 0, 0);
    bg:SetHorizTile(false);
    bg:SetVertTile(false);

    -- Tail / Bottom
    local bottom, tail
    for i = 1, select("#", frame:GetRegions()) do
        local region = select(i, frame:GetRegions())
        if region:GetObjectType() == "Texture" then
            if ({region:GetPoint()})[1] == "BOTTOMLEFT" and region:GetPoint(2) then
                bottom = region;
            elseif region:GetTexture() == "Interface\\Tooltips\\ChatBubble-Tail" then
                tail = region;
            end
        end
    end

    tail:ClearAllPoints();
    tail:SetSize(ToFixedScale(16), ToFixedScale(16));
    tail:SetPoint("TOP", frame, "BOTTOM",0, 1 / ToFixedScale(1));
    tail:SetTexture(replacementTexture);
    tail:SetVertexColor(0, 0, 0, 0);

    tailBd = frame:CreateTexture();
    tailBd:SetAllPoints(tail);
    tailBd:SetTexture(replacementTexture);
    tailBd:SetVertexColor(0, 0, 0, 0);

    bottom:SetPoint("BOTTOMRIGHT", tail, "TOPLEFT");
    local bottom2 = frame:CreateTexture(nil, "BORDER");
    bottom2:SetTexture(replacementTexture);
    SetRotatedTexCoords(bottom2, 0.375, 0.5, 0, 1, 64, 8, -90, 0.5, 1);
    bottom2:SetVertexColor(0, 0, 0, 0);
    bottom2:SetHeight(bottom:GetHeight());
    bottom2:SetPoint("LEFT", tail, "RIGHT", -ToFixedScale(8), 0);
    bottom2:SetPoint("BOTTOMRIGHT", frame, 1, 0);

    frame:HookScript("OnHide", function() frame.inUse = false end);
end

function ImpUI_Bubbles:FindFrame(string)
    for i = 1, WorldFrame:GetNumChildren() do
        local frame = select(i, WorldFrame:GetChildren())
        if (not frame:GetName() and not frame.inUse) then
            for i = 1, select("#", frame:GetRegions()) do
                local region = select(i, frame:GetRegions())
                if (region:GetObjectType() == "FontString" and region:GetText() == string) then
                    return frame;
                end
            end
        end
    end
end

function ImpUI_Bubbles:AttachScript(msg)
    handler.elapsed = 0;

    handler:SetScript("OnUpdate", function(self, elapsed)
        self.elapsed = self.elapsed + elapsed;
        local frame = ImpUI_Bubbles:FindFrame(msg);
        if frame or self.elapsed > 0.3 then
            handler:SetScript("OnUpdate", nil);
            if frame then ImpUI_Bubbles:Style(frame) end
        end
    end)
end

function ImpUI_Bubbles:ShouldModify(cvar)
    return GetCVarBool(cvar);
end

function ImpUI_Bubbles:CHAT_MSG_SAY(event, msg)
    if (not ImpUI_Bubbles:ShouldModify('chatBubbles')) then
        return;
    end

    ImpUI_Bubbles:AttachScript(msg)
end

function ImpUI_Bubbles:CHAT_MSG_YELL(event, msg)
    if (not ImpUI_Bubbles:ShouldModify('chatBubbles')) then
        return;
    end

    ImpUI_Bubbles:AttachScript(msg);
end

function ImpUI_Bubbles:CHAT_MSG_PARTY(event, msg)
    if (not ImpUI_Bubbles:ShouldModify('chatBubblesParty')) then
        return;
    end

    ImpUI_Bubbles:AttachScript(msg);
end

function ImpUI_Bubbles:CHAT_MSG_PARTY_LEADER(event, msg)
    if (not ImpUI_Bubbles:ShouldModify('chatBubblesParty')) then
        return;
    end

    ImpUI_Bubbles:AttachScript(msg);
end

function ImpUI_Bubbles:CHAT_MSG_MONSTER_SAY(event, msg)
    if (not ImpUI_Bubbles:ShouldModify('chatBubbles')) then
        return;
    end

    ImpUI_Bubbles:AttachScript(msg);
end

function ImpUI_Bubbles:CHAT_MSG_MONSTER_YELL(event, msg)
    if (not ImpUI_Bubbles:ShouldModify('chatBubbles')) then
        return;
    end

    ImpUI_Bubbles:AttachScript(msg);
end

function ImpUI_Bubbles:CHAT_MSG_MONSTER_PARTY(event, msg)
    if (not ImpUI_Bubbles:ShouldModify('chatBubblesParty')) then
        return;
    end

    ImpUI_Bubbles:AttachScript(msg);
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Bubbles:OnInitialize()
    
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Bubbles:OnEnable()
    self:RegisterEvent('CHAT_MSG_SAY');
    self:RegisterEvent('CHAT_MSG_YELL');
    self:RegisterEvent('CHAT_MSG_PARTY');
    self:RegisterEvent('CHAT_MSG_PARTY_LEADER');
    self:RegisterEvent('CHAT_MSG_MONSTER_SAY');
    self:RegisterEvent('CHAT_MSG_MONSTER_YELL');
    self:RegisterEvent('CHAT_MSG_MONSTER_PARTY');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Bubbles:OnDisable()
end