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
L['Player Frame'] = true;
L['Target Frame'] = true;
L['Party Frames'] = true;
L['Focus Frame'] = true;

L['Style Unit Frames'] = true;
L['Applies modified textures and font styling to the Player, Target, Party and Focus Frames. This will trigger a UI Reload!'] = true;
L['Display Class Colours'] = true;
L['Hide Portrait Spam'] = true;
L['Hides the damage text that appears over the Player portrait when damaged or healed.'] = true;
L['Hide Out of Combat'] = true;
L['Hides the Player Frame when you are out of combat, have no target and are at full health.'] = true;
L['Player Frame Scale'] = true;
L['Buffs On Top'] = true;
L['Displays the Targets Buffs above the Unit Frame.'] = true;
L['ToT Class Colours'] = true;
L['Colours Target of Target Health bar to match their class.'] = true;
L['Party Frame Scale'] = true;
L['Colours Focus Frame Health bar to match their class.'] = true;
L['Displays the Focus Targets Buffs above the Unit Frame.'] = true;
L['Focus Frame Scale'] = true;

-- Tooltips
L['Tooltips'] = true;
L['Trivial'] = true;
L['Normal'] = true;
L['Rare'] = true;
L['Elite'] = true;
L['Rare Elite'] = true;
L['World Boss'] = true;
L['Target'] = true;
L['Anchor To Mouse'] = true;
L['The tooltip will always display at the mouse location.'] = true;
L['Style Tooltips'] = true;
L['Adjusts the information and style of the default tooltips.'] = true;
L['Guild Colour'] = true;
L['The colour of the guild name display in tooltips.'] = true;
L['Hostile Border'] = true;
L['Colours the border of the tooltip based on the hostility of the target.'] = true;
L['Class Coloured Name'] = true;
L['Colours the name of the target to match their Class.'] = true;
L['Show Target of Target'] = true;
L['Displays who / what the unit is targeting. Coloured by Class.'] = true;
L['Class Colour Health Bar'] = true;
L['Colours the Tooltip Health Bar by Class.'] = true;
L['Item Rarity Border'] = true;
L['Colours the tooltip border by the rarity of the item you are inspecting.'] = true;

-- System Stats
L['System Statistics'] = true;
L['Display System Statistics'] = true;
L['Displays FPS and Latency above the Mini Map.'] = true;
L['System Statistics Size'] = true;
L['The size of the system statistics display.'] = true;

-- Fonts
L['Primary Interface Font'] = true;
L['Replaces almost every font in the Blizzard UI to this selection. This is a broad pass.'] = true;
L['A /reload may be required after updating the primary font!'] = true;

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

L['World Map'] = true;

-- Kill Feed
L['Kill Feed'] = true;
L['Enable Kill Feed'] = true;
L['Displays a feed of the last 5 kills that occur around you.'] = true;
L['Show Casted Spell'] = true;
L['Show the Spell that caused a death.'] = true;
L['Show Damage'] = true;
L['Show how much damage the Creature or Player took.'] = true;
L['Hide When Inactive'] = true;
L['Hides the Kill Feed after no new events have occured for a short period.'] = true;
L['Kill Feed Font'] = true;
L['The font used for the Kill Feed.'] = true;
L['Text Size'] = true;
L['The font size used for the Kill Feed.'] = true;
L['Spacing'] = true;
L['The vertical spacing between each row of the Kill Feed.'] = true;
L['with'] = true;
L['Melee'] = true;
L[' killed '] = true;

-- Addon
L['Test String Output'] = true;
L['/imp - Open the configuration panel.'] = true;
L['/imp grid - Toggle a grid to aid in interface element placement.'] = true;
L['/imp unlock - Unlocks the interfaces movable frames. Locking them saves position.'] = true;
L['/imp lock - Locks the interfaces movable frames.'] = true;

L['On Screen Display'] = true;
L['Scale'] = true;
L['Font Size'] = true;

-- Action Bars
L['Bars'] = true;

-- Cast Bar
L['Cast Bar'] = true;
L['Player Cast Timer'] = true;
L['Displays a Timer on the Players Cast Bar.'] = true;
L['Target Cast Timer'] = true;
L['Displays a Timer on the Targets Cast Bar.'] = true;
L['Focus Cast Timer'] = true;
L['Displays a Timer on the Focus Cast Bar.'] = true;

-- Buffs
L['Buffs & Debuffs'] = true;

-- Micro Menu
L['Character'] = true;
L['Spellbook'] = true;
L['Talents'] = true;
L['Achievements'] = true;
L['Quest Log'] = true;
L['Guild'] = true;
L['Group Finder'] = true;
L['PvP'] = true;
L['Collections'] = true;
L['Adventure Guide'] = true;
L['Shop'] = true;
L['Swap Bags'] = true;
L['Talents now available under the Micro Menu!'] = true;
L['Group Finder and Adventure Guide now available under the Micro Menu!'] = true;
L['Improved Blizzard UI'] = true;

-- Action Bars
L['Action Bars'] = true;

L['Disabling Hides Macro Name Text and Hotkey Text from the specified Action Bar'] = true;
L['Show Main Action Bar Text'] = true;
L['Show Bottom Left Bar Text'] = true;
L['Show Bottom Right Bar Text'] = true;
L['Show Right 1 Bar Text'] = true;
L['Show Right 2 Bar Text'] = true;