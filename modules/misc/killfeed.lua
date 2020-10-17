--[[
    modules\misc\killfeed.lua
    Displays a feed of kills showing who has been killed and by what.
]]
ImpUI_Killfeed = ImpUI:NewModule('ImpUI_Killfeed', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local UnitFactionGroup = UnitFactionGroup;
local UnitIsPlayer = UnitIsPlayer;
local format = format;
local IsInInstance = IsInInstance;
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo;

-- Local Variables
local killfeed;
local dragFrame;
local lastGUID;

local hordeColour = 'FE2E2E';
local allianceColour = '2E9AFE';
local neutralColour = '00FF61';

--[[
	Actually handles assigning a colour to text.
	
    @ return void
]]
function ImpUI_Killfeed:ToFactionColour(faction, string)
    if (faction == 'Horde') then
        return format('|cff%s%s|r', hordeColour, string);
    else
        return format('|cff%s%s|r', allianceColour, string);
    end
end

--[[
	Simply provides the opposite faction of the one given in.
	
    @ return void
]]
function ImpUI_Killfeed:GetOppositeFaction(faction)
    if (faction == 'Horde') then
        return 'Alliance';
    else
        return 'Horde';
    end
end

--[[
	Figures out what to colour what and formats the string accordingly.
	
    @ return void
]]
function ImpUI_Killfeed:GetFormattedString(unitGUID, unitName)
    local ours, _ = UnitFactionGroup('player');
    
    if (Helpers.IsPlayerByGUID(unitGUID) == false) then
        return ImpUI_Killfeed:ToFactionColour(ImpUI_Killfeed:GetOppositeFaction(ours), unitName);
    end

    local theirs = Helpers.GetFactionByGUID(unitGUID);

    if (ours == theirs) then
        return ImpUI_Killfeed:ToFactionColour(ours, unitName);
    elseif (theirs == 'Unknown') then
        return format('|cff%s%s|r', neutralColour, unitName);
    else 
        return ImpUI_Killfeed:ToFactionColour(theirs, unitName);
    end
end

--[[
	Actually sends the provided string to the Kill Feed.
	
    @ return void
]]
function ImpUI_Killfeed:SendToKillFeed(string)
    -- Drop down each kill
    for i = #killfeed.recentKills, 1, -1 do
        killfeed.recentKills[i] = killfeed.recentKills[i - 1];
    end

    -- Set Newest Kill
    killfeed.recentKills[1] = string;

    -- Display Messages
    for i = 1, #killfeed.recentKills do
        killfeed.texts[i]:SetText( killfeed.recentKills[i] );
    end

    if (killfeed.hidden) then
        killfeed.fadeInAnim:Play();
    end

    if ( fadeTimer ~= nil ) then
        fadeTimer:Cancel();
        killfeed:SetAlpha(1);
        killfeed.hidden = false;
    end

    -- Set Fade Timer
    fadeTimer = C_Timer.NewTimer(7.5, function()
        local inactiveFade = ImpUI.db.profile.killFeedFadeInactive;
        if (inactiveFade) then
            killfeed.fadeOutAnim:Play();
        end
    end);
end

--[[
	Adds a new entry to the Kill Feed after building the structure from configuration.
	
    @ return void
]]
function ImpUI_Killfeed:UpdateKillFeed(sourceGUID, sourceName, destGUID, destName, spellName, amount)
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

    local killerString = ImpUI_Killfeed:GetFormattedString(sourceGUID, sourceName);
    local killedString = ImpUI_Killfeed:GetFormattedString(destGUID, destName);

    local showSpell = ImpUI.db.profile.killFeedShowSpell;

    if (showSpell and spellName ~= nil) then
        spellString = format(' %s |cff69CCF0%s|r', L['with'], spellName);
    else
        spellString = format(' %s |cff69CCF0%s|r', L['with'], L['Melee']);
    end

    local showDamage = ImpUI.db.profile.killFeedShowDamage;

    if (showDamage and amount ~= nil) then
        damageString = format(' (%s)', Helpers.format_num(amount));
    else
        damageString = '';
    end

    ImpUI_Killfeed:SendToKillFeed(format('%s%s%s%s%s', killerString, L[' killed '], killedString, spellString, damageString));
end

--[[
	Fires on basically any combat log event.
	
    @ return void
]]
function ImpUI_Killfeed:COMBAT_LOG_EVENT_UNFILTERED()    
    local _, instanceType = IsInInstance();

    -- Bail out based on config options
    if (ImpUI.db.profile.killFeed == false) then return; end

    local shouldShow = false;

    -- Figure out if we should show based on config.
    if (instanceType == 'none' and ImpUI.db.profile.killFeedInWorld) then shouldShow = true; end
    if (instanceType == 'party' and ImpUI.db.profile.killFeedInInstance) then shouldShow = true; end
    if (instanceType == 'raid' and ImpUI.db.profile.killFeedInRaid) then shouldShow = true; end
    if((instanceType == 'pvp' or instanceType == 'arena' or (instanceType == 'none' and GetZonePVPInfo() == 'combat')) and ImpUI.db.profile.killFeedInPvP) then shouldShow = true; end

    -- Bail out if it shouldn't be shown in current context.
    if (shouldShow == false) then return; end

    -- Get all the variables we'll need.
    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _, _, _, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo();

    -- Check for kills and update the Kill Feed
    if( event == 'SPELL_DAMAGE' or event == 'SPELL_PERIODIC_DAMAGE' or event == 'RANGE_DAMAGE' )then
        _, _, _, _, _, _, _, _, _, _, _, _, spellName, _, amount, overkill, _, _, _, _, _ = CombatLogGetCurrentEventInfo();

        if (overkill >= 0) then
            ImpUI_Killfeed:UpdateKillFeed(sourceGUID, sourceName, destGUID, destName, spellName, amount);
        end
    end
    
    -- Melee Damage
    if( event == 'SWING_DAMAGE' )then
        _, _, _, _, _, _, _, _, _, _, _, amount, overkill, _, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo();

        if (overkill >= 0) then
            ImpUI_Killfeed:UpdateKillFeed(sourceGUID, sourceName, destGUID, destName, nil, amount);
        end
    end
end

--[[
	Clear out the Kill Feed.
	
    @ return void
]]
function ImpUI_Killfeed:ClearKillFeed()
    for i = 1, #killfeed.recentKills do
        killfeed.recentKills[i] = ' ';
        killfeed.texts[i]:SetText(' ');
    end
end

--[[
	Applies styling configuration to the Kill Feed.
	
    @ return void
]]
function ImpUI_Killfeed:StyleKillFeed()
    local font = ImpUI.db.profile.killFeedFont;
    local size = ImpUI.db.profile.killFeedSize;
    local spacing = ImpUI.db.profile.killFeedSpacing;

    for i = 1, #killfeed.recentKills do
        killfeed.texts[i]:SetFont( LSM:Fetch('font', font), size, 'OUTLINE' );
        killfeed.texts[i]:SetPoint('TOPLEFT', 0, -(spacing * i) );
    end
end

function ImpUI_Killfeed:OutputTestMessages()
    for i = 1, #killfeed.recentKills do
        killfeed.recentKills[i] = L['Test String Output'];
        killfeed.texts[i]:SetText(L['Test String Output']);
    end
end

--[[
	Positions the Kill Feed.
	
    @ return void
]]
function ImpUI_Killfeed:LoadPosition()
    dragFrame:ClearAllPoints();
    dragFrame:SetPoint(ImpUI.db.profile.killFeedPosition.point, ImpUI.db.profile.killFeedPosition.relativeTo, ImpUI.db.profile.killFeedPosition.relativePoint, ImpUI.db.profile.killFeedPosition.x, ImpUI.db.profile.killFeedPosition.y);
end

-- Called when unlocking the UI.
function ImpUI_Killfeed:Unlock()
    dragFrame:Show();

    killfeed:SetParent(dragFrame);

    -- Fill with test data.
    ImpUI_Killfeed:OutputTestMessages();
end

-- Called when Locking the UI.
function ImpUI_Killfeed:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    -- Store Position
    ImpUI.db.profile.killFeedPosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    -- Clear Test Data
    ImpUI_Killfeed:ClearKillFeed();

    killfeed:SetParent(UIParent);

    dragFrame:Hide();
end

--[[
	Fires when the Player Logs In.
	
    @ return void
]]
function ImpUI_Killfeed:PLAYER_LOGIN()
    ImpUI_Killfeed:ClearKillFeed();
end

--[[
	Fires when the Player hits a loading screen / transition.
	
    @ return void
]]
function ImpUI_Killfeed:PLAYER_ENTERING_WORLD()
    ImpUI_Killfeed:ClearKillFeed();
end

--[[
	Fires when the Player enters a BG.
	
    @ return void
]]
function ImpUI_Killfeed:PLAYER_ENTERING_BATTLEGROUND()
    ImpUI_Killfeed:ClearKillFeed();
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Killfeed:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Killfeed:OnEnable()
    -- Create the Kill Feed Frame
    killfeed = CreateFrame('Frame', nil, UIParent );

    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('Imp_KillFeed_DragFrame', 256, 145, L['Kill Feed']);
    killfeed:SetParent(dragFrame);
    killfeed:SetPoint('TOPLEFT', dragFrame, 'TOPLEFT', 10, 15);

    ImpUI_Killfeed:LoadPosition();

    killfeed:SetFrameStrata('HIGH');
    killfeed:SetWidth(256);
    killfeed:SetHeight(128);
    killfeed.texts = { }; -- Table for Kill Texts
    killfeed.recentKills = { ' ', ' ', ' ', ' ', ' ' };
    killfeed.hidden = true;
    killfeed:SetParent(UIParent);

    -- Create Font Strings
    for i = 1, #killfeed.recentKills do
        killfeed.texts[i] = killfeed:CreateFontString(nil, 'OVERLAY', 'GameFontNormal' )
        killfeed.texts[i]:SetWordWrap( false );
    end

    -- Style It
    ImpUI_Killfeed:StyleKillFeed();

    -- Initialise the fadein / out anims
    killfeed.fadeInAnim = killfeed:CreateAnimationGroup();
    killfeed.fadeIn = killfeed.fadeInAnim:CreateAnimation('Alpha');
    killfeed.fadeIn:SetDuration(1.0);
    killfeed.fadeIn:SetFromAlpha(0);
    killfeed.fadeIn:SetToAlpha(1);
    killfeed.fadeIn:SetOrder(1);

    killfeed.fadeInAnim:SetScript('OnFinished', function() 
        killfeed:SetAlpha(1);
        killfeed.hidden = false;
    end);

    killfeed.fadeOutAnim = killfeed:CreateAnimationGroup();
    killfeed.fadeOut = killfeed.fadeOutAnim:CreateAnimation('Alpha');
    killfeed.fadeOut:SetDuration(1.0);
    killfeed.fadeOut:SetFromAlpha(1);
    killfeed.fadeOut:SetToAlpha(0);
    killfeed.fadeOut:SetOrder(1);

    killfeed.fadeOutAnim:SetScript('OnFinished', function() 
        killfeed:SetAlpha(0);
        killfeed.hidden = true;
        killfeed.recentKills = { ' ', ' ', ' ', ' ', ' ' };
    end);

    -- Register Events
    self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');
    self:RegisterEvent('PLAYER_LOGIN');
    self:RegisterEvent('PLAYER_ENTERING_WORLD');
    self:RegisterEvent('PLAYER_ENTERING_BATTLEGROUND');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Killfeed:OnDisable()
end