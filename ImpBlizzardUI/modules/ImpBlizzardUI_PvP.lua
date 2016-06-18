--[[
    ImpBlizzardUI/modules/ImpBlizzardUI_PvP
    Builds the PvP kill tracker and handles some more PvP combat events
    Current Features: Health Warnings, Killing Blow Indicator, PvP Kill Feed, Objective Tracker Collapse, Remove "Leave Queue" button on PvP Join Window
]]
local _, ImpBlizz = ...;

local PvPFrame = CreateFrame("Frame", nil, UIParent);

-- Health Warning Update Tick (Could this be a little resource intensive?)
local function HealthWarning_Update()
    local healthPercentage = UnitHealth("player") / UnitHealthMax("player");

    -- Only shows if not dead
    if(healthPercentage >= 0.01) then
        if(healthPercentage <= 0.50 and healthPercentage > 0.25) then
            PvPFrame.onScreenDisplay:AddMessage( ImpBlizz["HP < 50% !"], 0, 1, 1, 53, 3 );
            return;
        elseif(healthPercentage < 0.25) then
            PvPFrame.onScreenDisplay:AddMessage(ImpBlizz["HP < 25% !!!"], 1, 0, 0, 53, 3);
            return;
        end
    end

    return;
end

-- Writes a Kill Feed message. Works out factions and colours text appropriately
local function KillFeed_Update(sourceGUID, sourceName, destGUID, destName)
    if(Conf_KillFeed) then
        local playerFaction, _ = UnitFactionGroup( "player" );
        local killerString, killedString, killerFaction, killedFaction;

        -- Work out who killed someone and what faction
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

        -- Work out who died and what faction
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

        -- Write it to the kill log
        for i = 1, #PvPFrame.killFeed.recentKills -1 do -- Replace top kill with 2nd etc
            PvPFrame.killFeed.recentKills[i] = PvPFrame.killFeed.recentKills[i + 1];
        end

        -- Set the most recent message
        PvPFrame.killFeed.recentKills[#PvPFrame.killFeed.recentKills] = format("%s%s%s", killerString, ImpBlizz[" killed "], killedString);

        for i = 1, #PvPFrame.killFeed.recentKills do
            PvPFrame.killFeed.texts[i]:SetText( PvPFrame.killFeed.recentKills[i] );
        end
    end
end

local function BuildHealthWarning()
    if(Conf_HealthUpdate) then
        PvPFrame.healthUpdater = CreateFrame("Frame", nil, UIParent);
        PvPFrame.healthUpdater:SetScript("OnUpdate", HealthWarning_Update);
        PvPFrame.healthUpdater.storedHealth = 0;
    end
end

-- Builds the BG / Arena kill feed.
local function BuildKillFeed()
    PvPFrame.killFeed = CreateFrame("Frame", nil, UIParent );
    PvPFrame.killFeed:SetFrameStrata("HIGH");
    PvPFrame.killFeed:SetWidth(256);
    PvPFrame.killFeed:SetHeight(128);
    PvPFrame.killFeed.texts = { }; -- Table for Kill Texts
    PvPFrame.killFeed.recentKills = { " ", " ", " ", " ", " " }

    for i = 1, #PvPFrame.killFeed.recentKills do
        PvPFrame.killFeed.texts[i] = PvPFrame.killFeed:CreateFontString(nil, "OVERLAY", "GameFontNormal" )
        PvPFrame.killFeed.texts[i]:SetFont( "Interface\\AddOns\\BlizzImp\\media\\impfont.ttf", 18, "OUTLINE" );
        PvPFrame.killFeed.texts[i]:SetPoint("TOPLEFT", 15, -(30 * i) );
        PvPFrame.killFeed.texts[i]:SetWordWrap( false );
    end

    PvPFrame.killFeed:SetPoint( "TOPLEFT", 0, 15 );
end

-- Create the On Screen Display text, used by Killing Blows and Health status
local function BuildOnScreenDisplay()
    PvPFrame.onScreenDisplay = CreateFrame( "MessageFrame", "OnScreenDisplay", UIParent );
    PvPFrame.onScreenDisplay:SetPoint("LEFT");
    PvPFrame.onScreenDisplay:SetPoint("RIGHT");
    PvPFrame.onScreenDisplay:SetHeight(29);
    PvPFrame.onScreenDisplay:SetInsertMode("TOP");
    PvPFrame.onScreenDisplay:SetFrameStrata("HIGH");
    PvPFrame.onScreenDisplay:SetTimeVisible(3);
    PvPFrame.onScreenDisplay:SetFadeDuration(1);
    PvPFrame.onScreenDisplay:SetFont("Interface\\AddOns\\ImpBlizzardUI\\media\\impfont.ttf", 26, "OUTLINE");
end

-- Handle the Blizzard API events and respond appropriately
local function HandleEvents(self, event, ...)

    if(event == "ADDON_LOADED" and ... == "ImpBlizzardUI") then
        BuildHealthWarning();
    end

    local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _ = ...; -- Get all the variables we need
    local _, instanceType = IsInInstance();

    -- Checks for a Killing Blow made by the player. Triggers in BG's, Arena and World PvP Zones (Ashran etc)
    if(instanceType == "pvp" or instanceType == "arena" or (instanceType == "none" and GetZonePVPInfo() == "combat")) then -- Only run in a BG
        if(event == "PARTY_KILL") then
            if(sourceGUID == player and Conf_KillingBlow) then
                PvPFrame.onScreenDisplay:AddMessage(ImpBlizz["Killing Blow!"], 1, 1, 0, 53, 3);
            end
        end
    end

    -- Check for kills and update the Kill Feed, only runs in Battlegrounds and Arenas
    if(instanceType == "pvp" or instanceType == "arena") then
        -- Ranged / Spell Damage
        if( event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" )then
            local _, _, _, _, overkill, _, _, _, _, _, _, _ = select(12, ...);
            if( overkill >= 0 )then
                KillFeed_Update(sourceGUID, sourceName, destGUID, destName);
            end
        end
        -- Melee Damage
        if( event == "SWING_DAMAGE" )then
            local _, overkill = select(12, ... );
            if( overkill >= 0 )then
                KillFeed_Update(sourceGUID, sourceName, destGUID, destName);
            end
        end
    end

    -- Hide Objective Tracker in PvP
    if(instanceType == "pvp" or instanceType == "arena") then
        if(Conf_ObjectiveTracker) then
            if(not ObjectiveTrackerFrame.collapsed) then
                ObjectiveTracker_Collapse();
            end
        end
    end

    -- Clear the kill feed between instance transitions / ui reload
    if( event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_ENTERING_BATTLEGROUND") then
        if(Conf_KillFeed) then
            for i = 1, #PvPFrame.killFeed.recentKills do
                PvPFrame.killFeed.recentKills[i] = " ";
                PvPFrame.killFeed.texts[i]:SetText(" ");
            end
        end
    end
end

-- Sets up everything
local function Init()

    BuildOnScreenDisplay();
    BuildKillFeed();

    PvPFrame:SetScript("OnEvent", HandleEvents);
    PvPFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    PvPFrame:RegisterEvent("PLAYER_LOGIN");
    PvPFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
    PvPFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
    PvPFrame:RegisterEvent("ADDON_LOADED");
end

-- Triggered when the BG / Arena queue pops, reposition the buttons
function PVPReadyDialog_Display_Hook(self, index, displayName, isRated, queueType, gameType, role)
    self.enterButton:ClearAllPoints();
    self.enterButton:SetPoint("BOTTOM", self, "BOTTOM", 0, 25);
    self.label:SetPoint("TOP", 0, -22);
    self.leaveButton:Hide();
end

hooksecurefunc("PVPReadyDialog_Display", PVPReadyDialog_Display_Hook);

-- End of file, Initialise
Init();
