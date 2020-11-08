--[[
    modules\misc\chat.lua
    Styles the Blizzard Chat frame to better match the rest of the UI.
]]
ImpUI_Chat = ImpUI:NewModule('ImpUI_Chat', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local GetChatWindowInfo = GetChatWindowInfo;

-- The Global strings we're replacing and what they're being replaced with.
local strings = {
    -- Local Player Loot
	CURRENCY_GAINED = '|cffFFFF00+ %s',
	CURRENCY_GAINED_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)',
	CURRENCY_GAINED_MULTIPLE_BONUS = '|cffFFFF00+ %s |cffFFFF00(%d)',
	YOU_LOOT_MONEY = '|cffFFFF00+ %s',
	LOOT_ITEM_SELF = '|cffFFFF00+ %s',
	LOOT_ITEM_SELF_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)',
	LOOT_ITEM_CREATED_SELF = '|cffFFFF00+ %s',
	LOOT_ITEM_CREATED_SELF_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)',
	LOOT_ITEM_BONUS_ROLL_SELF = '|cffFFFF00+ %s',
	LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)',
	LOOT_ITEM_REFUND = '|cffFFFF00+ %s',
	LOOT_ITEM_REFUND_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)',
	LOOT_ITEM_PUSHED_SELF = '|cffFFFF00+ %s',
	LOOT_ITEM_PUSHED_SELF_MULTIPLE = '|cffFFFF00+ %s |cffFFFF00(%d)',
	TRADESKILL_LOG_FIRSTPERSON = '', -- Hidden. Useless Info.
	ERR_QUEST_REWARD_ITEM_S = '|cffFFFF00+ %s',
	ERR_QUEST_REWARD_ITEM_MULT_IS = '|cffFFFF00+ %d |cffFFFF00%s',
	ERR_QUEST_REWARD_MONEY_S = '|cffFFFF00+ %s',
	ERR_QUEST_REWARD_EXP_I = '|cffFFFF00+ %d EXP',

	-- Remote Players Loot
	LOOT_ITEM = '%s |cffFFFF00+ %s',
	LOOT_ITEM_BONUS_ROLL = '%s |cffFFFF00+ %s',
	LOOT_ITEM_BONUS_ROLL_MULTIPLE = '%s |cffFFFF00+ %s |cffFFFF00(%d)',
	LOOT_ITEM_MULTIPLE = '%s |cffFFFF00+ %s |cffFFFF00(%d)',
	LOOT_ITEM_PUSHED = '%s |cffFFFF00+ %s',
	LOOT_ITEM_PUSHED_MULTIPLE = '%s |cffFFFF00+ %s |cffFFFF00(%d)',
	CREATED_ITEM = '%s |cffFFFF00+ %s',
	TRADESKILL_LOG_THIRDPERSON = '%s |cffFFFF00+ %s',
	CREATED_ITEM_MULTIPLE = '%s |cffFFFF00+ %s |cffFFFF00(%d)',

	-- Chat Channels
	CHAT_SAY_GET = '%s ',
	CHAT_YELL_GET = '%s ',
	CHAT_WHISPER_INFORM_GET = 'w to %s ',
	CHAT_WHISPER_GET = 'w from %s ',
	CHAT_BN_WHISPER_INFORM_GET = 'w to %s ',
	CHAT_BN_WHISPER_GET = 'w from %s ',
	CHAT_PARTY_GET = '|Hchannel:PARTY|hp|h %s ',
	CHAT_PARTY_LEADER_GET =  '|Hchannel:PARTY|hpl|h %s ',
	CHAT_PARTY_GUIDE_GET =  '|Hchannel:PARTY|hpg|h %s ',
	CHAT_INSTANCE_CHAT_GET = '|Hchannel:Battleground|hi|h %s: ',
	CHAT_INSTANCE_CHAT_LEADER_GET = '|Hchannel:Battleground|hil|h %s: ',
	CHAT_GUILD_GET = '|Hchannel:GUILD|hg|h %s ',
	CHAT_OFFICER_GET = '|Hchannel:OFFICER|ho|h %s ',
	CHAT_FLAG_AFK = '[AFK] ',
	CHAT_FLAG_DND = '[DND] ',
	CHAT_FLAG_GM = '[GM] ',

	-- Skill Ups
	ERR_SKILL_UP_SI = '|cffFFFF00+ |cff00FFFF%s Skill |cffFFFF00(%d)',
};

-- Backup of Blizzard Global Strings.
local backup = {};

--[[
	Restore from the Blizzard strings backup.
	
    @ return void
]]
function ImpUI_Chat:RestoreStrings()
    -- Loop through strings and do the replacement
    for string, replacement in pairs(backup) do
        _G[string] = replacement;
    end
end

--[[
	Override the global strings with the new ones.
	
    @ return void
]]
function ImpUI_Chat:OverrideStrings()
    -- Loop through strings and do the replacement
    for string, replacement in pairs(strings) do
        _G[string] = replacement;
    end
end

--[[
	Makes a backup of the original global Blizzard strings.
	
    @ return void
]]
function ImpUI_Chat:BackupBlizzardStrings()
    -- Loop through strings and make a backup.
    for string, replacement in pairs(strings) do
        backup[string] = _G[string];
    end
end

--[[
	Resets the Chat to essentially the default blizzard.
	
    @ return void
]]
function ImpUI_Chat:ResetChat()
    -- Restore Edit Box Font
    ChatFontNormal:SetFont(LSM:Fetch('font', 'Arial Narrow'), 12);

    -- Restore Chat Channel Button
    if (ImpUI_Chat:IsHooked(ChatFrameMenuButton, 'OnShow')) then
        ImpUI_Chat:Unhook(ChatFrameMenuButton, 'OnShow');
        ChatFrameMenuButton:Show();
    end

    -- Restore ChatFrameChannelButton
    if (ImpUI_Chat:IsHooked(ChatFrameChannelButton, 'OnShow')) then
        ImpUI_Chat:Unhook(ChatFrameChannelButton, 'OnShow');
        ChatFrameChannelButton:Show();
    end

    -- Restore Battle.net / Social Button
	local button = QuickJoinToastButton or FriendsMicroButton;
    if (ImpUI_Chat:IsHooked(button, 'OnShow')) then
        ImpUI_Chat:Unhook(button, 'OnShow');
        button:Show();
    end
    
    -- Restore Battle.net Toast
    BNToastFrame:SetClampedToScreen(false);

    for i = 1, NUM_CHAT_WINDOWS do
        local window = _G['ChatFrame'..i]:GetName();
        local name, size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);

        -- Restore Chat Arrows
        if (ImpUI_Chat:IsHooked(_G[window..'ButtonFrame'], 'OnShow')) then
            ImpUI_Chat:Unhook(_G[window..'ButtonFrame'], 'OnShow');
            _G[window..'ButtonFrame']:Show();
        end

        -- Restore Tab Fonts
        local tab = _G[window..'Tab'];
        local tabFont = tab:GetFontString();
        tabFont:SetFont(LSM:Fetch('font', 'Friz Quadrata'), 10);
        tabFont:SetShadowOffset( 1, -1 );
        tabFont:SetShadowColor( 0, 0, 0, 0.99 );

        -- Restore Tab Backgrounds
        _G[window..'TabLeft']:SetTexture('Interface\\ChatFrame\\ChatFrameTab-BGLeft');
        _G[window..'TabMiddle']:SetTexture('Interface\\ChatFrame\\ChatFrameTab-BGMid');
        _G[window..'TabRight']:SetTexture('Interface\\ChatFrame\\ChatFrameTab-BGRight');
        _G[window..'TabSelectedLeft']:SetTexture('Interface\\ChatFrame\\ChatFrameTab-SelectedLeft');
        _G[window..'TabSelectedMiddle']:SetTexture('Interface\\ChatFrame\\ChatFrameTab-SelectedMid');
        _G[window..'TabSelectedRight']:SetTexture('Interface\\ChatFrame\\ChatFrameTab-SelectedRight');
        tab:SetAlpha( 1.0 );

        -- Restore Edit Box Textures
        _G[window..'EditBoxLeft']:Show();
        _G[window..'EditBoxMid']:Show();
        _G[window..'EditBoxRight']:Show();

        -- Reposition Edit Box
        _G[window..'EditBox']:ClearAllPoints();
        _G[window..'EditBox']:SetPoint('BOTTOM',_G[window],'BOTTOM',0,-35);
        _G[window..'EditBox']:SetPoint('LEFT',_G[window],-5,0);
		_G[window..'EditBox']:SetPoint('RIGHT',_G[window],10,0);

        -- Reset Chat Font
        _G[window]:SetFont(LSM:Fetch('font', 'Arial Narrow'), size);
        _G[window]:SetShadowOffset( 1, -1 );
        _G[window]:SetShadowColor( 0, 0, 0, 0.99 );
    end
end

--[[
	Handles the bulk of the actual chat styling if it is enabled.
	
    @ return void
]]
function ImpUI_Chat:StyleChat()
    if (ImpUI.db.profile.styleChat == false) then return; end

    local chatFont = LSM:Fetch('font', ImpUI.db.profile.chatFont);

    -- Change Edit Box Font
    ChatFontNormal:SetFont(chatFont, 12, 'THINOUTLINE');
    ChatFontNormal:SetShadowOffset(1,-1);
    ChatFontNormal:SetShadowColor(0,0,0,0.6);

    -- Hide Chat Channels Button
    ImpUI_Chat:HookScript(ChatFrameMenuButton, 'OnShow', ChatFrameMenuButton.Hide);
    ChatFrameMenuButton:Hide();

    -- Hide ChatFrameChannelButton
    ImpUI_Chat:HookScript(ChatFrameChannelButton, 'OnShow', ChatFrameChannelButton.Hide);
    ChatFrameChannelButton:Hide();

    -- Hide Battle.net / Social Button
    if (Helpers.IsRetail()) then
        local button = QuickJoinToastButton or FriendsMicroButton;
        ImpUI_Chat:HookScript(button, 'OnShow', button.Hide);
        button:Hide();
    
        -- Move Battle.net Toast
        BNToastFrame:SetClampedToScreen(true);
        BNToastFrame:SetClampRectInsets(-15,15,15,-15);
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local window = _G['ChatFrame'..i]:GetName();
        local name, size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);

        -- Stop Chat Arrows Coming Back
        ImpUI_Chat:HookScript(_G[window..'ButtonFrame'], 'OnShow', _G[window..'ButtonFrame'].Hide);
		_G[window..'ButtonFrame']:Hide();
        
        -- Style Tab Fonts
        local tab = _G[window..'Tab'];
        local tabFont = tab:GetFontString();

        tabFont:SetFont(chatFont, 12, 'THINOUTLINE');
        tabFont:SetShadowOffset( 1, -1 );
        tabFont:SetShadowColor( 0, 0, 0, 0.6 );

        --Hide Tab Backgrounds
        _G[window..'TabLeft']:SetTexture( nil );
        _G[window..'TabMiddle']:SetTexture( nil );
        _G[window..'TabRight']:SetTexture( nil );
        _G[window..'TabSelectedLeft']:SetTexture(nil);
        _G[window..'TabSelectedMiddle']:SetTexture(nil);
        _G[window..'TabSelectedRight']:SetTexture(nil);
        tab:SetAlpha( 1.0 );

        -- Skin Edit Text Box
        _G[window..'EditBoxLeft']:Hide();
        _G[window..'EditBoxMid']:Hide();
        _G[window..'EditBoxRight']:Hide();

        -- Position Edit Box
        _G[window..'EditBox']:ClearAllPoints();

        if(window == 'ChatFrame2') then -- Kind hacky. Fixes positioning of its a combat log entry
			_G[window..'EditBox']:SetPoint('BOTTOM',_G[window],'TOP',0,44);
		else
        	_G[window..'EditBox']:SetPoint('BOTTOM',_G[window],'TOP',0,22);
        end
        
        _G[window..'EditBox']:SetPoint('LEFT',_G[window],-5,0);
		_G[window..'EditBox']:SetPoint('RIGHT',_G[window],10,0);

        -- On new characters this can be 0 somehow, if it is just override it.
		if (size == 0) then
			size = 13;
        end

        -- Change Chat Font
        if (ImpUI.db.profile.outlineChat) then
            _G[window]:SetFont(chatFont, size, 'OUTLINE');
        else
            _G[window]:SetFont(chatFont, size);
        end

        -- Set a shadow. Blizzard used to do this by default but removed it in 7.1 I believe.
        _G[window]:SetShadowOffset( 1, -1 );
        _G[window]:SetShadowColor( 0, 0, 0, 0.6 );
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Chat:OnInitialize()
    ImpUI_Chat:BackupBlizzardStrings();

    -- Add More Font Sizes
    for i = 1, 13 do
        CHAT_FONT_HEIGHTS[i] = i + 10;
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local Window = _G['ChatFrame'..i]:GetName();
        local name, size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);

        -- Remove Screen Clamping
		_G[Window]:SetClampRectInsets( 0, 0, 0, 0 );
		_G[Window]:SetMinResize( 100, 50 );
        _G[Window]:SetMaxResize( UIParent:GetWidth(), UIParent:GetHeight() );
    end
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Chat:OnEnable()
    local minify = ImpUI.db.profile.minifyStrings;
    if (minify == true) then
        ImpUI_Chat:OverrideStrings();    
    end
    ImpUI_Chat:StyleChat();

    -- Apply Quality of Life changes that don't need to be toggled.
    for i = 1, NUM_CHAT_WINDOWS do
        local window = _G['ChatFrame'..i]:GetName();
        local name, size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);

        _G[window]:SetClampRectInsets( 0, 0, 0, 0 );
        _G[window]:SetMinResize( 100, 50 );
        _G[window]:SetMaxResize( UIParent:GetWidth(), UIParent:GetHeight() );

        -- Allow arrow keys in Edit Box
        _G[window..'EditBox']:SetAltArrowKeyMode(false);
    end
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Chat:OnDisable()
end