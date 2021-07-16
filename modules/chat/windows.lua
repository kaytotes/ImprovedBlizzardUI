--[[
    modules\chat\windows.lua
    Styles the Blizzard Chat frame to better match the rest of the UI.
]]
ImpUI_ChatWindows = ImpUI:NewModule('ImpUI_ChatWindows', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions
local GetChatWindowInfo = GetChatWindowInfo;

--[[
	Resets the Chat to essentially the default blizzard.
	
    @ return void
]]
function ImpUI_ChatWindows:ResetChat()
    -- Restore Edit Box Font
    ChatFontNormal:SetFont(LSM:Fetch('font', 'Arial Narrow'), 12);

    -- Restore Chat Channel Button
    if (ImpUI_ChatWindows:IsHooked(ChatFrameMenuButton, 'OnShow')) then
        ImpUI_ChatWindows:Unhook(ChatFrameMenuButton, 'OnShow');
        ChatFrameMenuButton:Show();
    end

    -- Restore ChatFrameChannelButton
    if (ImpUI_ChatWindows:IsHooked(ChatFrameChannelButton, 'OnShow')) then
        ImpUI_ChatWindows:Unhook(ChatFrameChannelButton, 'OnShow');
        ChatFrameChannelButton:Show();
    end

    -- Restore Battle.net / Social Button
	local button = QuickJoinToastButton or FriendsMicroButton;
    if (ImpUI_ChatWindows:IsHooked(button, 'OnShow')) then
        ImpUI_ChatWindows:Unhook(button, 'OnShow');
        button:Show();
    end
    
    -- Restore Battle.net Toast
    BNToastFrame:SetClampedToScreen(false);

    for i = 1, NUM_CHAT_WINDOWS do
        local window = _G['ChatFrame'..i]:GetName();
        local name, size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);

        -- Restore Chat Arrows
        if (ImpUI_ChatWindows:IsHooked(_G[window..'ButtonFrame'], 'OnShow')) then
            ImpUI_ChatWindows:Unhook(_G[window..'ButtonFrame'], 'OnShow');
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
function ImpUI_ChatWindows:StyleChat()
    if (ImpUI.db.profile.styleChat == false) then return; end

    local chatFont = LSM:Fetch('font', ImpUI.db.profile.chatFont);

    -- Change Edit Box Font
    ChatFontNormal:SetFont(chatFont, 12, 'THINOUTLINE');
    ChatFontNormal:SetShadowOffset(1,-1);
    ChatFontNormal:SetShadowColor(0,0,0,0.6);

    -- Hide Chat Channels Button
    ImpUI_ChatWindows:HookScript(ChatFrameMenuButton, 'OnShow', ChatFrameMenuButton.Hide);
    ChatFrameMenuButton:Hide();

    -- Hide ChatFrameChannelButton
    ImpUI_ChatWindows:HookScript(ChatFrameChannelButton, 'OnShow', ChatFrameChannelButton.Hide);
    ChatFrameChannelButton:Hide();

    -- Hide Battle.net / Social Button
    if (Helpers.IsRetail()) then
        local button = QuickJoinToastButton or FriendsMicroButton;
        ImpUI_ChatWindows:HookScript(button, 'OnShow', button.Hide);
        button:Hide();
    
        -- Move Battle.net Toast
        BNToastFrame:SetClampedToScreen(true);
        BNToastFrame:SetClampRectInsets(-15,15,15,-15);
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local window = _G['ChatFrame'..i]:GetName();
        local name, size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i);

        -- Stop Chat Arrows Coming Back
        ImpUI_ChatWindows:HookScript(_G[window..'ButtonFrame'], 'OnShow', _G[window..'ButtonFrame'].Hide);
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
function ImpUI_ChatWindows:OnInitialize()
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
function ImpUI_ChatWindows:OnEnable()
    ImpUI_ChatWindows:StyleChat();

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
function ImpUI_ChatWindows:OnDisable()
end