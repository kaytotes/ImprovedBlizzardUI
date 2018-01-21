--[[
    localisation.lua
    Handles the matching of English Key Pairs for Localisation Support
    Notes: Actual Localised data is kept in the ImpBlizzardUI/loc/*.lua files
]]

local addonName, Loc = ...; -- Every .lua file gets passed a private table so we'll use that to store the localisation stuff

--[[
    Called if no matching localisation template can be found for the key.
    Just returns the key so that it can be used to write the default English.

    @ param table $Loc The Localisation Table
    @ param string key The key thats required in English
    @ return string
]]
local function getLocalisation(Loc, key)
    return key;
end

setmetatable(Loc, {__index=getLocalisation});