--[[
    modules\frames\killfeed.lua
    Displays a feed of kills in the top left showing who has been killed and by what.
]]
local addonName, Loc = ...;

KillFeedFrame = CreateFrame("Frame", nil, UIParent );
KillFeedFrame:SetFrameStrata("HIGH");
KillFeedFrame:SetWidth(256);
KillFeedFrame:SetHeight(128);
KillFeedFrame.texts = { }; -- Table for Kill Texts
KillFeedFrame.recentKills = { " ", " ", " ", " ", " " }

for i = 1, #KillFeedFrame.recentKills do
    KillFeedFrame.texts[i] = KillFeedFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal" )
    KillFeedFrame.texts[i]:SetFont( ImpFont, 17, "OUTLINE" );
    KillFeedFrame.texts[i]:SetPoint("TOPLEFT", 0, -(26 * i) );
    KillFeedFrame.texts[i]:SetWordWrap( false );
end

KillFeedFrame:SetPoint( "TOPLEFT", 15, 15 );

local fadeTimer;
KillFeedFrame.hidden = true;

-- Initialise the fadein / out anims
KillFeedFrame.fadeInAnim = KillFeedFrame:CreateAnimationGroup();
KillFeedFrame.fadeIn = KillFeedFrame.fadeInAnim:CreateAnimation('Alpha');
KillFeedFrame.fadeIn:SetDuration(1.0);
KillFeedFrame.fadeIn:SetFromAlpha(0);
KillFeedFrame.fadeIn:SetToAlpha(1);
KillFeedFrame.fadeIn:SetOrder(1);

KillFeedFrame.fadeInAnim:SetScript('OnFinished', function() 
    KillFeedFrame:SetAlpha(1);
    KillFeedFrame.hidden = false;
end);

KillFeedFrame.fadeOutAnim = KillFeedFrame:CreateAnimationGroup();
KillFeedFrame.fadeOut = KillFeedFrame.fadeOutAnim:CreateAnimation('Alpha');
KillFeedFrame.fadeOut:SetDuration(1.0);
KillFeedFrame.fadeOut:SetFromAlpha(1);
KillFeedFrame.fadeOut:SetToAlpha(0);
KillFeedFrame.fadeOut:SetOrder(1);

KillFeedFrame.fadeOutAnim:SetScript('OnFinished', function() 
    KillFeedFrame:SetAlpha(0);
    KillFeedFrame.hidden = true;
    KillFeedFrame.recentKills = { " ", " ", " ", " ", " " };
end);

local lastGUID;

-- Writes a Kill Feed message. Works out factions and colours text appropriately
local function KillFeed_Update(sourceGUID, sourceName, destGUID, destName, spellName, amount)
    local playerFaction, _ = UnitFactionGroup( "player" );
    local killerString, killedString, killerFaction, killedFaction;

    if (sourceName == nil or destName == nil) then return end

    -- Stop repeat events occuring for different spells but the same enemy.
    if (lastGUID == nil) then
        lastGUID = destGUID;
    else
        if (lastGUID == destGUID) then
            return
        else
            lastGUID = destGUID;
        end
    end

    -- Work out who killed someone and what faction
    if (UnitIsPlayer(sourceName)) then
        killerFaction, _ = UnitFactionGroup( sourceName );
    else
        if (playerFaction == 'Horde') then
            killerFaction = 'Alliance';
        else
            killerFaction = 'Horde';
        end
    end
    

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

    -- Drop down each kill
    for i = #KillFeedFrame.recentKills, 1, -1 do
        KillFeedFrame.recentKills[i] = KillFeedFrame.recentKills[i - 1];
    end

    if (FramesDB.showSpell and spellName ~= nil) then
        spellString = format(" %s |cff69CCF0%s|r", Loc['with'], spellName);
    else
        spellString = format(" %s |cff69CCF0%s|r", Loc['with'], Loc['Melee']);
    end

    if (FramesDB.showDamage and amount ~= nil) then
        damageString = format(" (%s)", Imp.formatNum(amount));
    else
        damageString = '';
    end

    -- Set Newest Kill
    KillFeedFrame.recentKills[1] = format("%s%s%s%s%s", killerString, Loc[" killed "], killedString, spellString, damageString);

    -- Display Messages
    for i = 1, #KillFeedFrame.recentKills do
        KillFeedFrame.texts[i]:SetText( KillFeedFrame.recentKills[i] );
        KillFeedFrame.texts[i]:SetPoint("TOPLEFT", 0, -(26 * i) );
    end

    if (KillFeedFrame.hidden) then
        KillFeedFrame.fadeInAnim:Play();
    end

    if ( fadeTimer ~= nil ) then
        fadeTimer:Cancel();
        KillFeedFrame:SetAlpha(1);
        KillFeedFrame.hidden = false;
    end

    -- Set Fade Timer
    fadeTimer = C_Timer.NewTimer(7.5, function()
        if (FramesDB.inactiveFade) then
            KillFeedFrame.fadeOutAnim:Play();
        end
    end);
end


--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)

    -- Quit out of Disabled
    if (FramesDB.killFeed == false) then return end

    if (event == 'ADDON_LOADED' and ... == 'ImprovedBlizzardUI') then
        for i = 1, #KillFeedFrame.recentKills do
            KillFeedFrame.texts[i]:SetFont( ImpFont, FramesDB.fontSize, "OUTLINE" );
        end
    end

    -- Clear the kill feed between instance transitions / ui reload
    if(event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_BATTLEGROUND") then
        for i = 1, #KillFeedFrame.recentKills do
            KillFeedFrame.recentKills[i] = " ";
            KillFeedFrame.texts[i]:SetText(" ");
        end
    end

    if (event == "COMBAT_LOG_EVENT_UNFILTERED") then

        local _, instanceType = IsInInstance();

        -- Bail out based on config options
        if (instanceType == 'none' and FramesDB.showInWorld == false) then return end
        if (instanceType == 'party' and FramesDB.showInDungeons == false) then return end
        if (instanceType == 'raid' and FramesDB.showInRaids == false) then return end
        if ((instanceType == 'pvp' or instanceType == 'arena') and FramesDB.showInPvP == false) then return end

        local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _, _, _, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo();

        -- Check for kills and update the Kill Feed
        if( event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" )then
            _, _, _, _, _, _, _, _, _, _, _, _, spellName, _, amount, overkill, _, _, _, _, _ = CombatLogGetCurrentEventInfo();

            if (overkill >= 0) then
                KillFeed_Update(sourceGUID, sourceName, destGUID, destName, spellName, amount);
            end
        end
        
        -- Melee Damage
        if( event == "SWING_DAMAGE" )then
            _, _, _, _, _, _, _, _, _, _, _, amount, overkill, _, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo();

            if (overkill >= 0) then
                KillFeed_Update(sourceGUID, sourceName, destGUID, destName, nil, amount);
            end
        end
    end
end

-- Register the Modules Events
KillFeedFrame:SetScript('OnEvent', HandleEvents);
KillFeedFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
KillFeedFrame:RegisterEvent("PLAYER_LOGIN");
KillFeedFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
KillFeedFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
KillFeedFrame:RegisterEvent("ADDON_LOADED");