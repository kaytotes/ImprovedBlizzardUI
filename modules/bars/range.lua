--[[
    modules\bars\range.lua
    Handles Range Based Icon Colour changes on Action Bars.
]]
ImpUI_Range = ImpUI:NewModule('ImpUI_Range', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

local usableColour = Helpers.colour_pack(1, 1, 1, 1);
local outOfRangeColour = Helpers.colour_pack(0.8, 0.1, 0.1, 1);
local notEnoughManaColour = Helpers.colour_pack(0.1, 0.3, 1.0);
local fallbackColour = Helpers.colour_pack(0.3, 0.3, 0.3, 1.0);

--[[
    Handles the Out of Range action bar colouring in a Classic WoW environment.

	@param Frame $self The Action Bar Button
	@param float $elapsed The amount of time passed since the last frame
    @ return void
]]
local function ActionButton_OnUpdate_Hook(self, elapsed)
    if(self.rangeTimer == TOOLTIP_UPDATE_TIME) then
        if(IsActionInRange(self.action) == false) then
            self.icon:SetVertexColor(outOfRangeColour.r, outOfRangeColour.g, outOfRangeColour.b);
        else
            local canUse, amountMana = IsUsableAction( self.action );
            if(canUse) then
                self.icon:SetVertexColor(usableColour.r, usableColour.g, usableColour.b);
            elseif(amountMana) then
                self.icon:SetVertexColor( notEnoughManaColour.r, notEnoughManaColour.g, notEnoughManaColour.b );
            else
                self.icon:SetVertexColor( fallbackColour.r, fallbackColour.g, fallbackColour.b );
            end
        end
    end
end

--[[
    Handles the Out of Range action bar colouring in a Shadowlands onwards environment.

	@param Frame $hasrange Whether the action on the button has a range.
	@param float $inrange If it does, is it in range currently.
    @ return void
]]
function ImpUI_Range:RangeUpdate(hasrange, inrange)
	local Icon = self.icon
	local NormalTexture = self.NormalTexture
	local ID = self.action

	if not ID then
		return
	end
	
	local IsUsable, NotEnoughMana = IsUsableAction(ID)
	local HasRange = hasrange
	local InRange = inrange

	if (IsUsable) then
		if (HasRange and InRange == false) then
			Icon:SetVertexColor(outOfRangeColour.r, outOfRangeColour.g, outOfRangeColour.b);
		else
			Icon:SetVertexColor(usableColour.r, usableColour.g, usableColour.b);
		end
	elseif (NotEnoughMana) then
		Icon:SetVertexColor(notEnoughManaColour.r, notEnoughManaColour.g, notEnoughManaColour.b);
	else
		Icon:SetVertexColor(fallbackColour.r, fallbackColour.g, fallbackColour.b);
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
    if (Helpers.IsClassic() or Helpers.IsTBC()) then
        self:SecureHook('ActionButton_OnUpdate', ActionButton_OnUpdate_Hook);
        return
    end

    hooksecurefunc("ActionButton_UpdateRangeIndicator", ImpUI_Range.RangeUpdate)
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Range:OnDisable()
end