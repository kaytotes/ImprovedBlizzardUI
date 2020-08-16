--[[
    modules\bars\actionbars.lua
    Handles setting up the primary Bottom Left, Top Left, Top Right Bars
]]
ImpUI_Range = ImpUI:NewModule('ImpUI_Range', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

--[[
    Handles the Out of Range action bar colouring
	@param Frame $self The Action Bar Button
	@param float $elapsed The amount of time passed since the last frame
    @ return void
]]
local function ActionButton_OnUpdate_Hook(self, elapsed)
    if(self.rangeTimer == TOOLTIP_UPDATE_TIME) then
        if(IsActionInRange(self.action) == false) then
            self.icon:SetVertexColor(1, 0, 0);
        else
            local canUse, amountMana = IsUsableAction( self.action );
            if(canUse) then
                self.icon:SetVertexColor( 1.0, 1.0, 1.0 );
            elseif(amountMana) then
                self.icon:SetVertexColor( 0.5, 0.5, 1.0 );
            else
                self.icon:SetVertexColor( 0.4, 0.4, 0.4 );
            end
        end
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Range:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Range:OnEnable()
    -- self:SecureHook('ActionButton_OnUpdate', ActionButton_OnUpdate_Hook);
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Range:OnDisable()
end