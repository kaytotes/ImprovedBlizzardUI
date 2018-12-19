Helpers = CreateFrame('Frame', nil, UIParent);

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