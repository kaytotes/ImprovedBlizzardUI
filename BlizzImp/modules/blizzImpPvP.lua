local impPvP = CreateFrame( "Frame", "ImprovPVP", UIParent );

local storedHealth; -- Players Health

-- Message Related
local player; -- Player ID
local killTracker;
local message = CreateFrame( "MessageFrame", "BlizzImpMessageFrame", UIParent );
local eventDelay = 3;
local storedTime;
local messageHeight = 29;
local messageFont = "Interface\\Addons\\BlizzImp\\media\\test.ttf";

local recentKills = { " ", " ", " ", " ", " " }
local killsFrame;
local killFont = "Fonts\\FRIZQT__.TTF";

local function ClearKills()
	for i = 1, #recentKills do
		recentKills[i] = " ";
		killsFrame.texts[i]:SetText(" ");
	end
end

local function PVP_HandleEvents( self, event, unit )
	if( event == "PLAYER_ENTERING_WORLD" ) then
		player = UnitGUID( "player" );
		local _, instanceType = IsInInstance();
		-- Hide Objective Tracker When Entering PvP Instance
		if( instanceType == "pvp" or "arena" ) then
			if( not ObjectiveTrackerFrame.collapsed ) then
				ObjectiveTracker_Collapse();
			end
		end
	end

	if( event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_ENTERING_BATTLEGROUND") then
		ClearKills();
	end
end

local function UpdateKills( kill )
	local listLength = #recentKills;

	for i = 1, listLength -1 do
		recentKills[i] = recentKills[i + 1];
	end

	recentKills[listLength] = kill;

	for i = 1, listLength do
		killsFrame.texts[i]:SetText( recentKills[i] );
	end

end

local function InitKillLog()
	killsFrame = CreateFrame("Frame", nil, UIParent );
	killsFrame:SetFrameStrata("HIGH");
	killsFrame:SetWidth(256);
	killsFrame:SetHeight(128);
	killsFrame.texts = { }; -- Table for Kill Texts

	for i = 1, #recentKills do
		killsFrame.texts[i] = killsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal" )
		killsFrame.texts[i]:SetFont( killFont, 18, "THICKOUTLINE" );
		killsFrame.texts[i]:SetPoint("TOPLEFT", 15, -(30 * i) );
		killsFrame.texts[i]:SetWordWrap( false );
	end

	killsFrame:SetPoint( "TOPLEFT", 0, 15 );
end

-- Colour and Format Messages
local function BuildMessage(sourceGUID, sourceName, destGUID, destName )
	local playerFaction, _ = UnitFactionGroup( "player" );
	local killerString, killedString;
	local killerFaction, killedFaction

	--Build Killer Info
	killerFaction, _ = UnitFactionGroup( sourceName );
	if( killerFaction == playerFaction ) then -- Killer on our Faction
		if( playerFaction == "Horde" ) then
			killerString = format("|cffFE2E2E%s|r", sourceName ); -- Print Red
		else
			killerString = format("|cff2E9AFE%s|r", sourceName ); -- Print Blue
		end
	else -- Killer opposite Faction
		if( playerFaction == "Horde" ) then
			killerString = format("|cff2E9AFE%s|r", sourceName ); -- Print Blue
		else
			killerString = format("|cffFE2E2E%s|r", sourceName ); -- Print Red
		end
	end

	killedFaction, _ = UnitFactionGroup( destName );
	if( killedFaction == playerFaction ) then -- Killed Player on our Faction
		if( playerFaction == "Horde" ) then
			killedString = format("|cffFE2E2E%s|r", destName ); -- Print Red
		else
			killedString = format("|cff2E9AFE%s|r", destName ); -- Print Blue
		end
	else -- Killed Player opposite Faction
		if( playerFaction == "Horde" ) then
			killedString = format("|cff2E9AFE%s|r", destName ); -- Print Blue
		else
			killedString = format("|cffFE2E2E%s|r", destName ); -- Print Red
		end
	end

	return format("%s killed %s", killerString, killedString);
end

local function InitMessage()
	local killBlowCount = 0;

	-- Create Message Frame
	message:SetPoint( "LEFT" );
	message:SetPoint( "RIGHT" );
	message:SetHeight( messageHeight );
	message:SetInsertMode( "TOP" );
	message:SetFrameStrata( "HIGH" );
	message:SetTimeVisible( 3 );
	message:SetFadeDuration( 1 );
	message:SetFont( messageFont, 28 );

	-- Create Tracker Frame and Listen for Kills
	killTracker = CreateFrame( "Frame" );
	killTracker:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" );

	killTracker:SetScript("OnEvent", function(self, event, ...)		
		local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _ = ...;
		local _, instanceType = IsInInstance();

		if( instanceType == "pvp" or instanceType == "arena" ) then
			if( event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" )then
				local _, _, _, _, overkill, _, _, _, _, _, _, _ = select(12, ...);
				if( overkill >= 0 )then
					local killString = BuildMessage(sourceGUID, sourceName, destGUID, destName);
					UpdateKills( killString );
				end
			end

			if( event == "SWING_DAMAGE" )then
				local _, overkill = select(12, ... );
				if( overkill >= 0 )then
					local killString = BuildMessage(sourceGUID, sourceName, destGUID, destName);
					UpdateKills( killString );
				end
			end
		end

		--ASHRAN KILL BLOW DEBUG
		if( instanceType == "pvp" or instanceType == "arena" or (instanceType == "none" and GetZonePVPInfo() == "combat") )then
			if( event == "PARTY_KILL")then
				if( sourceGUID == player ) then
					message:AddMessage( "Killing Blow!", 1, 1, 0, 53, 3);
				end
			end
		end
	end);
end

local function PVP_Update()
	-- Health Warning
	healthPerc = UnitHealth("player") / UnitHealthMax("player");
	if( healthPerc > 0.5) then
		storedHealth = 0;
		return;
	elseif ( healthPerc > 0.25 ) then
		if( storedHealth == 0 ) then
			message:AddMessage( "HP < 50%  !", 0, 1, 1, 53, 3 );
		end
		return;
	elseif ( storedHealth ~= 2 ) then
		message:AddMessage( "HP < 25%  !!!", 1, 0, 0, 53, 3 );
	end
	storedHealth = 2;
end

local function PVP_Init()
	impPvP:SetScript( "OnEvent", PVP_HandleEvents );
	impPvP:SetScript( "OnUpdate", PVP_Update );

	impPvP:RegisterEvent( "PLAYER_LOGIN" );
	impPvP:RegisterEvent( "PLAYER_ENTERING_WORLD" );
	impPvP:RegisterEvent( "PLAYER_ENTERING_BATTLEGROUND" );

	InitMessage();
	InitKillLog();
end

-- Initialise Last
PVP_Init();