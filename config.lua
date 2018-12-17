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
    return self.db.char.healthWarning;
end

-- Set whether the health warnings should display.
function ImpUI:SetDisplayHealthWarning(info, newValue)
    self.db.char.healthWarning = newValue;
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
end;