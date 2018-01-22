local addonName, Loc = ...;

local AutoSellFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if( event == 'MERCHANT_SHOW' and ImprovedBlizzardUIDB.autoSell) then
		local copper = 0;
		for bags = 0, 4 do
			for slot = 1, GetContainerNumSlots( bags ) do
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
		if( copper ~= 0 ) then
			print('|cffffff00'..Loc['Sold Trash Items']..': ' .. GetCoinTextureString( copper ) );
		end
	end
end

-- Register the Modules Events
AutoSellFrame:SetScript('OnEvent', HandleEvents);
AutoSellFrame:RegisterEvent('MERCHANT_SHOW');