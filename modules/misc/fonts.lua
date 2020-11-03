--[[
    modules\misc\fonts.lua
    Basically overrides a crapload of UI fonts to the 'Primary' UI font set in config.

    This code is a mixture of my own, Phanx, Tekkub and gmFonts.

    Seriously, literally zero credit to me for finding all these font definitions.
]]
ImpUI_Fonts = ImpUI:NewModule('ImpUI_Fonts', 'AceEvent-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Variables
local OSD;

-- Local Functions

--[[
	Updates a font object and forces it to the specified parameters.
	
    @ return void
]]
local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)	
	if (obj == nil) then return end
	
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

--[[
	Goes through and actually updates as many Blizzard fonts as I'm aware of.
	
    @ return void
]]
local function UpdateFonts()
    local primaryFont = LSM:Fetch('font', ImpUI.db.profile.primaryInterfaceFont);

    UNIT_NAME_FONT     = primaryFont;
	DAMAGE_TEXT_FONT   = primaryFont;
	STANDARD_TEXT_FONT = primaryFont;
    NAMEPLATE_FONT     = primaryFont;
    
    SetFont(AchievementFont_Small,              primaryFont, 11);
	SetFont(FriendsFont_Large,                  primaryFont, 14, nil, nil, nil, nil, 0, 0, 0, 1, -1);
	SetFont(FriendsFont_Normal,                 primaryFont, 12, nil, nil, nil, nil, 0, 0, 0, 1, -1);
	SetFont(FriendsFont_Small,                  primaryFont, 10, nil, nil, nil, nil, 0, 0, 0, 1, -1);
	SetFont(FriendsFont_UserText,               primaryFont, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1);
	SetFont(GameTooltipHeader,                  primaryFont, 14, 'OUTLINE');
	SetFont(GameFont_Gigantic,                  primaryFont, 31, nil, nil, nil, nil, 0, 0, 0, 1, -1);
	SetFont(GameNormalNumberFont,               primaryFont, 10);
	SetFont(InvoiceFont_Med,                    primaryFont, 12, nil, 0.15, 0.09, 0.04);
	SetFont(InvoiceFont_Small,                  primaryFont, 10, nil, 0.15, 0.09, 0.04);
	SetFont(MailFont_Large,                     primaryFont, 14, nil, 0.15, 0.09, 0.04, 0.54, 0.4, 0.1, 1, -1);
	SetFont(NumberFont_OutlineThick_Mono_Small, primaryFont, 12, 'OUTLINE');
	SetFont(NumberFont_Outline_Huge,            primaryFont, 29, 'THICKOUTLINE', 30);
	SetFont(NumberFont_Outline_Large,           primaryFont, 16, 'OUTLINE');
	SetFont(NumberFont_Outline_Med,             primaryFont, 14, 'OUTLINE');
	SetFont(NumberFont_Shadow_Med,              primaryFont, 13);
	SetFont(NumberFont_Shadow_Small,            primaryFont, 11);
	SetFont(QuestFont_Shadow_Small,             primaryFont, 15);
	SetFont(QuestFont_Large,                    primaryFont, 15);
	SetFont(QuestFont_Shadow_Huge,              primaryFont, 18, nil, nil, nil, nil, 0.54, 0.4, 0.1);
	SetFont(QuestFont_Super_Huge,               primaryFont, 23);
	SetFont(ReputationDetailFont,               primaryFont, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1);
	SetFont(SpellFont_Small,                    primaryFont, 10);
	SetFont(SystemFont_InverseShadow_Small,     primaryFont, 10);
	SetFont(SystemFont_Large,                   primaryFont, 16);
	SetFont(SystemFont_Med1,                    primaryFont, 12);
	SetFont(SystemFont_Med2,                    primaryFont, 13, nil, 0.15, 0.09, 0.04);
	SetFont(SystemFont_Med3,                    primaryFont, 14);
	SetFont(SystemFont_OutlineThick_Huge2,      primaryFont, 21, 'THICKOUTLINE');
	SetFont(SystemFont_OutlineThick_Huge4,      primaryFont, 26, 'THICKOUTLINE');
	SetFont(SystemFont_OutlineThick_WTF,    	primaryFont, 30, 'THICKOUTLINE', nil, nil, nil, 0, 0, 0, 1, -1);
	SetFont(SystemFont_Outline_Small,           primaryFont, 12, 'OUTLINE');
	SetFont(SystemFont_Shadow_Huge1,            primaryFont, 19);
	SetFont(SystemFont_Shadow_Huge3,            primaryFont, 24);
	SetFont(SystemFont_Shadow_Large,            primaryFont, 16);
	SetFont(SystemFont_Shadow_Med1,             primaryFont, 12);
	SetFont(SystemFont_Shadow_Med2,             primaryFont, 13);
	SetFont(SystemFont_Shadow_Med3,             primaryFont, 14);
	SetFont(SystemFont_Shadow_Outline_Huge2,    primaryFont, 21, 'OUTLINE');
	SetFont(SystemFont_Shadow_Small,            primaryFont, 10);
	SetFont(SystemFont_Small,                   primaryFont, 11);
	SetFont(SystemFont_Tiny,                    primaryFont, 10);
	SetFont(Tooltip_Med,                        primaryFont, 12);
	SetFont(Tooltip_Small,                      primaryFont, 11);
	SetFont(WhiteNormalNumberFont,              primaryFont, 10);
	SetFont(BossEmoteNormalHuge,     			primaryFont, 26, 'THICKOUTLINE');
	SetFont(CombatTextFont,          			primaryFont, 25);
	SetFont(ErrorFont,               			primaryFont, 15, nil, 60);
	SetFont(QuestFontNormalSmall,    			primaryFont, 12, nil, nil, nil, nil, 0.54, 0.4, 0.1);
	SetFont(WorldMapTextFont,        			primaryFont, 30, 'THICKOUTLINE',  40, nil, nil, 0, 0, 0, 1, -1);
	SetFont(ChatBubbleFont,                     primaryFont, 12);
	SetFont(CoreAbilityFont,					primaryFont, 31);
	SetFont(DestinyFontHuge,                    primaryFont, 31);
	SetFont(DestinyFontLarge,                   primaryFont, 17);
	SetFont(Game18Font,                         primaryFont, 17);
	SetFont(Game24Font,                         primaryFont, 23);
	SetFont(Game27Font,                         primaryFont, 26);
	SetFont(Game30Font,                         primaryFont, 29);
	SetFont(Game32Font,                         primaryFont, 31);
	SetFont(NumberFont_GameNormal,              primaryFont, 9);
	SetFont(NumberFont_Normal_Med,              primaryFont, 13);
	SetFont(NumberFont_GameNormal,              primaryFont, 12);
	SetFont(QuestFont_Enormous,                 primaryFont, 29);
	SetFont(QuestFont_Huge,                     primaryFont, 18);
	SetFont(QuestFont_Super_Huge_Outline,       primaryFont, 23, 'OUTLINE');
	SetFont(SplashHeaderFont,                   primaryFont, 23);
	SetFont(SystemFont_Huge1,                   primaryFont, 19);
	SetFont(SystemFont_Huge1_Outline,           primaryFont, 19, 'OUTLINE');
	SetFont(SystemFont_Outline,                 primaryFont, 12, 'OUTLINE');
	SetFont(SystemFont_Shadow_Huge2,       		primaryFont, 23);
	SetFont(SystemFont_Shadow_Large2,           primaryFont, 18);
	SetFont(SystemFont_Shadow_Large_Outline,    primaryFont, 16, 'OUTLINE');
	SetFont(SystemFont_Shadow_Med1_Outline,     primaryFont, 11, 'OUTLINE');
	SetFont(SystemFont_Shadow_Small2,           primaryFont, 10);
    SetFont(SystemFont_Small2,                  primaryFont, 11);
	
	if (Helpers.IsRetail()) then
		for _,butt in pairs(PaperDollTitlesPane.buttons) do butt.text:SetFontObject(GameFontHighlightSmallLeft); end
	end
end

--[[
	Fires when the Primary Interface Font config option changes.
	
    @ return void
]]
function ImpUI_Fonts:PrimaryFontUpdated()
    local warning = L['A /reload may be required after updating the primary font!'];

    ImpUI:Print(warning);

    OSD:AddMessage( warning, ImpUI.db.profile.primaryInterfaceFont, 22, 1, 1, 0, 5.0 );

    UpdateFonts();
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Fonts:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Fonts:OnEnable()
    OSD = ImpUI:GetModule('ImpUI_OSD');

    UpdateFonts();
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Fonts:OnDisable()
end