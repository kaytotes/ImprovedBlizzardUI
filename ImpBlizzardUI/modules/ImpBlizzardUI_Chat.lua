--[[
    ImpBlizzardUI/modules/ImpBlizzardUI_Chat
    Handles and modifies chat related features
    Current Features: Truncates a bunch of Global Strings (Loot Gained, Chat Channels etc), changes font styling, tab backgrounds hidden, edit box skinned, chat boxes placeable anywhere, unneccesary buttons removed, added more font sizes
]]
local ChatFrame = CreateFrame("Frame", nil, UIParent);

local FontSize = 15;

local Font = "Interface\\AddOns\\ImpBlizzardUI\\media\\impfont.ttf";

-- Overrides a bunch of Blizzard strings
local function OverrideGlobalStrings()
    -- Local Player Loot
	CURRENCY_GAINED = "|cffFFFF00+ %s";
	CURRENCY_GAINED_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	CURRENCY_GAINED_MULTIPLE_BONUS = "|cffFFFF00+ %s |cffFFFF00(%d)";
	YOU_LOOT_MONEY = "|cffFFFF00+ %s";
	LOOT_ITEM_SELF = "|cffFFFF00+ %s";
	LOOT_ITEM_SELF_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_CREATED_SELF = "|cffFFFF00+ %s";
	LOOT_ITEM_CREATED_SELF_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_BONUS_ROLL_SELF = "|cffFFFF00+ %s";
	LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_REFUND = "|cffFFFF00+ %s";
	LOOT_ITEM_REFUND_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_PUSHED_SELF = "|cffFFFF00+ %s";
	LOOT_ITEM_PUSHED_SELF_MULTIPLE = "|cffFFFF00+ %s |cffFFFF00(%d)";
	TRADESKILL_LOG_FIRSTPERSON = ""; -- Hidden. Useless Info.
	ERR_QUEST_REWARD_ITEM_S = "|cffFFFF00+ %s";
	--ERR_QUEST_REWARD_ITEM_MULT_IS = "Received %d of item: %s.";
	ERR_QUEST_REWARD_ITEM_MULT_IS = "|cffFFFF00+ %d |cffFFFF00%s";
	ERR_QUEST_REWARD_MONEY_S = "|cffFFFF00+ %s";
	ERR_QUEST_REWARD_EXP_I = "|cffFFFF00+ %d EXP";

	-- Remote Players Loot
	LOOT_ITEM = "%s |cffFFFF00+ %s";
	LOOT_ITEM_BONUS_ROLL = "%s |cffFFFF00+ %s";
	LOOT_ITEM_BONUS_ROLL_MULTIPLE = "%s |cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_MULTIPLE = "%s |cffFFFF00+ %s |cffFFFF00(%d)";
	LOOT_ITEM_PUSHED = "%s |cffFFFF00+ %s";
	LOOT_ITEM_PUSHED_MULTIPLE = "%s |cffFFFF00+ %s |cffFFFF00(%d)";
	CREATED_ITEM = "%s |cffFFFF00+ %s";
	CREATED_ITEM_MULTIPLE = "%s |cffFFFF00+ %s |cffFFFF00(%d)";

	-- Chat Channels
	CHAT_SAY_GET = "%s ";
	CHAT_YELL_GET = "%s ";
	CHAT_WHISPER_INFORM_GET = "w to %s ";
	CHAT_WHISPER_GET = "w from %s ";
	CHAT_BN_WHISPER_INFORM_GET = "w to %s ";
	CHAT_BN_WHISPER_GET = "w from %s ";
	CHAT_PARTY_GET = "|Hchannel:PARTY|hp|h %s ";
	CHAT_PARTY_LEADER_GET =  "|Hchannel:PARTY|hpl|h %s ";
	CHAT_PARTY_GUIDE_GET =  "|Hchannel:PARTY|hpg|h %s ";
	CHAT_INSTANCE_CHAT_GET = "|Hchannel:Battleground|hi|h %s: ";
	CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hil|h %s: ";
	CHAT_GUILD_GET = "|Hchannel:GUILD|hg|h %s ";
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|ho|h %s ";
	CHAT_FLAG_AFK = "[AFK] ";
	CHAT_FLAG_DND = "[DND] ";
	CHAT_FLAG_GM = "[GM] ";

	-- Skill Ups
	ERR_SKILL_UP_SI = "|cffFFFF00+ |cff00FFFF%s Skill |cffFFFF00(%d)";
end

-- Removes the screen clamp for chat windows
local function FixBounds()
	-- Loop Through Chat Windows
	for i = 1, NUM_CHAT_WINDOWS do
		-- Allow Moving Anywhere
		_G["ChatFrame"..i]:SetClampRectInsets( 0, 0, 0, 0 );
		_G["ChatFrame"..i]:SetMinResize( 100, 50 );
		_G["ChatFrame"..i]:SetMaxResize( UIParent:GetWidth(), UIParent:GetHeight() );
	end
end

local function BuildChat()
    -- Add More Font Sizes
    for i = 1, 13 do
        CHAT_FONT_HEIGHTS[i] = i + 7;
    end

    -- Hide Buttons
    ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide);
    ChatFrameMenuButton:Hide();
	local button = QuickJoinToastButton or FriendsMicroButton;
	button:HookScript("OnShow", button.Hide);
	button:Hide();
    BNToastFrame:SetClampedToScreen(true);
    BNToastFrame:SetClampRectInsets(-15,15,15,-15);

      --Edit Box Font
    ChatFontNormal:SetFont(Font, FontSize, "THINOUTLINE");
    ChatFontNormal:SetShadowOffset(1,-1);
    ChatFontNormal:SetShadowColor(0,0,0,0.6);

    -- Loop Through Chat Windows
    for i = 1, NUM_CHAT_WINDOWS do
        local chatWindowName = _G["ChatFrame"..i]:GetName();
		local name, size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);

        FixBounds();

        -- Change Chat Tabs
        local chatTab = _G[chatWindowName.."Tab"];
        local tabFont = chatTab:GetFontString();
        tabFont:SetFont(Font, 12, "THINOUTLINE");
        tabFont:SetShadowOffset( 1, -1 );
        tabFont:SetShadowColor( 0, 0, 0, 0.6 );

        --Hide Tab Backgrounds
        _G[chatWindowName.."TabLeft"]:SetTexture( nil );
        _G[chatWindowName.."TabMiddle"]:SetTexture( nil );
        _G[chatWindowName.."TabRight"]:SetTexture( nil );
        _G[chatWindowName.."TabSelectedLeft"]:SetTexture(nil)
        _G[chatWindowName.."TabSelectedMiddle"]:SetTexture(nil)
        _G[chatWindowName.."TabSelectedRight"]:SetTexture(nil)
        chatTab:SetAlpha( 1.0 );

        -- Stop Chat Arrows Coming Back
		if(Conf_ChatArrows) then
			_G[chatWindowName.."ButtonFrame"]:Hide();
			_G[chatWindowName.."ButtonFrame"]:HookScript("OnShow", _G[chatWindowName.."ButtonFrame"].Hide);
		end

        -- Skin Edit Text Box
        _G[chatWindowName.."EditBoxLeft"]:Hide();
        _G[chatWindowName.."EditBoxMid"]:Hide();
        _G[chatWindowName.."EditBoxRight"]:Hide();

        _G[chatWindowName.."EditBox"]:SetAltArrowKeyMode(false);
        _G[chatWindowName.."EditBox"]:ClearAllPoints();
		if(chatWindowName == "ChatFrame2") then -- Kind hacky. Fixes positioning of its a combat log entry
			_G[chatWindowName.."EditBox"]:SetPoint("BOTTOM",_G["ChatFrame"..i],"TOP",0,44);
		else
        	_G[chatWindowName.."EditBox"]:SetPoint("BOTTOM",_G["ChatFrame"..i],"TOP",0,22);
		end
        _G[chatWindowName.."EditBox"]:SetPoint("LEFT",_G["ChatFrame"..i],-5,0);
        _G[chatWindowName.."EditBox"]:SetPoint("RIGHT",_G["ChatFrame"..i],10,0);

		-- Change Chat Text
		_G["ChatFrame"..i]:SetFont(Font, size, "THINOUTLINE");
		_G["ChatFrame"..i]:SetShadowOffset( 1, -1 );
		_G["ChatFrame"..i]:SetShadowColor( 0, 0, 0, 0.6 );
    end
end

local function HandleEvents(self, event, ...)
    if(event == "PLAYER_LOGIN") then
		FixBounds();
    end

	if(event == "ADDON_LOADED") then
		if(Conf_StyleChat) then
			BuildChat();
		end

		if(Conf_MinifyGlobals) then
			OverrideGlobalStrings();
		end
	end
end

local function Init()
    ChatFrame:SetScript("OnEvent", HandleEvents);
    ChatFrame:RegisterEvent("ADDON_LOADED");
end

-- End of file, call Init
Init();
