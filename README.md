ImprovedBlizzardUI
==================

Improved Blizzard UI is an attempt to improve the default Blizzard interface. This has been customized to how I personally like my UI set up. There is some very basic configuration in game but things like positioning and scale of items still needs modifying directly in the LUA.

Only 1920x1080 is supported out of the box other resolutions will need tweaks.

Localized for enGB / enUS / ruRU (A few strings missing). See end of page for information if you would like to help localise.

# Features

### User Interface

* Slightly adjusted position and scale of the Minimap
* Removed Minimap zoom buttons and replaced with mouse wheel scrolling
* Added Player co-ordinates to the Minimap
* Added a performance counter above the Minimap
* Buffs repositioned and tweaked.
* Casting Bar Repositioned

### Unit Frames

* Player Frame, Target Frame, Focus Frame, Party Frames, Boss Frames and Arena Frames position and scale adjusted.
* Portrait Damage Spam Hidden
* Class Coloured Target and Focus Frames
* Added a Class Icon alongside Target Frame

### Combat

* Cast timer added to Casting Bar
* Low Health Warnings

### PvP

* Killing Blow Indicator
* PvP Kill Feed
* Auto-Hiding Quest Tracker
* Leave Queue button hidden on the PvP Queue popup

### Action Bars

* Action Bars (Main, Left, Right, Stance, Pet) minified and styled.
* Range / Out of Mana colours on all icons
* Replaced the Micro Menu with a Minimap Dropdown (On Right Click)
* Stripped unneccesary textures

### Chat
* Minified numerous Blizzard strings (Loot Gained, Chat Channels etc)
* Replaced chat Font
* Removed chat tab backgrounds
* Removed some chat buttons
* Increased the font size range

### Miscellaneous

* Automatically repairs damaged equipment utilising the Guild Bank where possible.
* Automatically sells grey quality loot when at an appropriate vendor.
* "Hero View" AFK Camera system. - Note: Disabled in Release Candidate
* Positioning grid overlay with `/impblizz grid`

## Git jiggy with it

ImpBlizzardUI is on Github. Pull requests are welcomed to help correct issues or suggest new features. This is also how new localisations will be submitted, a template is available in ImpBlizzardUI/loc/localization_template.lua feel free to fill it in and submit a pull request with your new / updated locale. You will be credited.
