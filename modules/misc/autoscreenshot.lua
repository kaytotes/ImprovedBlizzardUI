--[[
    modules\misc\autoscreenshot.lua
    Automatically takes a screenshot when an achievement is earned
]]
local ImpUI_Screenshot = ImpUI:NewModule('ImpUI_Screenshot', 'AceEvent-3.0');

-- Just a toggle to stop spamming on multiple achievements.
local canCapture = true;

--[[
	Fired when an Achievement is earned.
	
    @ return void
]]
function ImpUI_Screenshot:ACHIEVEMENT_EARNED()
    if (canCapture and ImpUI.db.profile.autoScreenshot) then
        canCapture = false;

        C_Timer.After(1, Screenshot); -- Take Screenshot
        C_Timer.After(4, function() canCapture = true end); -- After 4 seconds allow another to be taken.
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Screenshot:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Screenshot:OnEnable()
    if (Helpers.IsClassic()) then return end
    
    self:RegisterEvent('ACHIEVEMENT_EARNED');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Screenshot:OnDisable()
end