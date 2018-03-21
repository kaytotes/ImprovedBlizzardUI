--[[
    localisation\template.lua

    The template that all other localisation files hould be based off of.
]]
local _, Loc = ...;

--[[
    'frFR' French (France)
    'deDE' German (Germany)
    'enGB  English (Great Brittan) if returned, can substitute 'enUS' for consistancy
    'enUS' English (America)
    'itIT' Italian (Italy)
    'koKR' Korean (Korea) RTL - right-to-left
    'zhCN' Chinese (China) (simplified) implemented LTR left-to-right in WoW
    'zhTW' Chinese (Taiwan) (traditional) implemented LTR left-to-right in WoW
    'ruRU' Russian (Russia)
    'esES' Spanish (Spain)
    'esMX' Spanish (Mexico)
    'ptBR' Portuguese (Brazil)
]]
if (GetLocale() == 'LOCALE') then

    -- Configuration
    Loc['Miscellaneous'] = '';

    Loc['Enable AFK Mode'] = '';
    Loc['After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.'] = '';

    Loc['Auto Repair'] = '';
    Loc['Automatically repairs your armour when you visit a merchant that can repair.'] = '';
    Loc['Items Repaired'] = '';

    Loc['Use Guild Bank For Repairs'] = '';
    Loc['When automatically repairing allow the use of Guild Bank funds.'] = '';
    Loc['Items Repaired from Guild Bank'] = '';

    Loc['Auto Sell Trash'] = '';
    Loc['Automatically sells any grey items that are in your inventory.']
    Loc['Sold Trash Items'] = '';

    Loc['Dynamic Objective Tracker'] = '';
    Loc['When you enter an instanced area the Objective Tracker will automatically close.'] = '';

    Loc['Chat'] = '';

    Loc['Style Chat'] = '';
    Loc['Styles the Blizzard Chat frame to better match the rest of the UI'] = '';

    Loc['Minify Blizzard Strings'] = '';
    Loc['Shortens chat messages such as Loot Received, Exp Gain, Skill Gain and Chat Channels.'] = '';

    -- Combat Strings
    Loc['Combat'] = '';

    Loc['Display Health Warnings'] = '';
    Loc['Displays a five second warning when Player Health is less than 50% and 25%.'] = '';
    Loc['HP < 50% !'] = '';
    Loc['HP < 25% !!!'] = '';

    Loc['Frames'] = '';

    Loc['Primary'] = '';

    Loc['Style Unit Frames'] = '';
    Loc['Tweaks textures and structure of Unit Frames.'] = '';
    Loc['Player and Target Frame Scale'] = '';
    
    Loc['Player Frame'] = '';
    Loc['Display Class Colours'] = '';
    Loc['Colours your Health bar to match the current class.'] = '';
    
    Loc['Hide Portrait Spam'] = '';
    Loc['Hides the damage text that appears over the Player portrait when damaged or healed.'] = '';
    Loc['Hide Out of Combat'] = '';
    Loc['Hides the Player Frame when you are out of combat, have no target and are at full health.'] = '';

    Loc['Target Frame'] = '';
    Loc['Colours Target Health bar to match their class.'] = '';
    Loc['Buffs On Top'] = '';
    Loc['Displays the Targets Buffs above the Unit Frame.'] = '';

    Loc['Target of Target Frame'] = '';
    Loc['Colours Target of Target Health bar to match their class.'] = '';

    Loc['Focus Frame'] = '';
    Loc['Colours Focus Health bar to match their class.'] = '';

    Loc['Action Bars'] = '';

    Loc['Cast Bar'] = '';
    Loc['Casting Bar Timer'] = '';
    Loc['Adds a timer in seconds above the Casting Bar.'] = '';
    Loc['Casting Bar Scale'] = '';

    Loc['Out of Range Indicator'] = '';
    Loc['When an Ability is not usable due to range the entire Button is highlighted Red.'] = '';
    
    Loc['Disabling Hides Macro Name Text and Hotkey Text from the specified Action Bar'] = '';
    Loc['Show Main Action Bar Text'] = '';
    Loc['Show Bottom Left Bar Text'] = '';
    Loc['Show Bottom Right Bar Text'] = '';
    Loc['Show Right 1 Bar Text'] = '';
    Loc['Show Right 2 Bar Text'] = '';
    Loc['Show Art'] = '';
    Loc['Toggling Hides the Action Bar Texture.'] = '';
    
    Loc['Action Bar Scale'] = '';

    Loc['Buffs and Debuffs'] = '';
    Loc['Buffs and Debuffs Scale'] = '';

    Loc['Announce Interrupts'] = '';
    Loc['When you interrupt a target your character announces this to an appropriate sound channel.'] = '';

    Loc['Mini Map'] = '';
    Loc['Display Player Co-Ordinates'] = '';
    Loc['Adds a frame to the Mini Map showing the players location in the world. Does not work in Dungeons.'] = '';

    Loc['Display System Statistics'] = '';
    Loc['Displays FPS and Latency above the Mini Map.'] = '';

    Loc['Replace Zoom Functionality'] = '';
    Loc['Hides the Zoom Buttons and enables scroll wheel zooming.'] = '';

    Loc['World Map'] = '';

    Loc['Show Instance Portals'] = '';
    Loc['Displays the location of old world Raids and Dungeons.'] = '';

    Loc['Show Cursor Co-ordinates'] = '';
    Loc['Displays the world location of where you are highlighting.'] = '';

    Loc['PvP'] = '';
    Loc['Highlight Killing Blows'] = '';
    Loc['When you get a Killing Blow in a Battleground or Arena this will be displayed prominently in the center of the screen.'] = '';
    Loc['Killing Blow!'] = '';

    Loc['Automatic Ressurection'] = '';
    Loc['When you die in a Battleground you are automatically ressurected.'] = '';

    Loc['Character'] = '';
    Loc['Spellbook'] = '';
    Loc['Talents'] = '';
    Loc['Achievements'] = '';
    Loc['Quest Log'] = '';
    Loc['Guild'] = '';
    Loc['Group Finder'] = '';
    Loc['PvP'] = '';
    Loc['Collections'] = '';
    Loc['Adventure Guide'] = '';
    Loc['Shop'] = '';
    Loc['Swap Bags'] = '';
    Loc['Talents now available under the Minimap Right-Click Menu!'] = '';
    Loc['Group Finder and Adventure Guide now available under the Minimap Right-Click Menu!'] = '';

    Loc['Target'] = '';
    Loc['Trivial'] = '';
    Loc['Normal'] = '';
    Loc['Rare'] = '';
    Loc['Elite'] = '';
    Loc['Rare Elite'] = '';
    Loc['World Boss'] = '';

    Loc['Tooltips'] = '';
    Loc['Anchor To Mouse'] = '';
    Loc['The Tooltip will always display at the mouse location.'] = '';

    Loc['Style Tooltips'] = '';
    Loc['Adjusts the Fonts and behavior of the default Tooltips.'] = '';
    
    Loc['Guild Colour'] = '';

    Loc['Hostile Border'] = '';
    Loc['Colours the Border of the Tooltip based on the hostility of the target.'] = '';

    Loc['Class Coloured Name'] = '';
    Loc['Colours the name of the Target to match their Class.'] = '';

    Loc['Show Target of Target'] = '';
    Loc['Displays who / what the unit is targeting. Coloured by Class.'] = '';
    
    Loc['Class Colour Health Bar'] = '';
    Loc['Colours the Tooltip Health Bar by Class.'] = '';

    Loc['Achievement Screenshot'] = '';
    Loc['Automatically take a screenshot upon earning an achievement.'] = '';

    Loc['Kill Feed'] = '';

    Loc['Enable Kill Feed'] = '';
    Loc['Displays a feed of the last 5 kills that occur around you when in Instances and optionally out in the World.'] = '';

    Loc['Show In World'] = '';
    Loc['Displays the Kill Feed when solo in the world.'] = '';

    Loc['Show In Dungeons'] = '';
    Loc['Displays the Kill Feed when in 5 man Dungeons.'] = '';

    Loc['Show In Raids'] = '';
    Loc['Displays the Kill Feed when in Raids.'] = '';

    Loc['Show In PvP'] = '';
    Loc['Displays the Kill Feed when in Instanced PvP (Arenas and Battlegrounds).'] = '';

    Loc['Show Casted Spell'] = '';
    Loc['Show the Spell that caused a death.'] = '';

    Loc['Show Damage'] = '';
    Loc['Show how much damage the Creature or Player took.'] = '';

    Loc['Hide When Inactive'] = '';
    Loc['Hides the Kill Feed after no new events have occured for a short period.'] = '';

    Loc['Font Size'] = '';
    Loc['Kill Feed Spacing'] = '';

    Loc[' killed '] = '';
    Loc['with'] = '';
    Loc['Melee'] = '';
end
