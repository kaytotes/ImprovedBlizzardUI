Improved Blizzard UI (Battle for Azeroth Edition)
====================

### Please note that due to me no longer playing Battle for Azeroth this is not currently maintained any longer.

Improved Blizzard UI is an attempt to improve the World of Warcraft interface by styling frames, implementing additional functionality and restructuring / hiding existing elements.

This is a complete ground up rewrite using Ace3 to make porting between versions a bit easier and the upgrade process between patches smoother.

# Project Development Setup

To get a working installation of Improved Blizzard UI you must first clone the repository to a directory of your choosing. 

Execute `./setup.sh` - This will pull in all dependencies and put them in the libs folder.

This will require you to have the following:

- SVN CMD (Eg, [SlikSVN](https://sliksvn.com/download/)) 
- ZIP Extension (If on Windows install [Cygwin](https://www.cygwin.com/))
- Ability to open shell files (Eg, [Git BASH](https://gitforwindows.org/))

# Addon Installation

* To install Improved Blizzard UI place the folder into `World of Warcraft//_retail_//Interface//Addons` as you would any other addon.

# Features

## Customisation

* Once installed if need be customize your installation with `/imp`.
* Most UI elements can now be repositioned with `/imp unlock` and `/imp lock`.
* LibSharedMedia-3.0 Support for customising fonts. Any fonts loaded by LSM will be available in Improved Blizzard UI and vice versa. You may now easily use the Improved Blizzard UI in other addons such as Recount, DBM etc.

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

* Improved Fonts.

## Action Bars

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
* Kill Feed.
* Highlighted Killing Blows.
* Instant Battleground Ressurection.

# Improved Blizzard UI needs you!

Improved Blizzard UI is on [Github](https://github.com/kaytotes/ImprovedBlizzardUI) and this is where all issues should be reported. New Feature requests are always welcome as are pull requests.

# Recommended Addons

Improved Blizzard UI works best with the following addons.

* [Baud Bag](https://www.curseforge.com/wow/addons/baud-bag)
* [Storyline](https://wow.curseforge.com/projects/storyline)
