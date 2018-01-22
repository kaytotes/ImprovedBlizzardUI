local _, Loc = ...;

-- Build the On Screen Display
Imp_OSD = CreateFrame( 'MessageFrame', nil, UIParent );
Imp_OSD:SetPoint("LEFT");
Imp_OSD:SetPoint("RIGHT");
Imp_OSD:SetHeight(29);
Imp_OSD:SetInsertMode("TOP");
Imp_OSD:SetFrameStrata("HIGH");
Imp_OSD:SetFadeDuration(1);
Imp_OSD:SetFont(ImpFont, 26, "OUTLINE");

function Imp_OSD:AddOnScreenMessage(args)
    print(args);
end
