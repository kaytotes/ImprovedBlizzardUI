local _, ns = ...
local oUF = ns.oUF;

local UnitSpecific = {
    player = function(self)
        -- Player specific layout code.
    end,
        
    party = function(self)
    -- Party specific layout code.         
    end,
}

local Shared = function(self, unit)
    -- Shared layout code.

    if(UnitSpecific[unit]) then
        return UnitSpecific[unit](self)
    end
end

oUF:RegisterStyle("ImprovedBlizzardUI", Shared)
oUF:Factory(function(self)

    self:SetActiveStyle("ImprovedBlizzardUI")

    -- oUF:SpawnHeader(overrideName, overrideTemplate, visibility, attributes ...)
    local party = self:SpawnHeader(nil, nil, 'raid,party,solo',
        -- http://wowprogramming.com/docs/secure_template/Group_Headers
        -- Set header attributes
        'showParty', true, 
        'showPlayer', true, 
        'yOffset', -20
    )

    party:SetPoint("TOPLEFT", 30, -30);
end);