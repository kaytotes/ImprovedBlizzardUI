--[[
    ImpBlizzardUI/modules/ImpBlizzardUI_Bars
    Handles and modifies Action Bar related stuff
    Current Features: Main Action Bars minified, Range / OOM colours on all abilities, Moved Vehicle Leave Button, stripped unneccesary textures, Micro Menu on Minimap, Cast Bar (With Timer), Buff Bars
]]
local _, ImpBlizz = ...;

local BarFrame = CreateFrame("Frame", nil, UIParent);

-- Buffs
BarFrame.buffPoint = BuffFrame.SetPoint;
BarFrame.buffScale = BuffFrame.SetScale;

-- Helper function for moving a Blizzard frame that has a SetMoveable flag
local function ModifyFrame(frame, anchor, parent, posX, posY, scale)
    frame:SetMovable(true);
    frame:ClearAllPoints();
    if(parent == nil) then frame:SetPoint(anchor, posX, posY) else frame:SetPoint(anchor, parent, posX, posY) end
    if(scale ~= nil) then frame:SetScale(scale) end
    frame:SetUserPlaced(true);
    frame:SetMovable(false);
end

-- Helper function for moving a Blizzard frame that does NOT have a SetMoveable flag
local function ModifyBasicFrame(frame, anchor, parent, posX, posY, scale)
    frame:ClearAllPoints();
    if(parent == nil) then frame:SetPoint(anchor, posX, posY) else frame:SetPoint(anchor, parent, posX, posY) end
    if(scale ~= nil) then frame:SetScale(scale) end
end

-- Does the bulk of the tweaking to the primary action bars
local function AdjustActionBars()
    if(InCombatLockdown() == false) then
        ModifyFrame(MainMenuBar, "BOTTOM", nil, 256, 0, 1.1); -- Main Action Bar
        MainMenuBarRightEndCap:SetPoint("CENTER", MainMenuBarArtFrame, 34, 0); -- Right End Cap
        ModifyFrame(MainMenuBarBackpackButton, "BOTTOMRIGHT", UIParent, -1, -300, nil); -- Bag Bar
        ModifyFrame(CharacterMicroButton, "BOTTOMRIGHT", UIParent, 0, 5000, nil); -- Micro Menu

        -- Adjust Exp Bar
        MainMenuExpBar:SetWidth(512);
        ModifyBasicFrame(MainMenuExpBar, "TOP", nil, -256, 0, nil); -- Move it
        ExhaustionTick:Hide(); -- Hide Exhaustion Tick
        ExhaustionTick:HookScript("OnShow", ExhaustionTick.Hide); -- Make sure it never comes back
        ExhaustionLevelFillBar:SetVertexColor(0.0, 0.0, 0.0, 0.0);
        for i = 1, 19 do -- Remove EXP Dividers
        	if _G["MainMenuXPBarDiv"..i] then _G["MainMenuXPBarDiv"..i]:Hide() end
    	end
        for i = 0, 3 do -- Remove "collapsed" exp bar at max level
            if _G["MainMenuMaxLevelBar"..i] then _G["MainMenuMaxLevelBar"..i]:Hide() end
        end

        local offset = 0;
        if(ReputationWatchBar:IsShown() and MainMenuExpBar:IsShown()) then
            offset = 7;
        elseif(ReputationWatchBar:IsShown() ~= true and MainMenuExpBar:IsShown() ~= true) then
            offset = -10;
        else
            offset = 0;
        end

        ModifyFrame(MultiBarBottomRight, "BOTTOM", nil, -256, 100 + offset, nil); -- Bottom Right Action Bar
        ModifyFrame(MultiBarBottomLeft, "BOTTOM", nil, -256, 57 + offset, nil); -- Bottom Left Action Bar
        ModifyFrame(StanceBarFrame, "TOPLEFT", nil, 0, 120 + offset, 1); -- Stance Bar

        -- Tweak and Adjust Reputation Bar
        ReputationWatchBar.StatusBar:SetWidth(512);
        ReputationWatchBar:SetWidth(512);
        -- I fucking hate this, should be looped but currently can't find the global reference. Hacky but works.
        -- Will Replace
        ReputationWatchBar.StatusBar.WatchBarTexture0:Hide();
        ReputationWatchBar.StatusBar.WatchBarTexture1:Hide();
        ReputationWatchBar.StatusBar.WatchBarTexture2:Hide();
        ReputationWatchBar.StatusBar.WatchBarTexture3:Hide();
        ReputationWatchBar.StatusBar.XPBarTexture0:Hide();
        ReputationWatchBar.StatusBar.XPBarTexture1:Hide();
        ReputationWatchBar.StatusBar.XPBarTexture2:Hide();
        ReputationWatchBar.StatusBar.XPBarTexture3:Hide();

        -- Move Bar
        if(MainMenuExpBar:IsShown()) then
            offset = 7;
        else
            offset = 0;
        end
        ModifyBasicFrame(ReputationWatchBar, "TOP", nil, -256, offset, nil);

        -- Hide Textures
        MainMenuBarTexture2:SetTexture(nil);
        MainMenuBarTexture3:SetTexture(nil);
        _G["StanceBarLeft"]:SetTexture(nil);
        _G["StanceBarMiddle"]:SetTexture(nil);
        _G["StanceBarRight"]:SetTexture(nil);
        _G["SlidingActionBarTexture"..0]:SetTexture(nil);
        _G["SlidingActionBarTexture"..1]:SetTexture(nil);
        if(Conf_ShowArt == false) then -- Hide Action Bar Art
            MainMenuBarRightEndCap:SetTexture(nil);
            MainMenuBarLeftEndCap:SetTexture(nil);
        end

        -- Hide Main Action Bar Buttons
        MainMenuBarPageNumber:Hide();
        ActionBarDownButton:Hide();
        ActionBarUpButton:Hide();

        -- Vehicle Leave Button
        ModifyBasicFrame(MainMenuBarVehicleLeaveButton, "CENTER", nil, -600, 40, nil);

        -- Pet Bar
        local offset = 0;
    	if(ReputationWatchBar:IsShown() and MainMenuExpBar:IsShown())then
    		offset = 0;
    	else
    		offset = 10;
    	end

    	if ( StanceBarFrame and GetNumShapeshiftForms() > 0 ) then
            ModifyBasicFrame(PetActionButton1, "CENTER", nil, -606, 28 + offset);
    	else
            ModifyBasicFrame(PetActionButton1, "CENTER", nil, -140, 28 + offset);
    	end

        -- Enable the Micro Menu
        Minimap:SetScript("OnMouseUp", function(self, btn)
    	if btn == "RightButton" then
    		EasyMenu(BarFrame.microMenuList, BarFrame.microMenu, "cursor", 0, 0, "MENU", 3);
    	else
    		Minimap_OnClick(self)
    	end
    	end)

        -- Casting Bar
        ModifyFrame(CastingBarFrame, "CENTER", nil, 0, -175, 1.1);
        if(Conf_CastingTimer) then
            CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil);
            CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE");
            CastingBarFrame.timer:SetPoint("TOP", CastingBarFrame, "BOTTOM", 0, 35);
            CastingBarFrame.updateDelay = 0.1;
        end

        BuffFrame:ClearAllPoints();
    	BarFrame.buffPoint(BuffFrame, "TOPRIGHT", -175, -11);
    	BarFrame.buffScale(BuffFrame, 1.4);
    end
end


local function HandleEvents(self, event, ...)
    if(event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
        AdjustActionBars();
    end

    if(event == "UNIT_EXITED_VEHICLE") then
        if(... == "player") then
            AdjustActionBars();
        end
    end

    if(event == "PLAYER_FLAGS_CHANGED") then
        ModifyFrame(CharacterMicroButton, "BOTTOMRIGHT", UIParent, 0, 5000, nil);
    end
end

-- Toggles the Bag Bar between hidden and visible, called from the Micro Menu
local function ToggleBagBar()
    if(BarFrame.bagsVisible) then
        -- Hide them
        ModifyFrame(MainMenuBarBackpackButton, "BOTTOMRIGHT", UIParent, -1, -300, nil);
        BarFrame.bagsVisible = false;
    else
        --show them
        ModifyFrame(MainMenuBarBackpackButton, "BOTTOMRIGHT", UIParent, -100, 0, nil);
        BarFrame.bagsVisible = true;
    end
end

-- Builds the Micro Menu List that displays on Right Click
local function UpdateMicroMenuList()
    BarFrame.microMenuList = {};
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Character"], func = function() ToggleCharacter( "PaperDollFrame" ) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Spellbook"], func = function() ToggleFrame(SpellBookFrame) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Class' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Talents"], func = function() ToggleTalentFrame() end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Profession' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Achievements"], func = function() ToggleAchievementFrame() end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\Minimap_shield_elite', });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Quest Log"], func = function() ToggleFrame( WorldMapFrame )end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\GossipFrame\\ActiveQuestIcon' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Guild"], func = function() ToggleGuildFrame( 1 ) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\GossipFrame\\TabardGossipIcon' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Group Finder"], func = function() PVEFrame_ToggleFrame() end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\LFGFRAME\\BattlenetWorking0' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Collections"], func = function() ToggleCollectionsJournal() end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Adventure Guide"].."     ", func = function() ToggleEncounterJournal() end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Swap Bags"], func = function() ToggleBagBar() end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Banker' });
    table.insert(BarFrame.microMenuList, {text = "|cff00FFFF"..ImpBlizz["ImpBlizzardUI"], func = function() InterfaceOptionsFrame_OpenToCategory("Improved Blizzard UI") end, notCheckable = true, fontObject = BarFrame.menuFont });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFF00"..ImpBlizz["Log Out"], func = function() Logout() end, notCheckable = true, fontObject = BarFrame.menuFont });
    table.insert(BarFrame.microMenuList, {text = "|cffFE2E2E"..ImpBlizz["Force Exit"], func = function() ForceQuit() end, notCheckable = true, fontObject = BarFrame.menuFont });
end

-- Sets up Event Handlers etc
local function Init()
    BarFrame:SetScript("OnEvent", HandleEvents);

    -- Register all Events
    BarFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
    BarFrame:RegisterEvent("PLAYER_FLAGS_CHANGED");
    BarFrame:RegisterEvent("PLAYER_TALENT_UPDATE");
    BarFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    BarFrame:RegisterEvent("UNIT_EXITED_VEHICLE");

    -- Micro Menu that replaces the removed action bar based one. Spawns on right click of minimamp
    BarFrame.microMenu = CreateFrame("Frame", "RightClickMenu", UIParent, "UIDropDownMenuTemplate");
    BarFrame.menuFont = CreateFont("menuFont");
    BarFrame.menuFont:SetFontObject(GameFontNormal);
    BarFrame.menuFont:SetFont("Interface\\AddOns\\ImpBlizzardUI\\media\\impfont.ttf", 12, nil);
    BarFrame.bagsVisible = false;
    UpdateMicroMenuList();
end

-- Handles the Out of Range action bar colouring
local function UpdateActionRange(self, elapsed)
    if(Conf_OutOfRange) then
        if(self.rangeTimer == TOOLTIP_UPDATE_TIME) then
            if(IsActionInRange(self.action) == false) then
                self.icon:SetVertexColor(1, 0, 0);
            else
                local canUse, amountMana = IsUsableAction( self.action );
                if(canUse) then
                    self.icon:SetVertexColor( 1.0, 1.0, 1.0 );
    			elseif(amountMana) then
                    self.icon:SetVertexColor( 0.5, 0.5, 1.0 );
    			else
                    self.icon:SetVertexColor( 0.4, 0.4, 0.4 )
                end
            end
        end
    end
end

-- Fixes the Buff Frames once the Blizzard UI messes with them
local function FixBuffs()
    BuffFrame:ClearAllPoints();
    BarFrame.buffPoint(BuffFrame, "TOPRIGHT", -175, -11);
    BarFrame.buffScale(BuffFrame, 1.4);
end

-- Repositon stuff after the Blizzard UI fucks with them
local function MainMenuBar_UpdateExperienceBars_Hook(newLevel)
    AdjustActionBars();
end

-- Repositon stuff after the Blizzard UI fucks with them
local function MainMenuBarVehicleLeaveButton_Update_Hook()
    AdjustActionBars();
end

-- Moves the MicroMenu back after the Blizzard UI repositions it
local function MoveMicroButtons_Hook(...)
    ModifyFrame(CharacterMicroButton, "BOTTOMRIGHT", UIParent, 0, 5000, nil);
end

-- Displays the Casting Bar timer
local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
    if( not self.timer ) then
		return;
	end
	if( self.updateDelay ) and (self.updateDelay < elapsed ) then
		if( self.casting ) then
			self.timer:SetText( format( "%2.1f / %1.1f", max( self.maxValue - self.value, 0), self.maxValue ));
		elseif( self.channeling ) then
			self.timer:SetText( format( "%.1f", max( self.value, 0 )));
		else
			self.timer:SetText("");
		end
		self.updateDelay = 0.1;
	else
		self.updateDelay = self.updateDelay - elapsed;
	end
end

-- Add a function to be called after execution of a secure function. Allows one to "post-hook" a secure function without tainting the original.
hooksecurefunc("MoveMicroButtons", MoveMicroButtons_Hook);
hooksecurefunc("ActionButton_OnUpdate", UpdateActionRange);
hooksecurefunc("MainMenuBar_UpdateExperienceBars", MainMenuBar_UpdateExperienceBars_Hook);
hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", MainMenuBarVehicleLeaveButton_Update_Hook);
hooksecurefunc("CastingBarFrame_OnUpdate", CastingBarFrame_OnUpdate_Hook);
hooksecurefunc( BuffFrame, "SetPoint", function(frame) frame:ClearAllPoints(); BarFrame.buffPoint(BuffFrame, "TOPRIGHT", -175, -11); end);
hooksecurefunc( BuffFrame, "SetScale", function(frame) BarFrame.buffScale(BuffFrame, 1.4); end)

-- Credit : BlizzBugsSuck (Shefki, Phanx) - http://www.wowinterface.com/downloads/info17002-BlizzBugsSuck.html
-- Fix InterfaceOptionsFrame_OpenToCategory not actually opening the category (and not even scrolling to it) Used by the MicroMenu
-- Confirmed still broken in 7.0.3.21973 (7.0.3)
do
	local function get_panel_name(panel)
		local tp = type(panel)
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		if tp == "string" then
			for i = 1, #cat do
				local p = cat[i]
				if p.name == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel
					end
				end
			end
		elseif tp == "table" then
			for i = 1, #cat do
				local p = cat[i]
				if p == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel.name
					end
				end
			end
		end
	end

	local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
		if doNotRun or InCombatLockdown() then return end
		local panelName = get_panel_name(panel)
		if not panelName then return end -- if its not part of our list return early
		local noncollapsedHeaders = {}
		local shownpanels = 0
		local mypanel
		local t = {}
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, #cat do
			local panel = cat[i]
			if not panel.parent or noncollapsedHeaders[panel.parent] then
				if panel.name == panelName then
					panel.collapsed = true
					t.element = panel
					InterfaceOptionsListButton_ToggleSubCategories(t)
					noncollapsedHeaders[panel.name] = true
					mypanel = shownpanels + 1
				end
				if not panel.collapsed then
					noncollapsedHeaders[panel.name] = true
				end
				shownpanels = shownpanels + 1
			end
		end
		local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
		if shownpanels > 15 and Smin < Smax then
			local val = (Smax/(shownpanels-15))*(mypanel-2)
			InterfaceOptionsFrameAddOnsListScrollBar:SetValue(val)
		end
		doNotRun = true
		InterfaceOptionsFrame_OpenToCategory(panel)
		doNotRun = false
	end

	hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
end

-- End of file, call Init
Init();
