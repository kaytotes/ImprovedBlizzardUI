-- Get the Config for the AFK Mode
function ImpUI:IsAFKEnabled(info)
    return self.db.char.afkMode;
end

-- Store the Config for the AFK Mode
function ImpUI:SetAFKEnabled(info, newValue)
    self.db.char.afkMode = newValue;
end

-- Get the Config for the Automatic Screenshot.
function ImpUI:IsAutoScreenshotEnabled(info)
    return self.db.char.autoScreenshot;
end

-- Set the Config for the Automatic Screenshot.
function ImpUI:SetAutoScreenshot(info, newValue)
    self.db.char.autoScreenshot = newValue;
end

-- Get the Config for using the Auto Repair module.
function ImpUI:IsAutoRepairEnabled(info)
    return self.db.char.autoRepair;
end

-- Set the Config for using the Auto Repair module.
function ImpUI:SetAutoRepairEnabled(info, newValue)
    self.db.char.autoRepair = newValue;
end

-- Get the Config for using Guild Bank for Repairs.
function ImpUI:IsGuildRepairEnabled(info)
    return self.db.char.guildRepair;
end

-- Set the Config for using the Guild bank for Repairs.
function ImpUI:SetGuildRepairEnabled(info, newValue)
    self.db.char.guildRepair = newValue;
end

-- Get the Config for auto selling trash items.
function ImpUI:IsAutoSellEnabled(info)
    return self.db.char.autoSell;
end

-- Set the Config for auto selling trash items.
function ImpUI:SetAutoSellEnabled(info, newValue)
    self.db.char.autoSell = newValue;
end

-- Gets the Minify Chat Messages Config.
function ImpUI:ShouldMinifyStrings(info)
    return self.db.char.minifyStrings;
end

-- Set the Minify Strings option and in the process restore
-- or set the string overrides.
function ImpUI:SetMinifyStrings(info, newValue)
    self.db.char.minifyStrings = newValue;

    if (newValue == true) then
        ImpUI_Chat:RestoreStrings();
        ImpUI_Chat:OverrideStrings();
    else
        ImpUI_Chat:RestoreStrings();
    end
end

-- Get whether the chat should be styped.
function ImpUI:ShouldStyleChat(info)
    return self.db.char.styleChat;
end

-- Set whether the chat should be styled.
function ImpUI:SetStyleChat(info, newValue)
    self.db.char.styleChat = newValue;

    if (newValue == true) then
        ImpUI_Chat:StyleChat();
    else
        ImpUI_Chat:ResetChat();
    end
end

-- Gets the stored Chat font.
function ImpUI:GetChatFont(info)
    return self.db.char.chatFont;
end

-- Store the Chat font and repaint / reload if needed.
function ImpUI:SetChatFont(info, newFont)
    self.db.char.chatFont = newFont;

    ImpUI_Chat:StyleChat();
end

-- Get whether the chat window font should have an outline.
function ImpUI:GetChatOutline(info)
    return self.db.char.outlineChat;
end

-- Set whether the chat font should have an outline.
function ImpUI:SetChatOutline(info, newValue)
    self.db.char.outlineChat = newValue;
    
    ImpUI_Chat:StyleChat();
end

-- Get whether the health warnings should display.
function ImpUI:ShouldDisplayHealthWarning(info)
    return self.db.char.healthWarnings;
end

-- Set whether the health warnings should display.
function ImpUI:SetDisplayHealthWarning(info, newValue)
    self.db.char.healthWarnings = newValue;
end

-- Get the Health Warning Font
function ImpUI:GetHealthWarningFont(info)
    return self.db.char.healthWarningFont;
end

-- Set the Health Warning Font
function ImpUI:SetHealthWarningFont(info, newFont)
    self.db.char.healthWarningFont = newFont;
end

-- Get the Health Warning Size.
function ImpUI:GetHealthWarningSize(info)
    return self.db.char.healthWarningSize;
end

-- Set the Health Warning Size
function ImpUI:SetHealthWarningSize(info, newValue)
    self.db.char.healthWarningSize = newValue;
end

-- Get the Health Warning 50% Colour
function ImpUI:GetHealthWarningHalfColour(info)
    return self.db.char.healthWarningHalfColour.r, self.db.char.healthWarningHalfColour.g, self.db.char.healthWarningHalfColour.b, self.db.char.healthWarningHalfColour.a; 
end

-- Set the Health Warning 50% Colour
function ImpUI:SetHealthWarningHalfColour(_, r, g, b, a)
    self.db.char.healthWarningHalfColour.r = r;
    self.db.char.healthWarningHalfColour.g = g;
    self.db.char.healthWarningHalfColour.b = b;
    self.db.char.healthWarningHalfColour.a = a;
end

-- Get the Health Warning 25% Colour
function ImpUI:GetHealthWarningQuarterColour(info)
    return self.db.char.healthWarningQuarterColour.r, self.db.char.healthWarningQuarterColour.g, self.db.char.healthWarningQuarterColour.b, self.db.char.healthWarningQuarterColour.a; 
end

-- Set the Health Warning 25% Colour
function ImpUI:SetHealthWarningQuarterColour(_, r, g, b, a)
    self.db.char.healthWarningQuarterColour.r = r;
    self.db.char.healthWarningQuarterColour.g = g;
    self.db.char.healthWarningQuarterColour.b = b;
    self.db.char.healthWarningQuarterColour.a = a;
end

-- Get whether we should announce interrupts.
function ImpUI:ShouldAnnounceInterrupts(info)
    return self.db.char.announceInterrupts;
end

-- Set whether we should announce interrupts.
function ImpUI:SetAnnounceInterrupts(info, newValue)
    self.db.char.announceInterrupts = newValue;
end

-- The options available for the Interrupt channel.
function ImpUI:GetInterruptOptions()
    local options = {
        'Auto',
        'Say',
        'Yell',
    };

    return options;
end

-- Get the channel that should be used for announcing interrupts.
function ImpUI:GetInterruptChannel(info)
    return self.db.char.interruptChannel;
end

-- Set the channel that should be used for announcing interrupts.
function ImpUI:SetInterruptChannel(info, newValue)
    self.db.char.interruptChannel = newValue;
end

-- Should we display killing blows.
function ImpUI:ShouldDisplayKillingBlows(info)
    return self.db.char.killingBlows;
end

-- Set whether we should display killing blows.
function ImpUI:SetKillingBlows(info, newValue)
    self.db.char.killingBlows = newValue;
end

-- Get the message that should be displayed on a Killing blow.
function ImpUI:GetKillingBlowMessage(info)
    return self.db.char.killingBlowMessage;
end

-- Set the message that should be displayed on a Killing Blow.
function ImpUI:SetKillingBlowMessage(info, newValue)
    self.db.char.killingBlowMessage = newValue;
end

-- Get the Killing Blow Colour
function ImpUI:GetKillingBlowColour(info)
    return self.db.char.killingBlowColour.r, self.db.char.killingBlowColour.g, self.db.char.killingBlowColour.b, self.db.char.killingBlowColour.a; 
end

-- Set the Killing Blow Colour
function ImpUI:SetKillingBlowColour(_, r, g, b, a)
    self.db.char.killingBlowColour.r = r;
    self.db.char.killingBlowColour.g = g;
    self.db.char.killingBlowColour.b = b;
    self.db.char.killingBlowColour.a = a;
end

-- Get the Killing Blow Size.
function ImpUI:GetKillingBlowSize(info)
    return self.db.char.killingBlowSize;
end

-- Set the Killing Blow Size
function ImpUI:SetKillingBlowSize(info, newValue)
    self.db.char.killingBlowSize = newValue;
end

-- Get the Killing Blow Font
function ImpUI:GetKillingBlowFont(info)
    return self.db.char.killingBlowFont;
end

-- Set the Killing Blow Font
function ImpUI:SetKillingBlowFont(info, newFont)
    self.db.char.killingBlowFont = newFont;
end