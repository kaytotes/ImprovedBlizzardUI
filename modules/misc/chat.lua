--[[
    modules\misc\chat.lua
    Styles the Blizzard Chat frame to better match the rest of the UI.
]]
ImpUI_Chat = ImpUI:NewModule('ImpUI_Chat', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

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
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Chat:OnInitialize()
    ImpUI_Chat:BackupBlizzardStrings();

    -- Add More Font Sizes
    for i = 1, 13 do
        CHAT_FONT_HEIGHTS[i] = i + 10;
    end
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Chat:OnEnable()
    ImpUI_Chat:OverrideStrings();
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Chat:OnDisable()
end