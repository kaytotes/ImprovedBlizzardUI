Improved Blizzard UI
====================

Improved Blizzard UI is an attempt to improve the World of Warcraft interface by styling frames, implementing additional functionality and restructuring / hiding existing elements.

This has been customized to out of the box be how I personally like my UI set up however there is extensive configuration available in game by using `/imp`. This interface is primarily tested at 2560x1400 but should largely work at any resolution.

# Project Development Setup

To get a working installation of Improved Blizzard UI you must first clone the repository to a directory of your choosing. From there `cd` into the `.release` directory.

Execute `./release.sh`

After a short while a configured and ready to go version of ImprovedBlizzardUI including a .zip file will be present in the `.release` directory.

# Addon Installation

* To install Improved Blizzard UI place the folder into `World of Warcraft//Interface//Addons` as you would any other addon.
* Once installed if need be customize your installation with `/imp`.

# Features

## Miscellaneous

* AFK 'Hero Mode' Camera View.
* Automatic Repair (From Guild Bank If Available).
* Automatic Trash Item Sale
* Dynamic Objective Tracker (Hides when entering Instanced Content).
* Automatic Achievement Screenshot.
* Replacement Order Hall Bar.

## Unit Frames

### Player Frame

* Moved and Re-Scaled.
* Larger Health Bar.
* Scaleable.
* Class Coloured Health Bar.
* Hidden Portrait Text Spam.
* Hidden when out of Combat (Without Target / Low Health).
* Improved Fonts.

### Target Frame

* Moved and Re-Scaled.
* Larger Health Bar.
* Scaleable.
* Class Coloured Health Bar.
* Improved Fonts.
* Buffs on Top.

### Target of Target

* Improved Fonts.
* Scaleable.
* Class Coloured Health Bar.

### Focus Frame

* Moved and Re-Scaled.
* Larger Health Bar.
* Improved Fonts.
* Class Coloured Health Bar.

### Party Frames

* Moved and Re-Scaled.
* Improved Fonts.

## Action Bars

* Interface from Battle for Azeroth Recreated and Improved.
* Customizable Scale.
* Out of Range Indicator.
* Customizable Texts.
* Casting Bar Repositioned and Scaled.
* Improved Fonts.
* Scaleable Buffs and Debuffs.
* Micro Menu and Bags Hidden (Show with Mini Map Menu).

## Mini Map

* Moved and Re-Scaled.
* Player Co-Ordinates.
* System Performance Statistics.
* Scroll Wheel Zoom.
* Improved Fonts.
* Right Click Micro Menu.

## World Map

* Old World Instance / Raid Portals.
* Cursor World Co-Ordinates.

## Tooltips

* Anchored to Mouse.
* Styled Tooltips.
* Unit Hostility Border.
* Coloured Unit Guild Name, Level, Faction and Race.
* Target of Target.
* Class Coloured Health Bar and Name.
* Customizable Font Size.
* Improved Font.
* Item Rarity Border.

## Chat

* Improved Chat Font.
* Shortened Blizzard Strings (Loot, Exp Gain, Profession Levels etc).

## Combat

* Low Health Warnings (50% and 25%).
* Interrupt Announcements.
* Instanced Content Player Kill Feed.

## PvP

* Highlighted Killing Blows.
* Instant Battleground Ressurection.

# Improved Blizzard UI needs you!

Improved Blizzard UI is on [Github](https://github.com/kaytotes/ImprovedBlizzardUI) and this is where all issues should be reported. New Feature requests are always welcome as are pull requests.

Localisation help is currently needed most. New Localisation templates can be submitted via Github pull requests. The template for these is available in `localisation/template.lua`.

# Recommended Addons

Improved Blizzard UI works best with the following addons.

* [Baud Bag](https://www.curseforge.com/wow/addons/baud-bag)
* [Storyline](https://wow.curseforge.com/projects/storyline)
* [DynamicCam](https://wow.curseforge.com/projects/dynamiccam)
