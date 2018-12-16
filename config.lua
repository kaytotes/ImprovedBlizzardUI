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

function ImpUI:GetChatFont(info)
    print(self.db.char.chatFont);
    return self.db.char.chatFont;
end

function ImpUI:SetChatFont(info, newFont)
    ImpUI:Print('Setting Font');

    -- Repaint Stuff

    self.db.char.chatFont = newFont;
end