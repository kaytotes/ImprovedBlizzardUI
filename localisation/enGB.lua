--[[
    localisation\enGB.lua
    The English (UK) localisation of the addon.

    Essentially the default.
]]
local L = LibStub('AceLocale-3.0'):NewLocale('ImprovedBlizzardUI', 'enGB', true);

L['Miscellaneous'] = true;

-- AFK Mode
L['Enable AFK Mode'] = true;
L['After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.'] = true;

-- Auto Screenshot
L['Achievement Screenshot'] = true;
L['Automatically take a screenshot upon earning an achievement.'] = true;

-- Auto Repair
L['Auto Repair'] = true;
L['Automatically repairs your armour when you visit a merchant that can repair.'] = true;
L['Use Guild Bank For Repairs'] = true;
L['When automatically repairing allow the use of Guild Bank funds.'] = true;
L['Items Repaired from Guild Bank'] = true;
L['Items Repaired'] = true;

-- Auto Sell
L['Auto Sell Trash'] = true;
L['Automatically sells any grey items that are in your inventory.'] = true;
L['Sold Trash Items'] = true;

-- Chat
L['Chat'] = true;
L['Chat Font'] = true;
L['Outline Font'] = true;
L['Applies a thin outline to text rendered in the chat windows.'] = true;
L['Sets the font used for the chat window, tabs etc.'] = true;
L['Style Chat'] = true;
L['Styles the Blizzard Chat frame to better match the rest of the UI.'] = true;
L['Minify Blizzard Strings'] = true;
L['Shortens chat messages such as Loot Received, Exp Gain, Skill Gain and Chat Channels.'] = true;

-- Combat
L['Combat'] = true;

-- Health Warning
L['Health Warning'] = true;
L['Health Warnings'] = true;
L['Displays a five second warning when Player Health is less than 50% and 25%.'] = true;
L['Health Warning Font'] = true;
L['The font used by the Health Warning On Screen Display Message'] = true;
L['Health Warning Size'] = true;
L['The size of the Health Warning Display.'] = true;
L['50% Colour'] = true;
L['The colour of the warning that displays at 50% health.'] = true;
L['25% Colour'] = true;
L['The colour of the warning that displays at 25% health.'] = true;
L['HP < 50% !'] = true;
L['HP < 25% !!!'] = true;

-- Interrupts
L['Interrupts'] = true;
L['Announce Interrupts'] = true;
L['When you interrupt a target your character announces this to an appropriate sound channel.'] = true;
L['Chat Channel'] = true;
L['The Channel that should be used when announcing an interrupt. Auto intelligently chooses based on situation.'] = true;
L['Interrupted X on Y'] = function (spell, target)
    return 'Interrupted '..spell..' on '..target;
end

-- Killing Blows
L['Killing Blows'] = true;
L['Highlight Killing Blows'] = true;
L['When you get a Killing Blow this will be displayed prominently in the center of the screen.'] = true;
L['Killing Blow!'] = true;
L['Killing Blow Message'] = true;
L['The message that is displayed in the center of the screen.'] = true;
L['Colour'] = true;
L['The colour of the Killing Blow notification.'] = true;
L['Killing Blow Size'] = true;
L['The size of the Killing Blow notification'] = true;
L['Killing Blow Font'] = true;
L['The font used by the Killing Blow Notification.'] = true;
L['In World'] = true;
L['Notification will display in World content.'] = true;
L['In PvP'] = true;
L['Notification will display in PvP content.'] = true;
L['In Instance'] = true;
L['Notification will display in 5 Man instanced content.'] = true;
L['In Raid'] = true;
L['Notification will display in instanced raid content.'] = true;

-- Automatic Release
L['Automatic Release'] = true;
L['Automatically release your spirit when you die.'] = true;

-- Unit Frames
L['Unit Frames'] = true;

-- Tooltips
L['Tooltips'] = true;

-- Extras
L['Extras'] = true;

-- Maps
L['Maps'] = true;
L['Mini Map'] = true;
L['Player Co-ordinates'] = true;
L['Co-ordinates Font'] = true;
L['The font used by the Minimap Co-ordinates Display.'] = true;
L['The colour of the Minimap Co-ordinates Display.'] = true;
L['Co-ordinates Size'] = true;
L['The size of the Minimap Co-ordinates Display.'] = true;
L['Adds a frame to the Mini Map showing the players location in the world. Does not work in Dungeons.'] = true;
L['Zone Text Font'] = true;
L['The font used by the Minimap Zone Display'] = true;
L['Zone Text Size'] = true;
L['The size of the Minimap Zone Text Display.'] = true;
L['Clock Font'] = true;
L['The font used by the Minimap Clock Display'] = true;
L['Clock Text Size'] = true;
L['The size of the Minimap Clock Display.'] = true;

-- Action Bars
L['Action Bars'] = true;