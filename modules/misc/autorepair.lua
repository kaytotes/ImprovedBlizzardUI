--[[
    modules\misc\autorepair.lua
    Automatically repairs your armour when you visit a merchant that can repair.
]]
local ImpUI_Repair = ImpUI:NewModule('ImpUI_Repair', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local CanMerchantRepair = CanMerchantRepair;
local GetRepairAllCost = GetRepairAllCost;
local CanGuildBankRepair = CanGuildBankRepair;
local GetGuildBankWithdrawMoney = GetGuildBankWithdrawMoney;
local GetGuildBankMoney = GetGuildBankMoney;
local RepairAllItems = RepairAllItems;
local GetCoinTextureString = GetCoinTextureString;
local GetMoney = GetMoney;

--[[
    Handles the Classic specific repairing logic.
	
    @ return void
]]
function ImpUI_Repair:Classic()
    local repCost, _ = GetRepairAllCost();

    if(repCost <= GetMoney() and repCost > 0) then
        RepairAllItems(false);
        print('|cffffff00'..L['Items Repaired']..': '..GetCoinTextureString(repCost));
    end
end

--[[
    Handles the Retail specific repairing logic.
	
    @ return void
]]
function ImpUI_Repair:Retail()
    local repCost, _ = GetRepairAllCost();

    if(CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repCost and GetGuildBankMoney() >= repCost and ImpUI.db.profile.guildRepair) then
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

--[[
    If a merchant window is open check if we can repair and do so.
    Uses guild funds if enabled.
	
    @ return void
]]
function ImpUI_Repair:MERCHANT_SHOW()
    if (ImpUI.db.profile.autoRepair and CanMerchantRepair()) then
        if (Helpers.IsRetail()) then
            ImpUI_Repair:Retail();
        else
            ImpUI_Repair:Classic();
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