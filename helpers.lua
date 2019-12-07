Helpers = CreateFrame('Frame', nil, UIParent);

--[[
	Just a helper for getting consistent font styles.
]]
function Helpers.get_styled_font(font)
    local font = LSM:Fetch('font', font);
    local _, _, flags = PlayerFrameHealthBarTextLeft:GetFont();
    local r, g, b, a = PlayerFrameHealthBarTextLeft:GetTextColor();

    return {
        font = font,
        flags = flags,
        r = r,
        g = g,
        b = b,
        a = a,
    };
end

--[[
	Just a helper for storing positions in a table.
]]
function Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs)
    return {
        point = point,
        relativeTo = relativeTo,
        relativePoint = relativePoint,
        x = xOfs,
        y = yOfs,
    };
end

--[[
	Adds a tooltip to a frame.
]]
function Helpers.add_tooltip(frame, text)
    frame:SetScript('OnEnter', function(self)
        GameTooltip:SetOwner(frame, 'ANCHOR_TOPLEFT');
        GameTooltip:AddLine(text, 1, 1, 0);
        GameTooltip:Show();
    end);
    frame:SetScript('OnLeave', GameTooltip_Hide);
end

--[[
	Creates a Draggable Frame.
]]
function Helpers.create_drag_frame(name, width, height, label)
    -- Create Drag Frame
    local frame = CreateFrame('Frame', name, UIParent);
    frame:SetMovable(true);
    frame:EnableMouse(true);

    -- On Click Set as Moving.
    frame:SetScript('OnMouseDown', function(self, button)
        if (button == 'LeftButton' and not self.isMoving) then
            self:StartMoving();
            self.isMoving = true;
        end
    end);

    -- Mouse Released
    frame:SetScript('OnMouseUp', function(self, button)
        if (button == 'LeftButton' and self.isMoving) then
            self:StopMovingOrSizing();
            self.isMoving = false;
        end
    end);

    -- Hiding 
    frame:SetScript('OnHide', function(self)
        if ( self.isMoving ) then
            self:StopMovingOrSizing();
            self.isMoving = false;
        end
    end);

    -- Make the Drag Frame Visible.
    frame:SetPoint('CENTER'); 
    frame:SetWidth(width); 
    frame:SetHeight(height);
    local tex = frame:CreateTexture('ARTWORK');
    tex:SetAllPoints();
    tex:SetTexture(1.0, 0.5, 0); 
    tex:SetAlpha(0.5);
    frame:SetFrameStrata('HIGH');

    -- Give it a Label.
    Helpers.add_tooltip(frame, label);

    -- Hide it
    frame:Hide();

    return frame;
end

--[[
	When passed an RGBA table simply returns it seperated.
]]
function Helpers.colour_unpack(colour)
    return colour.r, colour.g, colour.b, colour.a;
end

--[[
	Packs seperate RGBA values into a single table.
]]
function Helpers.colour_pack(r, g, b, a)
    return {
        r = r,
        g = g,
        b = b,
        a = a,
    };
end

--[[
    Converts a number to a string with comma values
    @ param int $number The number we're converting
    @
    @ return string
]]
function Helpers.format_num(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")

    return minus .. int:reverse():gsub("^,", "") .. fraction;
end

--[[
    Gets the Unit's class colour in RGB
    @ param Unit $unit The unit we're checking
    @ return array
]]
function Helpers.GetClassColour(unit)
    local _, class = UnitClass(unit);

    -- If we can find the class then return the class colours.
    if (class and RAID_CLASS_COLORS[class]) then
        return RAID_CLASS_COLORS[class];
    end

    -- Under rare circumstances can be nil. Just return white.
    return Helpers.colour_pack(1, 1, 1, 1);
end

--[[
    Converts an RGB Percentage to Hex - Source: WoWWiki
    @ param float $r Red
    @ param float $g Green
    @ param float $b Blue
    @
    @ return void
]]
function Helpers.RGBPercToHex(r, g, b)
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
    Applies the unit's class colour to the status bar that is passed in
    @ param Frame $statusBar The Status Bar we're tweaking
    @ param Unit $unit The unit we're checking
    @ return void
]]
function Helpers.ApplyClassColours(statusBar, unit)
    if ( UnitIsConnected(unit) and unit == statusBar.unit and UnitClass(unit) ) then
        local c = Helpers.GetClassColour(unit);
        statusBar:SetStatusBarColor(c.r, c.g, c.b );
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
function Helpers.ModifyFrame(frame, anchor, parent, posX, posY, scale)
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
function Helpers.ModifyBasicFrame(frame, anchor, parent, posX, posY, scale)
    frame:ClearAllPoints();
    if(parent == nil) then frame:SetPoint(anchor, posX, posY) else frame:SetPoint(anchor, parent, posX, posY) end
    if(scale ~= nil) then frame:SetScale(scale) end
end

--[[
    Helper function for essentially completely deleting a Frame.
    @ param Frame $frame The Frame we're destroying
    @ return void
]]
function Helpers.DestroyFrame(frame)
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