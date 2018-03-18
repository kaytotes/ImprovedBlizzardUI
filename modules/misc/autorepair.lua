--[[
    modules\misc\autorepair.lua
    Automatically repairs your armour when you visit a merchant that can repair.
]]
local addonName, Loc = ...;

local RepairFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'MERCHANT_SHOW' and CanMerchantRepair() and PrimaryDB.autoRepair) then
        local repCost, _ = GetRepairAllCost();

        if(CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repCost and GetGuildBankMoney() >= repCost and PrimaryDB.guildRepair) then
            if(repCost > 0) then
                RepairAllItems(true);
                print('|cffffff00'..Loc['Items Repaired from Guild Bank']..': '..GetCoinTextureString(repCost));
            end
        else
            if(repCost <= GetMoney() and repCost > 0) then
                RepairAllItems(false);
                print('|cffffff00'..Loc['Items Repaired']..': '..GetCoinTextureString(repCost));
            end
        end
    end
end

-- Register the Modules Events
RepairFrame:SetScript('OnEvent', HandleEvents);
RepairFrame:RegisterEvent('MERCHANT_SHOW');