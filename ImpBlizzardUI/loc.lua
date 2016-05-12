local addon, imp = ...;

-- If no Localization just return English
local function defaultFunc( imp, key )
	return key;
end
setmetatable( imp, {__index=defaultFunc});