--[[
    modules\bars\actionbars.lua
    Handles setting up the primary Bottom Left, Top Left, Top Right Bars
]]
local addonName, Loc = ...;

local ActionBars = CreateFrame('Frame', nil, UIParent);

--[[
    Hides or shows the Bag Bar

    @ return void
]]
function ToggleBagBar()
    if(ActionBars.bagsVisible) then
        -- Hide them
        Imp.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, -1, -300, nil);
        ActionBars.bagsVisible = false;
    else
        --show them
        Imp.ModifyFrame(MainMenuBarBackpackButton, 'BOTTOMRIGHT', UIParent, 0, 0, nil);
        ActionBars.bagsVisible = true;
    end
end

--[[
    Handles most of the actual adjustment.

    @ return void
]]
local function AdjustActionBars()
    if (InCombatLockdown() == false) then
        ActionBars.bagsVisible = true;
		ToggleBagBar();
	end
end

--[[
    Handles the Out of Range action bar colouring

	@param Frame $self The Action Bar Button
	@param float $elapsed The amount of time passed since the last frame
    @ return void
]]
-- 
local function ActionButton_OnUpdate_Hook(self, elapsed)
    if(BarsDB.outOfRange) then
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
                    self.icon:SetVertexColor( 0.4, 0.4, 0.4 )
                end
            end
        end
    end
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if(event == 'PLAYER_ENTERING_WORLD' or event == 'PLAYER_LOGIN' or event == 'PLAYER_TALENT_UPDATE' or event == 'ACTIVE_TALENT_GROUP_CHANGED') then
        AdjustActionBars();
	end
end

-- Register the Modules Events
ActionBars:SetScript('OnEvent', HandleEvents);
ActionBars:RegisterEvent('PLAYER_LOGIN');
ActionBars:RegisterEvent('PLAYER_ENTERING_WORLD');
ActionBars:RegisterEvent('PLAYER_TALENT_UPDATE');
ActionBars:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED');

-- Blizzard Function Hooks
hooksecurefunc('ActionButton_OnUpdate', ActionButton_OnUpdate_Hook);
