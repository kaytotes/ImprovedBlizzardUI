local _, Loc = ...;

Imp = CreateFrame('Frame', nil, UIParent);

ImpFont = "Interface\\AddOns\\ImprovedBlizzardUI\\media\\impfont.ttf";

-- Build the On Screen Display
Imp_OSD = CreateFrame( 'MessageFrame', nil, UIParent );
Imp_OSD:SetPoint("LEFT");
Imp_OSD:SetPoint("RIGHT");
Imp_OSD:SetHeight(29);
Imp_OSD:SetInsertMode("TOP");
Imp_OSD:SetFrameStrata("HIGH");
Imp_OSD:SetFadeDuration(1);
Imp_OSD:SetFont(ImpFont, 26, "OUTLINE");


function Imp.ApplyClassColours(statusBar, unit)
    if ( UnitIsConnected(unit) and unit == statusBar.unit and UnitClass(unit) ) then
        local _, class = UnitClass(unit);
        local c = RAID_CLASS_COLORS[class];
        statusBar:SetStatusBarColor(c.r, c.g, c.b );
    end
end

print("|cffffff00Improved Blizzard UI " .. GetAddOnMetadata("ImprovedBlizzardUI", "Version") .. " Initialised");