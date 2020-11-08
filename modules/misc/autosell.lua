--[[
    modules\misc\autosell.lua
    Automatically sells any grey items that are in your inventory.
]]
local ImpUI_Sell = ImpUI:NewModule('ImpUI_Sell', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local UnitClass = UnitClass;
local GetContainerNumSlots = GetContainerNumSlots;
local GetContainerItemLink = GetContainerItemLink;
local GetItemInfo = GetItemInfo;
local UseContainerItem = UseContainerItem;
local GetCoinTextureString = GetCoinTextureString;

--[[
    If a merchant window is open check if we can repair and do so.
    Uses guild funds if enabled.
	
    @ return void
]]
function ImpUI_Sell:MERCHANT_SHOW()
    -- If disabled in Config do nothing.
    if (ImpUI.db.profile.autoSell == false) then return; end
    
    local copper = 0;

    for i = 0, 3 do
        for bags = 0, 5 do
            local slots = GetContainerNumSlots(bags);
    
            for slot = 0, slots do
                local item = GetContainerItemLink( bags, slot );
                if( item ) then
                    local _,_,quality,_,_,_,_,_,_,_,price = GetItemInfo( item );
                    local _, count = GetContainerItemInfo( bags, slot );
                    if( quality == 0 and price ~= 0 ) then
                        copper = copper + ( price * count );
                        UseContainerItem( bags, slot );
                    end
                end
            end
        end
    end

    if (copper ~= 0) then
        print('|cffffff00'..L['Sold Trash Items']..': ' .. GetCoinTextureString( copper ) );
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Sell:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Sell:OnEnable()
    self:RegisterEvent('MERCHANT_SHOW');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Sell:OnDisable()
end