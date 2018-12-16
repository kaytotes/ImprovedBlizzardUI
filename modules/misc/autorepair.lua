local ImpUI_Repair = ImpUI:NewModule('ImpUI_Repair', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

--[[
    If a merchant window is open check if we can repair and do so.
    Uses guild funds if enabled.
	
    @ return void
]]
function ImpUI_Repair:MERCHANT_SHOW()
    if (ImpUI.db.char.autoRepair and CanMerchantRepair()) then
        local repCost, _ = GetRepairAllCost();

        if(CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repCost and GetGuildBankMoney() >= repCost and ImpUI.db.char.guildRepair) then
            if(repCost > 0) then
                RepairAllItems(true);
                print('|cffffff00'..L['Items Repaired from Guild Bank']..': '..GetCoinTextureString(repCost));
            end
        else
            if(repCost <= GetMoney() and repCost > 0) then
                RepairAllItems(false);
                print('|cffffff00'..L['Items Repaired']..': '..GetCoinTextureString(repCost));
            end
        end
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Repair:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Repair:OnEnable()
    self:RegisterEvent('MERCHANT_SHOW');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Repair:OnDisable()
end