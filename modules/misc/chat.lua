--[[
    modules\misc\chat.lua
    Styles the Blizzard Chat frame to better match the rest of the UI.
]]
local addonName, Loc = ...;

local ChatFrame = CreateFrame('Frame', nil, UIParent);

-- Add More Font Sizes
for i = 1, 13 do
    CHAT_FONT_HEIGHTS[i] = i + 10;
end

--[[
	Styles the Blizzard Chat frame to better match the rest of the UI
	Hide B.Net / Social Buttons and Toasts
	Change Edit Box Font
	Remove Screen Clamping
	Style Tabs
	Hide Chat Arrows
	Allow arrow keys in Edit Box
	Position Edit Box
	Change Font

    @ return void
]]
local function StyleChat()
    -- Hide Battle.net Social Button and Toasts
    ChatFrameMenuButton:HookScript('OnShow', ChatFrameMenuButton.Hide);
    ChatFrameMenuButton:Hide();
	local button = QuickJoinToastButton or FriendsMicroButton;
	button:HookScript('OnShow', button.Hide);
	button:Hide();
    BNToastFrame:SetClampedToScreen(true);
    BNToastFrame:SetClampRectInsets(-15,15,15,-15);

    -- Change Edit Box Font
    ChatFontNormal:SetFont(ImpFont, 15, 'THINOUTLINE');
    ChatFontNormal:SetShadowOffset(1,-1);
    ChatFontNormal:SetShadowColor(0,0,0,0.6);

    -- Loop through all Chat Windows
    for i = 1, NUM_CHAT_WINDOWS do
        local Window = _G['ChatFrame'..i]:GetName();
        local name, size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);

        -- Remove Screen Clamping
		_G[Window]:SetClampRectInsets( 0, 0, 0, 0 );
		_G[Window]:SetMinResize( 100, 50 );
        _G[Window]:SetMaxResize( UIParent:GetWidth(), UIParent:GetHeight() );

        -- Style Tab Fonts
        local tab = _G[Window..'Tab'];
        local tabFont = tab:GetFontString();
        tabFont:SetFont(ImpFont, 12, 'THINOUTLINE');
        tabFont:SetShadowOffset( 1, -1 );
        tabFont:SetShadowColor( 0, 0, 0, 0.6 );
        
        --Hide Tab Backgrounds
        _G[Window..'TabLeft']:SetTexture( nil );
        _G[Window..'TabMiddle']:SetTexture( nil );
        _G[Window..'TabRight']:SetTexture( nil );
        _G[Window..'TabSelectedLeft']:SetTexture(nil)
        _G[Window..'TabSelectedMiddle']:SetTexture(nil)
        _G[Window..'TabSelectedRight']:SetTexture(nil)
        tab:SetAlpha( 1.0 );

        -- Stop Chat Arrows Coming Back
		_G[Window..'ButtonFrame']:Hide();
		_G[Window..'ButtonFrame']:HookScript('OnShow', _G[Window..'ButtonFrame'].Hide);

        -- Skin Edit Text Box
        _G[Window..'EditBoxLeft']:Hide();
        _G[Window..'EditBoxMid']:Hide();
        _G[Window..'EditBoxRight']:Hide();

        -- Allow arrow keys in Edit Box
        _G[Window..'EditBox']:SetAltArrowKeyMode(false);

        -- Position Edit Box
        _G[Window..'EditBox']:ClearAllPoints();
        if(Window == 'ChatFrame2') then -- Kind hacky. Fixes positioning of its a combat log entry
			_G[Window..'EditBox']:SetPoint('BOTTOM',_G[Window],'TOP',0,44);
		else
        	_G[Window..'EditBox']:SetPoint('BOTTOM',_G[Window],'TOP',0,22);
		end
        _G[Window..'EditBox']:SetPoint('LEFT',_G[Window],-5,0);
        _G[Window..'EditBox']:SetPoint('RIGHT',_G[Window],10,0);

        -- Change Chat Font
        _G[Window]:SetFont(ImpFont, size, 'THINOUTLINE');
		_G[Window]:SetShadowOffset( 1, -1 );
		_G[Window]:SetShadowColor( 0, 0, 0, 0.6 );
    end
end

--[[
    Trims down a bunch of Blizzard Global Strings

    @ return void
]]
local function OverrideStrings()

    -- Local Player Loot
	CURRENCY_GAINED = '|cffFFFF00+ %s';
	CURRENCY_GAINED_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)';
	CURRENCY_GAINED_MULTIPLE_BONUS = '|cffFFFF00+ %s |cffFFFF00(%d)';
	YOU_LOOT_MONEY = '|cffFFFF00+ %s';
	LOOT_ITEM_SELF = '|cffFFFF00+ %s';
	LOOT_ITEM_SELF_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)';
	LOOT_ITEM_CREATED_SELF = '|cffFFFF00+ %s';
	LOOT_ITEM_CREATED_SELF_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)';
	LOOT_ITEM_BONUS_ROLL_SELF = '|cffFFFF00+ %s';
	LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)';
	LOOT_ITEM_REFUND = '|cffFFFF00+ %s';
	LOOT_ITEM_REFUND_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)';
	LOOT_ITEM_PUSHED_SELF = '|cffFFFF00+ %s';
	LOOT_ITEM_PUSHED_SELF_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)';
	TRADESKILL_LOG_FIRSTPERSON = ''; -- Hidden. Useless Info.
	ERR_QUEST_REWARD_ITEM_S = '|cffFFFF00+ %s';
	ERR_QUEST_REWARD_ITEM_MULT_IS = '|cffFFFF00+ %d |cffFFFF00%s';
	ERR_QUEST_REWARD_MONEY_S = '|cffFFFF00+ %s';
	ERR_QUEST_REWARD_EXP_I = '|cffFFFF00+ %d EXP';

	-- Remote Players Loot
	LOOT_ITEM = '%s |cffFFFF00+ %s';
	LOOT_ITEM_BONUS_ROLL = '%s |cffFFFF00+ %s';
	LOOT_ITEM_BONUS_ROLL_MULTIPLE = '%s |cffFFFF00+ %s |cffFFFF00(%d)';
	LOOT_ITEM_MULTIPLE = '%s |cffFFFF00+ %s |cffFFFF00(%d)';
	LOOT_ITEM_PUSHED = '%s |cffFFFF00+ %s';
	LOOT_ITEM_PUSHED_MULTIPLE = '%s |cffFFFF00+ %s |cffFFFF00(%d)';
	CREATED_ITEM = '%s |cffFFFF00+ %s';
	TRADESKILL_LOG_THIRDPERSON = '%s |cffFFFF00+ %s';
	CREATED_ITEM_MULTIPLE = '%s |cffFFFF00+ %s |cffFFFF00(%d)';

	-- Chat Channels
	CHAT_SAY_GET = '%s ';
	CHAT_YELL_GET = '%s ';
	CHAT_WHISPER_INFORM_GET = 'w to %s ';
	CHAT_WHISPER_GET = 'w from %s ';
	CHAT_BN_WHISPER_INFORM_GET = 'w to %s ';
	CHAT_BN_WHISPER_GET = 'w from %s ';
	CHAT_PARTY_GET = '|Hchannel:PARTY|hp|h %s ';
	CHAT_PARTY_LEADER_GET =  '|Hchannel:PARTY|hpl|h %s ';
	CHAT_PARTY_GUIDE_GET =  '|Hchannel:PARTY|hpg|h %s ';
	CHAT_INSTANCE_CHAT_GET = '|Hchannel:Battleground|hi|h %s: ';
	CHAT_INSTANCE_CHAT_LEADER_GET = '|Hchannel:Battleground|hil|h %s: ';
	CHAT_GUILD_GET = '|Hchannel:GUILD|hg|h %s ';
	CHAT_OFFICER_GET = '|Hchannel:OFFICER|ho|h %s ';
	CHAT_FLAG_AFK = '[AFK] ';
	CHAT_FLAG_DND = '[DND] ';
	CHAT_FLAG_GM = '[GM] ';

	-- Skill Ups
	ERR_SKILL_UP_SI = '|cffFFFF00+ |cff00FFFF%s Skill |cffFFFF00(%d)';
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if (event == 'ADDON_LOADED' or event == 'PLAYER_ENTERING_WORLD' or evemt == 'PLAYER_LOGIN') then
        if (PrimaryDB.styleChat) then
            StyleChat();
        end

        if (PrimaryDB.overrideBlizzardStrings) then
            OverrideStrings();
		end
	end
end

-- Register the Modules Events
ChatFrame:SetScript('OnEvent', HandleEvents);
ChatFrame:RegisterEvent('ADDON_LOADED');
ChatFrame:RegisterEvent('PLAYER_ENTERING_WORLD');
ChatFrame:RegisterEvent('PLAYER_LOGIN');