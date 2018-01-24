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
    
    Loc['Cast Bar'] = '';
    Loc['Casting Bar Timer'] = '';
    Loc['Adds a timer in seconds above the Casting Bar.'] = '';
    Loc['Casting Bar Scale'] = '';
end