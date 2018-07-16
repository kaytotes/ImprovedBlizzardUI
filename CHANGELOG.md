# Improved Blizzard UI Changelog

2.2.0 - German localisation (Credit @Marakuja)
2.2.0 - Pet Name Font Change
2.2.0 - Fixed an issue with the Possesion Bar placement
2.1.0 - Better Player Frame Config Check
2.1.0 - Removed unit classification from focus frame.
2.1.0 - Added timers to Target and Focus cast bars (Credit @xMarok )
2.0.4 - Tweaked position of Focus Frame and also correctly set font.
2.0.3 - Kill Artifact Bar When Leveling.
2.0.3 - Correctly get Focus Frame Unit Classification.
2.0.3 - Correctly display Focus Frame Class Colours.
2.0.2 - Added a config for hiding art
2.0.1 - Removed Dev Build Print
2.0.0 - Ground Up Rewrite. Too many changes to list.
1.9.0 - Added ptBR localisation
1.8.3 - Removed Logout and Force Quit options as they are now protected.
1.8.2 - Fixed overlapping with Order Hall bar (Credit: salindersidhu)
1.8.0 - Added Shop to MicroMenu (Credit: salindersidhu)
1.8.0 - Tweaked position of the talking head frame when the top action bar is enabled. (Credit: didehvar)
1.7.2 - Fixed an issue with the focus frame not displaying correctly on resolutions that weren't 2560x1440
1.7.1 - Removed Chat Bubble skinning since as of 7.2.0 these are protected in instances.
1.7.0 - Bumped to Patch 7.2.5.
1.7.0 - Interrupt announcements now choose channel based on grouping. (Credit: R3nd0gg)
1.7.0 - Moved Extra Action Button.
1.6.0 - German Localization updated by Marakuja
1.6.0 - Added player class colour behind PlayerFrame name section.
1.6.0 - Only actual players have class colours displayed now.
1.5.0 - Added Health Bar Colorizing (Credit: Marakuja)
1.4.0 - Moved Focus Frame
1.4.0 - Fixed chat edit box positioning when viewing the Combat Log
1.4.0 - Fixed the unclickable area next to the action bars.
1.4.0 - Added Interrupt Announcements
1.3.3 - Attempted taint fixes related to the MicroMenu.
1.3.3 - Added PvP Toggle
1.3.2 - Fixed chat font not initializing correctly on first load
1.3.1 - Fixes to make compatible with 7.1
1.3.0 - Swapped the default Class Order Hall bar with a custom replacement
1.3.0 - Fixed the /impblizz grid command
1.3.0 - Fixed a c stack overflow related to the experience bar
1.3.0 - Tweaked layout and size of config panel
1.3.0 - Styled Chat Bubbles
1.2.0 - Slightly tweaked action bar positioning
1.2.0 - Slightly tweaked party frame positioning
1.2.0 - Swapped performance counter and co-ordinates font to match the chat and bg kill feed
1.2.0 - Added a config option for hiding the chat arrows.
1.2.0 - Tweaked Honor Bar position
1.1.2 - Swapped Chat Font
1.1.2 - Fixed chat font size being reset on loading screens / relogs
1.1.1 - Fixed artifact bar hovering
1.1.0 - Removed class order hall bar. Currency can be seen under the currency tab of the player pane.
1.0.9 - Improved how class icons are detected and displayed.
Fixed minimap co-ords being generated multiple times.
Fixed display of casting bar text.
Fixed Performance Counter recreating themselves on each loading screen
AFK "Hero View" Re-Enabled
Fixed an issue with killing blows not displaying
Tweaked Buff positions due to class order halls.
Fixed a small deDE misspelling (ben2k1690)
Added Artifact bar support.
Actionbars should now adjust correctly based on reputation, exp, honor bars etc
Stancebar now adjusts position based on the presence of bottom left and right actionbars.
Added deDE localisation by ben2k1690
Minimap MicroMenu now updates based on level, unlocking features as they are required similar to the default Blizzard interface.
Honor bar moved and styled.
Slightly tweaked Battleground kill feed.
Fixed Battleground kill feed font not loading correctly.
Fixed Battleground kill feed not clearing when exiting a battleground.
Fixed a lua error when exiting vehicles.
Full rewrite
Apparently this has been printing PVEFrame open for months and months and I didn't notice. This is what happens when I unsubscribe after adding a new build.
Removed vscode folder
Made it easier to tweak action bar positon / scale.
Fixed the BG "Join Battle" button resetting to the left after every 2nd BG.
TOC bump and minor string changes.
Moved Target buffs above frame.
Nothing changed, decided to push a dev grid onto the public build as well as my own since it helps with tweaking.
Quest related crash to desktop hopefully fixed.
TOC Bump
Fixed Chat font size resetting.
Trimmed a few more global strings
Moved right end cap by 1 pixel.
Backend code change to facilitate 6.0 -> 6.1 migration
Trimmed Useless Fonts
Forced Raid Frame Class Colours.
(Hopefully) Fixed Pet Bar Taint
Chat Module Added.
Fixed PVP Group Finder window going blank after AFK mode displays.
Cleaned up localization template.
Fixed Battleground Kill Tracker Formatting Error.
Fixed pet bar issues when switching from a spec without stances to one with. Eg Disc Priest > Shadow Priest
Added cast bar timer and minor 6.1 prep.
Finally (Hopefully) fixed any pet bar positioning issues across all classes / specs.
Added Improved Blizzard UI options link to MicroMenu
Fixed incorrect TOC version.
Adjusted Boss Frame Scale and Position
Reworked Buff scaling system.
Fixed ToggleSpellbook Taint.
Minor Code Cleanup for the Cast Bar.
Stopped the config "Okay" button reloading ui even when no BlizzImp stuff has changed.
Changed Message Font (Killing Blows etc) in anticipation of Russian Localization
Forgot to remove some debug stuff
Fixed Objective Tracker Logic Bug
Scaled Boss Frames
Fixed a Blizzard bug that causes cooldowns to break when opening the fullscreen world map.
Changed Auto Repair Logic and added Guild Bank Repairs Option
Added Hide Griffin option.
Made options more pretty
Added class colours.
Added Customization Panel
Fixed bet bar and bottom left bar moving when toggling reputation bar.
Fixed Stat and Coords overlapping issues.
Fixed dk pet bar (again)
Fixed Vehicle Exit Button Position 
Added FPS by request of tehdeci
Added Minimap Coords
Added Latency Indicator
(Hopefully) Fixed Micro Menu Bar Placement Issue
Fixed Death Knight pet bar positioning.
Code cleanup.
Fixed Talent Frame Taint (Thanks jimym)
Removed Target fade in / out (Taint from UIFrameFade)
Fixed AFK Frame Taint
Fixed all known taint issues. No end user change.
Tweaked Focus Frame
Updated MiniMap menu
Hide Art Toggle
Fixed Combat Lockdown Bugs
Fixed numerous background bugs
Added BG Kills Tracker
Fixed AFK Frame briefly appearing when entering / leaving rested areas
Fixed leaky globals
Code Cleanup Complete - Killing Blow Message / Health Message reenabled.
Fixed AFK Frame (Somehow removed a relevant block of code)
Finally Fixed the Vehicle UI breaking Player Frame position.
Accidentally broke a bunch of stuff, fixed.
Code Cleanup and unnecessary XML Removed.
Fixed a slew of Combat Lock errors.
Added Player Pet to AFK Frame.
Added Fade In / Out to AFK Frame.
Added Quest Tracker PvP Collapse
Added minor Animation tweaks.
Fixed EXP Bar bug at max level.