--[[
    modules\combat\autorelease.lua.lua
    Automatically releases the players spirit when they die if they do not have a self res.
]]
local ImpUI_Ressurect = ImpUI:NewModule('ImpUI_Ressurect', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local OSD;

-- Local Functions
local GetSortedSelfResurrectOptions = GetSortedSelfResurrectOptions;
local IsInInstance = IsInInstance;
local RepopMe = RepopMe;

--[[
    Replacement of the old function that blizzard deprecated
    @ return bool
]]
function HasSoulstone()
	local options = GetSortedSelfResurrectOptions();
	return options and options[1] and options[1].name;
end


--[[
	Fires when the Player Dies.
	
    @ return void
]]
function ImpUI_Ressurect:PLAYER_DEAD()
    if (ImpUI.db.char.autoRel == false) then return; end

    if (HasSoulstone()) then return; end -- If we can self res (Ankh etc) then don't do anything.

    local _, instanceType = IsInInstance();

    local shouldRelease = false;

    -- Figure out if we should show based on config.
    if (instanceType == 'none' and ImpUI.db.char.killingBlowInWorld) then shouldRelease = true; end
    if (instanceType == 'party' and ImpUI.db.char.killingBlowInInstance) then shouldRelease = true; end
    if (instanceType == 'raid' and ImpUI.db.char.killingBlowInRaid) then shouldRelease = true; end
    if((instanceType == 'pvp' or instanceType == 'arena' or (instanceType == 'none' and GetZonePVPInfo() == 'combat')) and ImpUI.db.char.killingBlowInPvP) then shouldRelease = true; end

    if (shouldRelease) then
        RepopMe();
        return
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Ressurect:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Ressurect:OnEnable()
    OSD = ImpUI:GetModule('ImpUI_OSD');

    self:RegisterEvent('PLAYER_DEAD');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Ressurect:OnDisable()
end