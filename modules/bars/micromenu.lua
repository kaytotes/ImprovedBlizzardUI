--[[
    modules\bars\micromenu.lua
    Hides the MicroMenu frame when not in a Vehicle or Pet Battle and replaces it with a right click menu.
]]
ImpUI_MicroMenu = ImpUI:NewModule('ImpUI_MicroMenu', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

local MicroMenuFrame = CreateFrame('Frame', nil, UIParent);

--[[
    Hides the Micro Menu by moving it off screen
    @ return void
]]
local function HideMicroMenu()
    Helpers.ModifyFrame(CharacterMicroButton, 'BOTTOMLEFT', UIParent, 5000, 2, nil);

    -- Hide Art
    MicroButtonAndBagsBar.MicroBagBar:Hide();
end

--[[
    Checks for the world map on update as when this closes Blizzard moves the micromenu
    @ return void
]]
local function MicroMenu_Tick()
    -- Blanket attempt to only show micro menu when in pet battle or vehicle.
    if (not UnitHasVehicleUI('player') and not C_PetBattles.IsInBattle() and InCombatLockdown() == false) then
        HideMicroMenu();
    end
end

--[[
    Builds the Micro Menu.
    @ return void
]]
function ImpUI_MicroMenu:BuildMicroMenu()
    MicroMenuFrame.microMenu = CreateFrame('Frame', 'RightClickMenu', UIParent, 'UIDropDownMenuTemplate');
    MicroMenuFrame.menuFont = CreateFont('menuFont');
    MicroMenuFrame.menuFont:SetFontObject(GameFontNormal);
    MicroMenuFrame.microMenuList = {}; -- Create the array
    MicroMenuFrame.bagsVisible = false;
    
    MicroMenuFrame.button = CreateFrame("Button", "MicroMenuFrameButton", MainMenuBarArtFrame, "SecureActionButtonTemplate,ActionButtonTemplate");
    MicroMenuFrame.button:SetScale(0.5);
    MicroMenuFrame.button:SetAlpha(1.0);
    MicroMenuFrame.button:SetPoint("RIGHT", 185, 0);
    MicroMenuFrame.button:SetFrameStrata("TOOLTIP");
    
    MicroMenuFrame.button:SetPushedTexture("Interface\\MINIMAP\\UI-Minimap-MinimizeButtonUp-Down");
    MicroMenuFrame.button:SetHighlightTexture("Interface\\MINIMAP\\UI-Minimap-MinimizeButtonUp-Highlight");
    MicroMenuFrame.button:SetNormalTexture("Interface\\MINIMAP\\UI-Minimap-MinimizeButtonUp-Up");
    
    MicroMenuFrame.button:SetScript("OnClick",function(self)
        ShowMicroMenu();
    end);

    MicroMenuFrame:SetScript('OnUpdate', MicroMenu_Tick);

    self:StyleMicroMenu();

    self:HookScript(UIParent, 'OnShow', function ()
        HideMicroMenu();
    end);
end

function ShowMicroMenu()
    EasyMenu(MicroMenuFrame.microMenuList, MicroMenuFrame.microMenu, MicroMenuFrame.button, 0, 90, 'MENU', 5);
end

--[[
    Style the Micro Menu Frame.
    @ return void
]]
function ImpUI_MicroMenu:StyleMicroMenu()
    local font = ImpUI.db.profile.microMenuFont;
    local size = 12;

    MicroMenuFrame.menuFont:SetFont(font, size, nil);
end

--[[
    Rebuilds the contents of the Micro Menu List
    @ param int $newLevel The new level of the Player after leveling up
    @ return void
]]
local function UpdateMicroMenuList(newLevel)
    MicroMenuFrame.microMenuList = {}; -- Clear the array

    -- Add Stuff to it
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Character'], func = function() securecall(ToggleCharacter, 'PaperDollFrame') end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle' });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Spellbook'], func = function() securecall(ToggleFrame, SpellBookFrame) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Class' });
    if(newLevel >= 10) then
        table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Talents'], func = function()
            if (not PlayerTalentFrame) then
                    LoadAddOn('Blizzard_TalentUI')
                end
                if (not GlyphFrame) then
                    LoadAddOn('Blizzard_GlyphUI')
                end
                securecall(ToggleFrame, PlayerTalentFrame)
            end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Profession' });
    end
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Achievements'], func = function() securecall(ToggleAchievementFrame) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\Minimap_shield_elite', });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Quest Log'], func = function() ToggleQuestLog() end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\GossipFrame\\ActiveQuestIcon' });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Guild'], func = function()
        if (IsTrialAccount()) then
            UIErrorsFrame:AddMessage(ERR_RESTRICTED_ACCOUNT, 1, 0, 0)
        else
            securecall(ToggleGuildFrame)
        end
    end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\GossipFrame\\TabardGossipIcon' });
    if(newLevel >= 15) then
        table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Group Finder'], func = function() securecall(PVEFrame_ToggleFrame, 'GroupFinderFrame') end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\LFGFRAME\\BattlenetWorking0' });
        table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['PvP'], func = function() securecall(PVEFrame_ToggleFrame, 'PVPUIFrame', HonorFrame) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' });
    end
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Collections'], func = function() securecall(ToggleCollectionsJournal) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster' });
    if(newLevel >= 15) then
        table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Adventure Guide']..'     ', func = function() securecall(ToggleEncounterJournal) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster' });
    end
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Shop'], func = function() securecall(ToggleStoreUI) end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Repair' });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Improved Blizzard UI'], func = function() OpenImprovedUIOptions() end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\InnKeeper' });
    table.insert(MicroMenuFrame.microMenuList, {text = '|cffFFFFFF'..L['Swap Bags'], func = function() ImpUI_Bags:ToggleBagBar() end, notCheckable = true, fontObject = MicroMenuFrame.menuFont, icon = 'Interface\\MINIMAP\\TRACKING\\Banker' });
end

--[[
	Checks the players level and updates the micro menu if needed.
	
    @ return void
]]
local function CheckLevel(event, ...)
    local newLevel, _, _, _, _, _, _, _, _ = ...;

    UpdateMicroMenuList(newLevel);

    -- Print out hint for players on level up of unlocks, replaces the blizzard flashing thing
    if(newLevel == 10) then
        print('|cffffff00'..L['Talents now available under the Micro Menu!']);
        ShowMicroMenu();
    elseif(newLevel == 15) then
        print('|cffffff00'..L['Group Finder and Adventure Guide now available under the Micro Menu!']);
        ShowMicroMenu();
    end
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_MicroMenu:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_MicroMenu:OnEnable()
    if (Helpers.IsClassic()) then return end

    ImpUI_MicroMenu:BuildMicroMenu();

    self:RegisterEvent('PLAYER_ENTERING_WORLD', function ()
        HideMicroMenu();
        UpdateMicroMenuList(UnitLevel('player'));
    end);

    self:RegisterEvent('PLAYER_FLAGS_CHANGED', HideMicroMenu);

    self:RegisterEvent('PLAYER_TALENT_UPDATE', function ()
        HideMicroMenu();
        UpdateMicroMenuList(UnitLevel('player'));
    end);

    self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', function ()
        HideMicroMenu();
        UpdateMicroMenuList(UnitLevel('player'));
    end);

    self:RegisterEvent('UNIT_EXITED_VEHICLE', function (...)
        if(... == 'player') then
            HideMicroMenu();
        end
    end);

    self:RegisterEvent('PLAYER_LEVEL_UP', CheckLevel);
    self:RegisterEvent('CINEMATIC_START', HideMicroMenu);
    self:RegisterEvent('CINEMATIC_STOP', HideMicroMenu);
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_MicroMenu:OnDisable()
end