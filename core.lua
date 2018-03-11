local _, Loc = ...;

Imp = CreateFrame('Frame', nil, UIParent);

ImpFont = 'Interface\\AddOns\\ImprovedBlizzardUI\\media\\impfont.ttf';

-- Build the On Screen Display
Imp_OSD = CreateFrame('Frame', nil, UIParent);
Imp_OSD.text = Imp_OSD:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
Imp_OSD:SetWidth(32);
Imp_OSD:SetHeight(32);
Imp_OSD:SetFrameStrata('BACKGROUND');
Imp_OSD:SetPoint('CENTER', 0, 75);
Imp_OSD.text:SetPoint('CENTER', 0, 0);
Imp_OSD.text:SetFont(ImpFont, 26, 'OUTLINE');
Imp_OSD.hidden = true;
Imp_OSD.fadeTimer = nil;

-- Initialise the fadein / out anims
Imp_OSD.fadeInAnim = Imp_OSD:CreateAnimationGroup();
Imp_OSD.fadeIn = Imp_OSD.fadeInAnim:CreateAnimation('Alpha');
Imp_OSD.fadeIn:SetDuration(0.20);
Imp_OSD.fadeIn:SetFromAlpha(0);
Imp_OSD.fadeIn:SetToAlpha(1);
Imp_OSD.fadeIn:SetOrder(1);

Imp_OSD.fadeInAnim:SetScript('OnFinished', function() 
    Imp_OSD:SetAlpha(1);
    Imp_OSD.hidden = false;
end);

Imp_OSD.fadeOutAnim = Imp_OSD:CreateAnimationGroup();
Imp_OSD.fadeOut = Imp_OSD.fadeOutAnim:CreateAnimation('Alpha');
Imp_OSD.fadeOut:SetDuration(0.20);
Imp_OSD.fadeOut:SetFromAlpha(1);
Imp_OSD.fadeOut:SetToAlpha(0);
Imp_OSD.fadeOut:SetOrder(1);

Imp_OSD.fadeOutAnim:SetScript('OnFinished', function() 
    Imp_OSD:SetAlpha(0);
    Imp_OSD.hidden = true;
    Imp_OSD.text:SetText('');
end);

function Imp_OSD.AddMessage(message, r, g, b, duration)
    Imp_OSD.text:SetText(message);
    Imp_OSD.text:SetTextColor(r, g, b, 1.0);

    if (Imp_OSD.hidden) then
        Imp_OSD.fadeInAnim:Play();
    end

    if ( Imp_OSD.fadeTimer ~= nil ) then
        Imp_OSD.fadeTimer:Cancel();
    end

    -- Set Fade Timer
    Imp_OSD.fadeTimer = C_Timer.NewTimer(duration, function()
        Imp_OSD.fadeOutAnim:Play();
    end);
end

--[[
    Applies the unit's class colour to the status bar that is passed in

    @ param Frame $statusBar The Status Bar we're tweaking
    @ param Unit $unit The unit we're checking
    @ return void
]]
function Imp.ApplyClassColours(statusBar, unit)
    if ( UnitIsConnected(unit) and unit == statusBar.unit and UnitClass(unit) ) then
        local _, class = UnitClass(unit);
        local c = RAID_CLASS_COLORS[class];
        statusBar:SetStatusBarColor(c.r, c.g, c.b );
    end
end

--[[
    Gets the Unit's class colour in RGB

    @ param Unit $unit The unit we're checking
    @ return array
]]
function Imp.GetClassColour(unit)
    if (UnitClass(unit)) then
        local _, class = UnitClass(unit);
        local c = RAID_CLASS_COLORS[class];
        return c;
    end
end

--[[
    Helper function for moving a Blizzard frame that has a SetMoveable flag

    @ param Frame $frame The Frame we're tweaking
    @ param string $anchor The anchoring point of the frame. CENTER, TOP, BOTTOM etc.
    @ param Frame $parent Optional Frame to parent to
    @ param int $posX Frames new X Position
    @ param int $posY Frames new Y Position
    @ param float $scale Frames new scale
    @ return void
]]
function Imp.ModifyFrame(frame, anchor, parent, posX, posY, scale)
    frame:SetMovable(true);
    frame:ClearAllPoints();
    if(parent == nil) then frame:SetPoint(anchor, posX, posY) else frame:SetPoint(anchor, parent, posX, posY) end
    if(scale ~= nil) then frame:SetScale(scale) end
    frame:SetUserPlaced(true);
    frame:SetMovable(false);
end

--[[
    Helper function for moving a Blizzard frame that does NOT have a SetMoveable flag

    @ param Frame $frame The Frame we're tweaking
    @ param string $anchor The anchoring point of the frame. CENTER, TOP, BOTTOM etc.
    @ param Frame $parent Optional Frame to parent to
    @ param int $posX Frames new X Position
    @ param int $posY Frames new Y Position
    @ param float $scale Frames new scale
    @ return void
]]
function Imp.ModifyBasicFrame(frame, anchor, parent, posX, posY, scale)
    frame:ClearAllPoints();
    if(parent == nil) then frame:SetPoint(anchor, posX, posY) else frame:SetPoint(anchor, parent, posX, posY) end
    if(scale ~= nil) then frame:SetScale(scale) end
end

--[[
    Helper function for essentially completely deleting a Frame.

    @ param Frame $frame The Frame we're destroying
    @ return void
]]
function Imp.DestroyFrame(frame)
	if type(frame) == 'table' and frame.SetScript then
		frame:UnregisterAllEvents();
        frame:SetScript('OnEvent',nil);
        frame:SetScript('OnUpdate',nil);
        frame:SetScript('OnHide',nil);
        frame:Hide();
        frame.SetScript = function() end;
        frame.RegisterEvent = function() end;
        frame.RegisterAllEvents = function() end;
        frame.Show = function() end;
	end
end

--[[
    Converts an RGB colour to Hex - Source: WoWWiki

    @ param float $r Red
    @ param float $g Green
    @ param float $b Blue
    @
    @ return void
]]
function Imp.RGBToHex(r, g, b)
	if (type(r) == "table") then
		g = r.g
		b = r.b
		r = r.r
	end
	if (not r and not g and not b) then
		r = 255
		g = 255
		b = 255
	end
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end

--[[
    Converts an RGB Percentage to Hex - Source: WoWWiki

    @ param float $r Red
    @ param float $g Green
    @ param float $b Blue
    @
    @ return void
]]
function Imp.RGBPercToHex(r, g, b)
	if (type(r) == "table") then
		g = r.g
		b = r.b
		r = r.r
    end
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

--[[
    Just strips out alpha at the beginning of a hex string

    @ param string $hex The ARGB Hex
    @
    @ return string
]]
function Imp.ARGBToHex(hex)
    return hex:sub(3);
end

--[[
    Converts a number to a string with comma values

    @ param int $number The number we're converting
    @
    @ return string
]]
function Imp.formatNum(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")

    return minus .. int:reverse():gsub("^,", "") .. fraction
end

local version = GetAddOnMetadata('ImprovedBlizzardUI', 'Version');

if (version == '@project-version@') then
    version = 'Development Build';
end

print('|cffffff00Improved Blizzard UI ' .. version .. ' Initialised.');