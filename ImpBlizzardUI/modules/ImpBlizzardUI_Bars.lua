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

-- Move the talking head frame up slightly so it doesn't clip with the bottom right action bar
local function MoveTalkingHeadFrame()
    TalkingHeadFrame.ignoreFramePositionManager = true;
    TalkingHeadFrame:ClearAllPoints();
    TalkingHeadFrame:SetPoint("BOTTOM", 0, 155);
end

local function AdjustExperienceBars()
    offset = 0;

    -- Adjust all fillable bars eg Honor, Exp, Artifact Power
    -- Adjust Exp Bar
    MainMenuExpBar:SetWidth(512);
    ModifyBasicFrame(MainMenuExpBar, "TOP", nil, 0, 0, nil); -- Move it
    ExhaustionTick:Hide(); -- Hide Exhaustion Tick
    ExhaustionLevelFillBar:SetVertexColor(0.0, 0.0, 0.0, 0.0);
    for i = 1, 19 do -- Remove EXP Dividers
        if _G["MainMenuXPBarDiv"..i] then _G["MainMenuXPBarDiv"..i]:Hide() end
    end
    for i = 0, 3 do -- Remove "collapsed" exp bar at max level
        if _G["MainMenuMaxLevelBar"..i] then _G["MainMenuMaxLevelBar"..i]:Hide() end
    end

    -- Adjust Artifact Power Bar
    ArtifactWatchBar:SetWidth(512);
    ArtifactWatchBar:SetFrameStrata("BACKGROUND");
    ArtifactWatchBar.StatusBar:SetWidth(512);
    ArtifactWatchBar.StatusBar.XPBarTexture0:Hide();
    ArtifactWatchBar.StatusBar.XPBarTexture1:Hide();
    ArtifactWatchBar.StatusBar.XPBarTexture2:Hide();
    ArtifactWatchBar.StatusBar.XPBarTexture3:Hide();
    ArtifactWatchBar.StatusBar.WatchBarTexture0:Hide();
    ArtifactWatchBar.StatusBar.WatchBarTexture1:Hide();
    ArtifactWatchBar.StatusBar.WatchBarTexture2:Hide();
    ArtifactWatchBar.StatusBar.WatchBarTexture3:Hide();
    if(MainMenuExpBar:IsShown()) then
        offset = 10;
    else
        offset = 0;
    end -- Tweak position based on exp bar being visible
    ModifyBasicFrame(ArtifactWatchBar, "TOP", nil, 0, offset + 3, nil); -- Move it

    -- Adjust Honor Bar
    HonorWatchBar:SetWidth(512);
    HonorWatchBar:SetFrameStrata("BACKGROUND");
    HonorWatchBar.StatusBar:SetWidth(512);
    HonorWatchBar.StatusBar.XPBarTexture0:Hide();
    HonorWatchBar.StatusBar.XPBarTexture1:Hide();
    HonorWatchBar.StatusBar.XPBarTexture2:Hide();
    HonorWatchBar.StatusBar.XPBarTexture3:Hide();
    HonorWatchBar.StatusBar.WatchBarTexture0:Hide();
    HonorWatchBar.StatusBar.WatchBarTexture1:Hide();
    HonorWatchBar.StatusBar.WatchBarTexture2:Hide();
    HonorWatchBar.StatusBar.WatchBarTexture3:Hide();
    if(MainMenuExpBar:IsShown() and ArtifactWatchBar:IsShown()) then
        offset = 20;
    elseif(MainMenuExpBar:IsShown() ~= true and ArtifactWatchBar:IsShown()) then
        offset = 10;
    end
    ModifyBasicFrame(HonorWatchBar, "TOP", nil, 0, offset + 3, nil); -- Move it

    -- Tweak and Adjust Reputation Bar
    ReputationWatchBar.StatusBar:SetWidth(512);
    ReputationWatchBar:SetFrameStrata("BACKGROUND");
    ReputationWatchBar:SetWidth(512);
    ReputationWatchBar.StatusBar.WatchBarTexture0:Hide();
    ReputationWatchBar.StatusBar.WatchBarTexture1:Hide();
    ReputationWatchBar.StatusBar.WatchBarTexture2:Hide();
    ReputationWatchBar.StatusBar.WatchBarTexture3:Hide();
    ReputationWatchBar.StatusBar.XPBarTexture0:Hide();
    ReputationWatchBar.StatusBar.XPBarTexture1:Hide();
    ReputationWatchBar.StatusBar.XPBarTexture2:Hide();
    ReputationWatchBar.StatusBar.XPBarTexture3:Hide();
    if(HonorWatchBar:IsShown() and ArtifactWatchBar:IsShown() and MainMenuExpBar:IsShown()) then
        offset = 30;
    elseif(HonorWatchBar:IsShown() ~= true and ArtifactWatchBar:IsShown() and MainMenuExpBar:IsShown()) then
        offset = 20;
    elseif(ArtifactWatchBar:IsShown() ~= true and MainMenuExpBar:IsShown()) then
        offset = 10;
    elseif(MainMenuExpBar:IsShown() ~= true and ArtifactWatchBar:IsShown()) then
        offset = 10;
    elseif(MainMenuExpBar:IsShown() ~= true and HonorWatchBar:IsShown()) then
        offset = 10;
    else
        offset = 0;
    end
    ModifyBasicFrame(ReputationWatchBar, "TOP", nil, 0, 2 + offset, nil); -- Move it
end

-- Does the bulk of the tweaking to the primary action bars
-- god damn I hate the repeating bar stuff, need to refactor once the logic is finalised
local function AdjustActionBars()
    local offset = 0;

    if(InCombatLockdown() == false) then
        ModifyFrame(MainMenuBar, "BOTTOM", nil, 0, 0, 1.1); -- Main Action Bar
        ModifyFrame(MainMenuBarBackpackButton, "BOTTOMRIGHT", UIParent, -1, -300, nil); -- Bag Bar
        ModifyFrame(CharacterMicroButton, "BOTTOMRIGHT", UIParent, 0, 5000, nil); -- Micro Menu

        MainMenuBar:SetWidth(512);

        -- Tweak Art Positions
        MainMenuBarTexture0:SetPoint("CENTER", MainMenuBarArtFrame, -128, 0);
        MainMenuBarTexture1:SetPoint("CENTER", MainMenuBarArtFrame, 128, 0);
        MainMenuBarRightEndCap:SetPoint("CENTER", MainMenuBarArtFrame, 290, 0);
        MainMenuBarLeftEndCap:SetPoint("CENTER", MainMenuBarArtFrame, -290, 0);

        ModifyFrame(ExtraActionBarFrame, "BOTTOM", UIParent, 0, 192, nil);

        AdjustExperienceBars();

        local shownBars = 0;
        if(MainMenuExpBar:IsShown()) then
            shownBars = shownBars + 1;
        end

        if(ArtifactWatchBar:IsShown()) then
            shownBars = shownBars + 1;
        end

        if(HonorWatchBar:IsShown()) then
            shownBars = shownBars + 1;
        end

        if(ReputationWatchBar:IsShown()) then
            shownBars = shownBars + 1;
        end

        offset = shownBars * 10;

        ModifyFrame(MultiBarBottomRight, "BOTTOM", nil, 0, 92 + offset, nil); -- Bottom Right Action Bar
        ModifyFrame(MultiBarBottomLeft, "BOTTOM", nil, 0, 49 + offset, nil); -- Bottom Left Action Bar

        -- Adjust and reposition the stance bar based on the above
        if(MultiBarBottomLeft:IsShown()) then
            ModifyFrame(StanceBarFrame, "TOPLEFT", nil, 0, 65 + offset, 1);
        end
        if(MultiBarBottomRight:IsShown()) then
            ModifyFrame(StanceBarFrame, "TOPLEFT", nil, 0, 110 + offset, 1);
            if(Conf_MoveTalkingHead) then
                MoveTalkingHeadFrame();
            end
        end
        if(MultiBarBottomLeft:IsShown() ~= true and MultiBarBottomRight:IsShown() ~= true) then
            ModifyFrame(StanceBarFrame, "TOPLEFT", nil, 0, 20 + offset, 1);
        end

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
        ModifyBasicFrame(MainMenuBarVehicleLeaveButton, "CENTER", nil, -350, 40, nil);

        -- Adjust and reposition the pet bar based on the above
        if(MultiBarBottomRight:IsShown()) then
            if ( StanceBarFrame and GetNumShapeshiftForms() > 0 ) then
                ModifyBasicFrame(PetActionButton1, "CENTER", nil, -609, 35 + offset);
            else
                ModifyBasicFrame(PetActionButton1, "CENTER", nil, -143, 35 + offset);
            end
        else
            if ( StanceBarFrame and GetNumShapeshiftForms() > 0 ) then
                ModifyBasicFrame(PetActionButton1, "CENTER", nil, -609, -8 + offset);
            else
                ModifyBasicFrame(PetActionButton1, "CENTER", nil, -143, -8 + offset);
            end
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

        BuffFrame:ClearAllPoints();
    	BarFrame.buffPoint(BuffFrame, "TOPRIGHT", -175, -22);
    	BarFrame.buffScale(BuffFrame, 1.4);
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
local function UpdateMicroMenuList(newLevel)
    BarFrame.microMenuList = {}; -- Create the array

    -- Add Stuff to it
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Character"], func = function() securecall(ToggleCharacter, "PaperDollFrame") end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Spellbook"], func = function() securecall(ToggleFrame, SpellBookFrame) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Class' });
    if(newLevel >= 10) then
        table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Talents"], func = function()
            if (not PlayerTalentFrame) then
                    LoadAddOn('Blizzard_TalentUI')
                end
                if (not GlyphFrame) then
                    LoadAddOn('Blizzard_GlyphUI')
                end
                securecall(ToggleFrame, PlayerTalentFrame)
            end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Profession' });
    end
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Achievements"], func = function() securecall(ToggleAchievementFrame) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\Minimap_shield_elite', });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Quest Log"], func = function() securecall(ToggleFrame, WorldMapFrame) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\GossipFrame\\ActiveQuestIcon' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Guild"], func = function()
        if (IsTrialAccount()) then
            UIErrorsFrame:AddMessage(ERR_RESTRICTED_ACCOUNT, 1, 0, 0)
        else
            securecall(ToggleGuildFrame)
        end
    end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\GossipFrame\\TabardGossipIcon' });
    if(newLevel >= 15) then
        table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Group Finder"], func = function() securecall(PVEFrame_ToggleFrame, 'GroupFinderFrame') end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\LFGFRAME\\BattlenetWorking0' });
        table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["PvP"], func = function() securecall(PVEFrame_ToggleFrame, 'PVPUIFrame', HonorFrame) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' });
    end
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Collections"], func = function() securecall(ToggleCollectionsJournal) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster' });
    if(newLevel >= 15) then
        table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Adventure Guide"].."     ", func = function() securecall(ToggleEncounterJournal) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' });
    end
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Shop"], func = function() securecall(ToggleStoreUI) end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Repair' });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFFFF"..ImpBlizz["Swap Bags"], func = function() ToggleBagBar() end, notCheckable = true, fontObject = BarFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Banker' });
    table.insert(BarFrame.microMenuList, {text = "|cff00FFFF"..ImpBlizz["ImpBlizzardUI"], func = function() InterfaceOptionsFrame_OpenToCategory("Improved Blizzard UI") end, notCheckable = true, fontObject = BarFrame.menuFont });
    table.insert(BarFrame.microMenuList, {text = "|cffFFFF00"..ImpBlizz["Log Out"], func = function() Logout() end, notCheckable = true, fontObject = BarFrame.menuFont });
    table.insert(BarFrame.microMenuList, {text = "|cffFE2E2E"..ImpBlizz["Force Exit"], func = function() ForceQuit() end, notCheckable = true, fontObject = BarFrame.menuFont });
end


local function HandleEvents(self, event, ...)
    if(event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
        AdjustActionBars();
        UpdateMicroMenuList(UnitLevel("player"));
    end

    if(event == "UNIT_EXITED_VEHICLE") then
        if(... == "player") then
            AdjustActionBars();
        end
    end

    if(event == "PLAYER_FLAGS_CHANGED") then
        ModifyFrame(CharacterMicroButton, "BOTTOMRIGHT", UIParent, 0, 5000, nil);
    end

    if(event == "PLAYER_LEVEL_UP") then
        local newLevel, _, _, _, _, _, _, _, _ = ...;
        UpdateMicroMenuList(newLevel);
        -- Print out hint for players on level up of unlocks, replaces the blizzard flashing thing
        if(newLevel == 10) then
            print("|cffffff00Talents now available under the Minimap Right-Click Menu!");
        elseif(newLevel == 15) then
            print("|cffffff00Group Finder and Adventure Guide now available under the Minimap Right-Click Menu!");
        end
    end

    if(event == "ADDON_LOADED" and ... == "ImpBlizzardUI") then
      if(Conf_CastingTimer) then
          CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil);
          CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE");
          CastingBarFrame.timer:SetPoint("TOP", CastingBarFrame, "BOTTOM", 0, 35);
          CastingBarFrame.updateDelay = 0.1;
      end
    end
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
    BarFrame:RegisterEvent("PLAYER_LEVEL_UP");
    BarFrame:RegisterEvent("ADDON_LOADED");

    -- Micro Menu that replaces the removed action bar based one. Spawns on right click of minimamp
    BarFrame.microMenu = CreateFrame("Frame", "RightClickMenu", UIParent, "UIDropDownMenuTemplate");
    BarFrame.menuFont = CreateFont("menuFont");
    BarFrame.menuFont:SetFontObject(GameFontNormal);
    BarFrame.menuFont:SetFont("Interface\\AddOns\\ImpBlizzardUI\\media\\impfont.ttf", 12, nil);
    BarFrame.bagsVisible = false;
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
    BarFrame.buffPoint(BuffFrame, "TOPRIGHT", -175, -22);
    BarFrame.buffScale(BuffFrame, 1.4);
end

-- Repositon stuff after the Blizzard UI fucks with them
local function MainMenuBar_UpdateExperienceBars_Hook(newLevel)
    AdjustActionBars();
    AdjustExperienceBars();
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
CastingBarFrame:HookScript('OnUpdate', function(self, elapsed)
    if not self.timer then return end

    if (self.updateDelay and self.updateDelay < elapsed) then
        if (self.casting) then
            self.timer:SetText(format("%.1f", max(self.maxValue - self.value, 0)))
        elseif (self.channeling) then
            self.timer:SetText(format("%.1f", max(self.value, 0)))
        else
            self.timer:SetText("")
        end
        self.updateDelay = 0.1
    else
        self.updateDelay = self.updateDelay - elapsed
    end
end)

-- Add a function to be called after execution of a secure function. Allows one to "post-hook" a secure function without tainting the original.
hooksecurefunc("MoveMicroButtons", MoveMicroButtons_Hook);
hooksecurefunc("ActionButton_OnUpdate", UpdateActionRange);
hooksecurefunc("MultiActionBar_Update", AdjustActionBars);
hooksecurefunc("MainMenuBar_UpdateExperienceBars", MainMenuBar_UpdateExperienceBars_Hook);
hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", MainMenuBarVehicleLeaveButton_Update_Hook);
hooksecurefunc( BuffFrame, "SetPoint", function(frame) frame:ClearAllPoints(); BarFrame.buffPoint(BuffFrame, "TOPRIGHT", -175, -22); end);
hooksecurefunc( BuffFrame, "SetScale", function(frame) BarFrame.buffScale(BuffFrame, 1.4); end)
ExhaustionTick:HookScript("OnShow", ExhaustionTick.Hide); -- Make sure it never comes back
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
