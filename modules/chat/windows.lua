--[[
    modules\chat\windows.lua
    Styles the Blizzard Chat frame to better match the rest of the UI.
]]
ImpUI_ChatWindows = ImpUI:NewModule('ImpUI_ChatWindows', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local GetChatWindowInfo = GetChatWindowInfo;

function ImpUI_ChatWindows:ChangeTabFonts()
    local chatFont = LSM:Fetch('font', ImpUI.db.profile.chatFont);

    ChatFontNormal:SetFont(chatFont, 12, 'THINOUTLINE');
    ChatFontNormal:SetShadowOffset(1,-1);
    ChatFontNormal:SetShadowColor(0,0,0,0.6);
end

--[[
	Hides the main buttons on the chat frame eg chat channels, social button, battle net button
	
    @ return void
]]
function ImpUI_ChatWindows:HideButtons()
    -- Hide Chat Channels Button
    if (not ImpUI_ChatWindows:IsHooked(ChatFrameMenuButton, 'OnShow')) then
        ImpUI_ChatWindows:HookScript(ChatFrameMenuButton, 'OnShow', ChatFrameMenuButton.Hide);
    end
    ChatFrameMenuButton:Hide();

    -- Hide ChatFrameChannelButton
    if (not ImpUI_ChatWindows:IsHooked(ChatFrameChannelButton, 'OnShow')) then
        ImpUI_ChatWindows:HookScript(ChatFrameChannelButton, 'OnShow', ChatFrameChannelButton.Hide);
    end
    ChatFrameChannelButton:Hide();

    -- Hide Battle.net / Social Button
    if (Helpers.IsRetail()) then
        local button = QuickJoinToastButton or FriendsMicroButton;
        if (not ImpUI_ChatWindows:IsHooked(button, 'OnShow')) then
            ImpUI_ChatWindows:HookScript(button, 'OnShow', button.Hide);
        end
        
        button:Hide();

        -- Move Battle.net Toast
        BNToastFrame:SetClampedToScreen(true);
        BNToastFrame:SetClampRectInsets(-15,15,15,-15);
    end
end

--[[
	Allows us to move chat windows into the corners of the screen within 1px
    Normally the blizzard ui disallows this.
	
    @ return void
]]
function ImpUI_ChatWindows:RemoveScreenClamping(window)
    window:SetClampRectInsets( 0, 0, 0, 0 );
    window:SetMinResize( 100, 50 );
    window:SetMaxResize( UIParent:GetWidth(), UIParent:GetHeight() );
end

--[[
	Removes the chat arrows. Use a scroll wheel yo.
	
    @ return void
]]
function ImpUI_ChatWindows:RemoveChatArrows(window)
    local buttonFrame = _G[window:GetName()..'ButtonFrame'];

    if (not ImpUI_ChatWindows:IsHooked(buttonFrame, 'OnShow')) then
        ImpUI_ChatWindows:HookScript(buttonFrame, 'OnShow', buttonFrame.Hide);
    end
    
    buttonFrame:Hide();
end

--[[
	Restyles the chat tabs by adjusting font and removing textures.
	
    @ return void
]]
function ImpUI_ChatWindows:AdjustTab(window)
    -- Style Tab Fonts
    local tab = _G[window:GetName()..'Tab'];
    local tabFont = tab:GetFontString();
    local chatFont = LSM:Fetch('font', ImpUI.db.profile.chatFont);

    tabFont:SetFont(chatFont, 12, 'THINOUTLINE');
    tabFont:SetShadowOffset( 1, -1 );
    tabFont:SetShadowColor( 0, 0, 0, 0.6 );

    --Hide Tab Backgrounds
    _G[window:GetName()..'TabLeft']:SetTexture( nil );
    _G[window:GetName()..'TabMiddle']:SetTexture( nil );
    _G[window:GetName()..'TabRight']:SetTexture( nil );
    _G[window:GetName()..'TabSelectedLeft']:SetTexture(nil);
    _G[window:GetName()..'TabSelectedMiddle']:SetTexture(nil);
    _G[window:GetName()..'TabSelectedRight']:SetTexture(nil);
    tab:SetAlpha( 1.0 );
end

--[[
	Hides textures for the edit box.
	
    @ return void
]]
function ImpUI_ChatWindows:SkinEditBox(window)
    _G[window:GetName()..'EditBoxLeft']:Hide();
    _G[window:GetName()..'EditBoxMid']:Hide();
    _G[window:GetName()..'EditBoxRight']:Hide();
end

--[[
	Moves the edit box to the top of the chat frame.
	
    @ return void
]]
function ImpUI_ChatWindows:MoveEditBox(window)
    local editBox = _G[window:GetName()..'EditBox'];

    editBox:ClearAllPoints();

    if(ImpUI_ChatWindows:IsCombatLog(window)) then 
        editBox:SetPoint('BOTTOM',window,'TOP',0,44);
    else
        editBox:SetPoint('BOTTOM',window,'TOP',0,22);
    end
    
    editBox:SetPoint('LEFT',window,-5,0);
    editBox:SetPoint('RIGHT',window,10,0);
end

--[[
	Simple helper to check if we're looking at the Combat Log.
	
    @ return bool
]]
function ImpUI_ChatWindows:IsCombatLog(window)
    return window:GetName() == 'ChatFrame2';
end

function ImpUI_ChatWindows:SetFontSize(window, index)
    local _, size, _, _, _, _, _, _, _, _ = GetChatWindowInfo(index);
    local chatFont = LSM:Fetch('font', ImpUI.db.profile.chatFont);

    if (size == 0) then
        size = 13;
    end

    -- Change Chat Font
    if (ImpUI.db.profile.outlineChat) then
        window:SetFont(chatFont, size, 'OUTLINE');
    else
        window:SetFont(chatFont, size);
    end
end

--[[
	As titled, adds a shadow to the chat window.
	
    @ return void
]]
function ImpUI_ChatWindows:AddShadow(window)
    window:SetShadowOffset( 1, -1 );
    window:SetShadowColor( 0, 0, 0, 0.6 );
end

--[[
	Handles the bulk of the actual chat styling if it is enabled.
	
    @ return void
]]
function ImpUI_ChatWindows:ApplyStyles()
    if (ImpUI.db.profile.styleChat == false) then return; end

    ImpUI_ChatWindows:ChangeTabFonts();
    ImpUI_ChatWindows:HideButtons();

    local index = 1;
    for _, chatFrameName in pairs(CHAT_FRAMES) do
        index = index + 1;
        local window = _G[chatFrameName];

        ImpUI_ChatWindows:RemoveScreenClamping(window);
        ImpUI_ChatWindows:RemoveChatArrows(window);
        ImpUI_ChatWindows:AdjustTab(window);
        ImpUI_ChatWindows:SkinEditBox(window);
        ImpUI_ChatWindows:MoveEditBox(window);
        ImpUI_ChatWindows:AddShadow(window);
        
        if (index <= NUM_CHAT_WINDOWS) then
            ImpUI_ChatWindows:SetFontSize(window, index);
        end
    end
end

--[[
	Fired when we get a battle.net whisper.
	
    @ return void
]]
function ImpUI_ChatWindows:CHAT_MSG_BN_WHISPER()
    ImpUI_ChatWindows:ApplyStyles();
end

--[[
	Fired when we get a normal in game whisper.
	
    @ return void
]]
function ImpUI_ChatWindows:CHAT_MSG_WHISPER()
    ImpUI_ChatWindows:ApplyStyles();
end


function ImpUI_ChatWindows:OpenTemporaryWindowHook()
    ImpUI_ChatWindows:ApplyStyles();
end

function ImpUI_ChatWindows:UpdateTabsHook()
    ImpUI_ChatWindows:ApplyStyles();
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_ChatWindows:OnInitialize()
    ImpUI_ChatWindows:ApplyStyles();
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_ChatWindows:OnEnable()
    -- Add More Font Sizes
    for i = 1, 13 do
        CHAT_FONT_HEIGHTS[i] = i + 10;
    end

    -- First Run
    ImpUI_ChatWindows:ApplyStyles();

    -- Hooks
    self:SecureHook('FCF_OpenTemporaryWindow', 'OpenTemporaryWindowHook');
    self:SecureHook('FCFDock_UpdateTabs', 'UpdateTabsHook');
    self:RegisterEvent('CHAT_MSG_WHISPER');
    self:RegisterEvent('CHAT_MSG_BN_WHISPER');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_ChatWindows:OnDisable()
end