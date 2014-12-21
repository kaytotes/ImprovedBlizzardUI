

local impUF = CreateFrame( "Frame", "ImprovUF", UIParent );

local classFrame;
local classIcon;
local classIconBorder;

-- Player Frame
local pFrameX = -265;
local pFrameY = -150;
local pFrameScale = 1.45;

-- Target Frame
local tFrameX = 265;
local tFrameY = -150;
local tFrameScale = 1.45;
local tFrameHidden = true;

-- Party Frame
local parFrameX = 40;
local parFrameY = 125;
local parFrameScale = 1.6;

-- Focus Frame
local focFrameX = 300;
local focFrameY = -200;
local focFrameScale = 1.25;

-- Timer
local timer = CreateFrame("Frame");
local time = 0;
local delayLength = 1;
local startTimer = false;

local function SetUnitFrames()

	-- Tweak Party Frame
	PartyMemberFrame1:ClearAllPoints();
	PartyMemberFrame1:SetScale( parFrameScale );
	PartyMemberFrame2:SetScale( parFrameScale );
	PartyMemberFrame3:SetScale( parFrameScale );
	PartyMemberFrame4:SetScale( parFrameScale );
	PartyMemberFrame1:SetPoint( "LEFT" , parFrameX, parFrameY );

	-- Tweak Player Frame
	PlayerFrame:SetMovable( true );
	PlayerFrame:ClearAllPoints();
	PlayerFrame:SetScale( pFrameScale );
	PlayerFrame:SetPoint( "CENTER", pFrameX, pFrameY );
	PlayerFrame:SetUserPlaced(true);
	PlayerFrame:SetMovable( false );

	-- Tweak Target Frame
	TargetFrame:SetMovable( true );
	TargetFrame:ClearAllPoints();
	TargetFrame:SetScale( tFrameScale );
	TargetFrame:SetPoint( "CENTER", tFrameX, tFrameY );
	TargetFrame:SetUserPlaced(true);
	TargetFrame:SetMovable( false );

	-- Tweak Focus Frame
	FocusFrame:SetMovable( true );
	FocusFrame:ClearAllPoints();
	FocusFrame:SetScale( focFrameScale );
	FocusFrame:SetPoint( "TOPLEFT", focFrameX, focFrameY );
	FocusFrame:SetUserPlaced( true );
	FocusFrame:SetMovable( false );

	-- Move Cast Bar
	CastingBarFrame:SetMovable(true);
	CastingBarFrame:ClearAllPoints();
	CastingBarFrame:SetScale( 1.1 );
	CastingBarFrame:SetPoint("CENTER", 0, -175);
	CastingBarFrame:SetUserPlaced(true);
	CastingBarFrame:SetMovable( false );

	for i=1, 5 do
        _G["ArenaPrepFrame"..i]:SetScale(1.5);      
	end
	ArenaEnemyFrames:SetScale(1.5);
end

-- Handle Raid Stuff Seperately
local function SetRaidFrames()
	local _, instanceType = IsInInstance();
	if( instanceType == "pvp" )then
		if( InCombatLockdown() == false )then
			if CompactRaidFrameManager:IsVisible() then  
				local point, relativeTo, relativePoint, xOfs, yOfs = CompactRaidFrameManager:GetPoint()
				CompactRaidFrameManager:SetPoint(point, relativeTo, relativePoint, xOfs, -300)
			end
		end

		CompactRaidFrameManagerToggleButton:HookScript("OnClick", function()
			if( InCombatLockdown() == false )then
				if CompactRaidFrameManager:IsVisible() then  
				    local point, relativeTo, relativePoint, xOfs, yOfs = CompactRaidFrameManager:GetPoint()
				    CompactRaidFrameManager:SetPoint(point, relativeTo, relativePoint, xOfs, -300)
				end
			end
		end);
	end
end

local function UpdateClassIcon(class)

	if class == "WARRIOR" then
		classIcon:SetTexCoord( 0, .25, 0, .25 );
	elseif class == "MAGE" then
		classIcon:SetTexCoord( .25, .5,0, .25 );
	elseif class == "ROGUE" then
		classIcon:SetTexCoord( .5, .74,0, .25 );
	elseif class == "DRUID" then
		classIcon:SetTexCoord( .75, .98, 0, .25 );
	elseif class == "PALADIN" then
		classIcon:SetTexCoord( 0, .25, .5, .75 );
	elseif class == "DEATHKNIGHT" then
		classIcon:SetTexCoord( .25, .5, .5, .75);
	elseif class == "MONK" then
		classIcon:SetTexCoord( .5, .74, .5,.75);
	elseif class == "HUNTER" then
		classIcon:SetTexCoord( 0, .25, .25, .5 );
	elseif class == "SHAMAN" then
		classIcon:SetTexCoord( .25, .5, .25, .5 );
	elseif class == "PRIEST" then
		classIcon:SetTexCoord( .5, .74, .25, .5 );
	elseif class == "WARLOCK" then
		classIcon:SetTexCoord( .75, .98, .25, .5 );
	end

end

local function UF_HandleEvents( self, event, ... )

	if( event == "PLAYER_ENTERING_WORLD" ) then
		if( InCombatLockdown() == false ) then
			SetUnitFrames();
			startTimer = true;
		end
	end

	if( event == "ADDON_LOADED" and ... == "BlizzImp" )then
				-- Create Frames
		if( bClassIcon == true ) then
			classFrame = CreateFrame("Frame", "ClassFrame", TargetFrame );
			classFrame:SetPoint( "CENTER", 110, 40);
			classFrame:SetSize( 40, 40 );
			classIcon = classFrame:CreateTexture( "ClassIcon" );
			classIcon:SetPoint( "CENTER" );
			classIcon:SetSize( 40, 40 );
			classIcon:SetTexture( "Interface\\TARGETINGFRAME\\UI-CLASSES-CIRCLES.BLP" );
			classIconBorder = classFrame:CreateTexture( "ClassIconBorder", "ARTWORK", nil, 1 );
			classIconBorder:SetPoint( "CENTER" , classIcon );
			classIconBorder:SetSize( 80, 80 );
			classIconBorder:SetTexture( "Interface\\UNITPOWERBARALT\\WowUI_Circular_Frame.blp" );
		end
	end

	if( event == "UNIT_EXITED_VEHICLE" or event == "UNIT_ENTERED_VEHICLE" ) then
		if( InCombatLockdown() == false )then
			if( UnitControllingVehicle("player") or UnitHasVehiclePlayerFrameUI("player") ) then
				SetUnitFrames();
			end
		end
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		if( bClassIcon == true ) then
			local target = select( 2, UnitClass("target") );
			UpdateClassIcon( target );
		end

		if( bClassColours == true )then
			if UnitIsPlayer("target") then
	                c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
	                TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
	        end
	        if UnitIsPlayer("focus") then
	                c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
	                FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
	        end
    	end
	end
	if( event == "UNIT_FACTION" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_FOCUS_CHANGED" or event == "UNIT_FACTION")then
		if( bClassColours == true )then
			if UnitIsPlayer("target") then
	                c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
	                TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
	        end
	        if UnitIsPlayer("focus") then
	                c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
	                FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
	        end
    	end
	end
end

-- Hacky - Fixes Raid Frame Init Bug
local function Delay(self, elapsed)
	if( startTimer == true ) then
		time = time + elapsed;
		if( time >= delayLength ) then
			SetRaidFrames();
			startTimer = false;
			time = 0;
		end
	end
end
timer:SetScript("OnUpdate", Delay );


local function UF_Init()
	impUF:SetScript( "OnEvent", UF_HandleEvents );
	LoadAddOn("Blizzard_ArenaUI");

	impUF:RegisterEvent( "PLAYER_ENTERING_WORLD" );
	impUF:RegisterEvent( "ADDON_LOADED" );
	impUF:RegisterEvent( "PLAYER_TARGET_CHANGED" );
	impUF:RegisterEvent( "GROUP_ROSTER_UPDATE" );
	impUF:RegisterEvent( "UNIT_FACTION" );
	impUF:RegisterEvent("PLAYER_FOCUS_CHANGED");
	impUF:RegisterEvent( "UNIT_EXITED_VEHICLE" );
end

-- Remove Portrait Damage Spam
-- Reimplimentation of CombatFeedback_OnCombatEvent from CombatFeedback.lua
function CFeedback_OnCombatEvent(self, event, flags, amount, type)
	self.feedbackText:SetText(" ");
end

do
	hooksecurefunc("CombatFeedback_OnCombatEvent", CFeedback_OnCombatEvent );
end

-- Run Initialisation
UF_Init();