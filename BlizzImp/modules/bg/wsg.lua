-- WIP! Please Ignore

local addon, imp = ...; -- Addon Namespace

local wsg = CreateFrame("Frame", nil, nil );

-- Strings
local WSG_FLAG_PICKUP = "The (%w+) flag was picked up by (.+)!"
local WSG_FLAG_CAPTURED = "(.+) captured the %w+ flag!"
local WSG_FLAG_RETURNED = "The (%w+) flag was returned to its base by .+!"

--flag respawn = 20 seconds

local function WSG_HandleEvents( self, event, ... )
	--print(event)
	if( event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" )then
		if( string.match( ..., WSG_FLAG_PICKUP ) )then
			--print("Alliance Flag Taken")
		end
		if( string.match( ..., WSG_FLAG_CAPTURED) )then
			--print("Alliance Flag Returned")
		end
	end

	if( event == "CHAT_MSG_BG_SYSTEM_HORDE" )then
		if( string.match( ..., WSG_FLAG_PICKUP ) )then
			--print("Horde Flag Taken")
		end
		if( string.match( ..., WSG_FLAG_CAPTURED) )then
			--print("Horde Flag Returned")
		end
		if( string.match( ..., WSG_FLAG_RETURNED) )then
			--print("Horde Flag Returned")
		end
	end
end

function imp:WSG_Init()
	--print("WSG Entered")
	wsg:SetScript( "OnEvent", WSG_HandleEvents );
	wsg:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE" );
	wsg:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE");
	wsg:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
end