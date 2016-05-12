--[[
    ImpBlizzardUI/loc.lua
    Handles the matching of English Key Pairs for Localisation Support
    Notes: Actual Localised data is kept in the ImpBlizzardUI/loc/*.lua files
]]
local _, ImpBlizz = ...;

-- If no Localization data found just return English
local function defaultFunc( ImpBlizz, key )
	return key;
end
setmetatable( ImpBlizz, {__index=defaultFunc});
