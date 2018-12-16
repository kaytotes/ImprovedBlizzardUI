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