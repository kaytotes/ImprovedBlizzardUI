Helpers = CreateFrame('Frame', nil, UIParent);

local debug = false;

function Helpers.Debug()
    return debug;
end

--[[
	Removes an element from a table by key.
]]
function Helpers.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

--[[
	Simply returns what percentage the first var is of the second.
]]
function Helpers.to_percentage(first, second)
    return (first / second) * 100;
end

--[[
	Simple check for if we're currently running in a Classic WoW Client.
]]
function Helpers.IsClassic()
    return select(4,GetBuildInfo()) <= 19999;
end

--[[
	Simple check for if we're currently running in a Retail WoW Client.
]]
function Helpers.IsRetail()
    return not Helpers.IsClassic();
end

--[[
	Just gets the string for the supported build.
]]
function Helpers.GetSupportedBuild()
    if (Helpers.IsRetail()) then
        return '9.0.2';
    else
        return '1.13.5';
    end
end

--[[
	Returns a human readable string for the current environment.
]]
function Helpers.GetEnvironment()
    if (Helpers.IsRetail()) then
        return 'Shadowlands';
    else
        return 'Classic';
    end
end

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
	To debug exact position of a frame.
]]
function Helpers.debug_position(frame)
    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint();

    print(frame:GetName());
    print(format('Point: %s', point));
    print('Relative To:');
    print(Helpers.dump_table(relativeTo));
    print(format('Relative Point: %s', relativePoint));
    print(format('xOffset: %s', xOfs));
    print(format('yOffset: %s', yOfs));
end

--[[
	To debug a tables contents.
]]
function Helpers.dump_table(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. Helpers.dump_table(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
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

    if (Helpers.IsClassic() and class == 'SHAMAN') then
        return Helpers.colour_pack(0.0, 0.44, 0.87, 1);
    end

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

function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number);
end

--[[
	Figures out if provided guid is a Player.
]]
function Helpers.IsPlayerByGUID(guid)
    local type, _, _, _, _, _, _ = strsplit("-", guid);

    return type == 'Player';
end

--[[
	Figures out if provided guid is an NPC.
]]
function Helpers.IsCreatureByGUID(guid)
    local type, _, _, _, _, _, _ = strsplit("-", guid);

    return type == 'Creature';
end

--[[
	Figures out a players faction from their guid.
]]
function Helpers.GetFactionByGUID(guid)
    _, _, _, englishRace, _, _, _ = GetPlayerInfoByGUID(guid);

    return Helpers.GetFactionByRace(englishRace);
end

--[[
	I absolutely hate that that is required. Shoot me.
]]
function Helpers.GetFactionByRace(race)
    local horde = 'Horde';
    local alliance = 'Alliance';
    local unknown = 'Unknown';

    -- Edge Cases
    if (race == 'Pandaren') then return unknown end

    -- Alliance
    if (race == 'Human') then return alliance end
    if (race == 'Dwarf') then return alliance end
    if (race == 'NightElf') then return alliance end
    if (race == 'Gnome') then return alliance end
    if (race == 'Draenei') then return alliance end
    if (race == 'Worgen') then return alliance end
    if (race == 'VoidElf') then return alliance end
    if (race == 'LightforgedDraenei') then return alliance end
    if (race == 'KulTiran') then return alliance end
    if (race == 'ThinHuman') then return alliance end
    if (race == 'DarkIronDwarf') then return alliance end
    if (race == 'Mechagnome') then return alliance end

    -- Horde
    if (race == 'Orc') then return horde end
    if (race == 'Scourge') then return horde end
    if (race == 'Tauren') then return horde end
    if (race == 'Troll') then return horde end
    if (race == 'Goblin') then return horde end
    if (race == 'BloodElf') then return horde end
    if (race == 'Nightborne') then return horde end
    if (race == 'HighmountainTauren') then return horde end
    if (race == 'ZandalariTroll') then return horde end
    if (race == 'Vulpera') then return horde end
    if (race == 'MagharOrc') then return horde end
end