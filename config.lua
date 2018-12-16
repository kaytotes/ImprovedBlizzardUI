function ImpUI:GetMessage(info)
    return self.db.profile.message;
end

function ImpUI:SetMessage(info, newValue)
    self.db.profile.message = newValue;
end