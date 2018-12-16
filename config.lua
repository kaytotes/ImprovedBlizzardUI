-- Get the Config for the AFK Mode
function ImpUI:IsAFKEnabled(info)
    return self.db.char.afkMode;
end

-- Store the Config for the AFK Mode
function ImpUI:SetAFKEnabled(info, newValue)
    self.db.char.afkMode = newValue;
end