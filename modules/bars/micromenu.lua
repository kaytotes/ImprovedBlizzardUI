--[[
    modules\bars\micromenu.lua
    Hides the MicroMenu frame when not in a Vehicle or Pet Battle and replaces it with a right click menu.
]]
local addonName, Loc = ...;

local MicroMenuFrame = CreateFrame('Frame', nil, UIParent);

local worldMapChanged = false;

-- Micro Menu that replaces the removed action bar based one. Spawns on right click of minimamp
MicroMenuFrame.microMenu = CreateFrame('Frame', 'RightClickMenu', UIParent, 'UIDropDownMenuTemplate');
MicroMenuFrame.menuFont = CreateFont('menuFont');
MicroMenuFrame.menuFont:SetFontObject(GameFontNormal);
MicroMenuFrame.menuFont:SetFont(ImpFont, 12, nil);
MicroMenuFrame.bagsVisible = false;

--[[
    Hides the Micro Menu by moving it off screen

    @ return void
]]
local function HideMicroMenu()
	Imp.ModifyFrame(CharacterMicroButton, 'BOTTOMLEFT', UIParent, 5000, 2, nil);
end

--[[
    Checks for the world map on update as when this closes Blizzard moves the micromenu
    @ return void
]]
local function MicroMenu_Tick()
    if ( (worldMapChanged) and not WorldMapFrame:IsVisible() ) then
        HideMicroMenu();
        worldMapChanged = false;
    end
end

--[[
    Rebuilds the contents of the Micro Menu List

    @ param int $newLevel The new level of the Player after leveling up
    @ return void
]]
local function UpdateMicroMenuList(newLevel)
    MicroMenuFrame.microMenuList = {}; -- Create the array

    -- Add Stuff to it
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Character'], func = function() securecall(ToggleCharacter, 'PaperDollFrame') end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle' });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Spellbook'], func = function() securecall(ToggleFrame, SpellBookFrame) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Class' });
    if(newLevel >= 10) then
        table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Talents'], func = function()
            if (not PlayerTalentFrame) then
                    LoadAddOn('Blizzard_TalentUI')
                end
                if (not GlyphFrame) then
                    LoadAddOn('Blizzard_GlyphUI')
                end
                securecall(ToggleFrame, PlayerTalentFrame)
            end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Profession' });
    end
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Achievements'], func = function() securecall(ToggleAchievementFrame) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\Minimap_shield_elite', });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Quest Log'], func = function() securecall(ToggleFrame, WorldMapFrame) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\GossipFrame\\ActiveQuestIcon' });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Guild'], func = function()
        if (IsTrialAccount()) then
            UIErrorsFrame:AddMessage(ERR_RESTRICTED_ACCOUNT, 1, 0, 0)
        else
            securecall(ToggleGuildFrame)
        end
    end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\GossipFrame\\TabardGossipIcon' });
    if(newLevel >= 15) then
        table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Group Finder'], func = function() securecall(PVEFrame_ToggleFrame, 'GroupFinderFrame') end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\LFGFRAME\\BattlenetWorking0' });
        table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['PvP'], func = function() securecall(PVEFrame_ToggleFrame, 'PVPUIFrame', HonorFrame) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' });
    end
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Collections'], func = function() securecall(ToggleCollectionsJournal) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster' });
    if(newLevel >= 15) then
        table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Adventure Guide']..'     ', func = function() securecall(ToggleEncounterJournal) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' });
    end
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Shop'], func = function() securecall(ToggleStoreUI) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Repair' });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..Loc['Swap Bags'], func = function() ToggleBagBar() end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Banker' });
end

--[[
    Handles the WoW API Events Registered Below

    @ param Frame $self The Frame that is handling the event 
    @ param string $event The WoW API Event that has been triggered
    @ param arg $... The arguments of the Event
    @ return void
]]
local function HandleEvents (self, event, ...)
    if(event == 'PLAYER_ENTERING_WORLD' or event == 'PLAYER_TALENT_UPDATE' or event == 'ACTIVE_TALENT_GROUP_CHANGED') then
        HideMicroMenu();
        UpdateMicroMenuList(UnitLevel('player'));
    end
    
    if (( event == 'WORLD_MAP_UPDATE') and WorldMapFrame:IsVisible()) then
        worldMapChanged = true;
    end
	
	if(event == 'UNIT_EXITED_VEHICLE') then
        if(... == 'player') then
            HideMicroMenu();
        end
    end

    if (event == 'PET_BATTLE_CLOSE' or event == 'PLAYER_FLAGS_CHANGED' or event == 'CINEMATIC_STOP') then
        HideMicroMenu();
    end

    if(event == 'PET_BATTLE_OPENING_START' or event == 'PET_BATTLE_OPENING_DONE') then
        Imp.ModifyFrame(CharacterMicroButton, 'TOPLEFT', MicroButtonFrame, -11, 28, nil);
    end

    if(event == 'PLAYER_LEVEL_UP') then
        local newLevel, _, _, _, _, _, _, _, _ = ...;
        UpdateMicroMenuList(newLevel);
        -- Print out hint for players on level up of unlocks, replaces the blizzard flashing thing
        if(newLevel == 10) then
            print('|cffffff00'..Loc['Talents now available under the Minimap Right-Click Menu!']);
        elseif(newLevel == 15) then
            print('|cffffff00'..Loc['Group Finder and Adventure Guide now available under the Minimap Right-Click Menu!']);
        end
    end
end

-- Register the Modules Events
MicroMenuFrame:SetScript('OnEvent', HandleEvents);
MicroMenuFrame:RegisterEvent('PLAYER_ENTERING_WORLD');
MicroMenuFrame:RegisterEvent('PLAYER_FLAGS_CHANGED');
MicroMenuFrame:RegisterEvent('PLAYER_TALENT_UPDATE');
MicroMenuFrame:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED');
MicroMenuFrame:RegisterEvent('UNIT_EXITED_VEHICLE');
MicroMenuFrame:RegisterEvent('PET_BATTLE_OPENING_START');
MicroMenuFrame:RegisterEvent('PET_BATTLE_OPENING_DONE');
MicroMenuFrame:RegisterEvent('PET_BATTLE_CLOSE');
MicroMenuFrame:RegisterEvent('PLAYER_LEVEL_UP');
MicroMenuFrame:RegisterEvent('CINEMATIC_STOP');
MicroMenuFrame:RegisterEvent('WORLD_MAP_UPDATE');

hooksecurefunc('WorldMap_ToggleSizeDown', function()
    HideMicroMenu();
end);

MicroMenuFrame:SetScript('OnUpdate', MicroMenu_Tick);
Minimap:SetScript('OnMouseUp', function(self, btn)
    if btn == 'RightButton' then
        EasyMenu(MicroMenuFrame.microMenuList, MicroMenuFrame.microMenu, 'cursor', 0, 0, 'MENU', 3);
    else
        Minimap_OnClick(self)
    end
end)