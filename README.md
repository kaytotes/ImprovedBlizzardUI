Improved Blizzard UI
====================

Improved Blizzard UI is an attempt to improve the World of Warcraft interface by styling frames, implementing additional functionality and restructuring / hiding existing elements.

The AddOn is compatible with both Modern WoW and Classic WoW.

# Project Development Setup

To get a working installation of Improved Blizzard UI you must first clone the repository to a directory of your choosing. 

Execute `./setup.sh` - This will pull in all dependencies and put them in the libs folder.

This will require you to have the following:

- SVN CMD (Eg, [SlikSVN](https://sliksvn.com/download/)) 
- ZIP Extension (If on Windows install [Cygwin](https://www.cygwin.com/))
- Ability to open shell files (Eg, [Git BASH](https://gitforwindows.org/))

# Addon Installation

**Modern WoW**

* To install Improved Blizzard UI place the folder into `World of Warcraft//_retail_//Interface//Addons` as you would any other addon.

**Classic WoW**

* To install Improved Blizzard UI place the folder into `World of Warcraft//_classic_//Interface//Addons` as you would any other addon.
* Enable "Load out of date AddOns" in your AddOn selection menu.

# Core Features

## Customisation

* Once installed if need be customize your installation with `/imp`.
* Most UI elements can now be repositioned with `/imp unlock` and `/imp lock`.
* LibSharedMedia-3.0 Support for customising fonts. Any fonts loaded by LSM will be available in Improved Blizzard UI and vice versa. You may now easily use the Improved Blizzard UI font in other AddOns such as Recount, DBM etc to better match this AddOn.

## Miscellaneous

* AFK 'Hero Mode' Camera View.
* Automatic Repair.
* Automatic Trash Item Sale.

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

### Party Frames

* Improved Fonts.

## Action Bars

* Out of Range Indicator.
* Customizable Texts.
* Casting Bar Repositioned and Scaled.
* Improved Fonts.
* Scaleable Buffs and Debuffs.

## Mini Map

* Moved and Re-Scaled.
* Player Co-Ordinates.
* System Performance Statistics.
* Scroll Wheel Zoom.
* Improved Fonts.

## Tooltips

* Anchored to Mouse.
* Styled Tooltips.
* Unit Hostility Border.
* Coloured Unit Guild Name, Level, Faction and Race.
* Target of Target.
* Class Coloured Health Bar and Name.
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

# Modern WoW Exclusives

## Miscellaneous

* Customisable Talking Head Frame Position.
* Guild Bank Repair Support.
* Automatic Achievement Screenshot.
* Replacement Order Hall Bar.

## Unit Frames

### Focus Frame

* Moved and Re-Scaled.
* Larger Health Bar.
* Improved Fonts.
* Class Coloured Health Bar.

## Action Bars

* Micro Menu replaced with custom drop up menu. (Right of Main Bar).
* Bags Hidden (Show with drop up menu option).

# Classic WoW Exclusives

## Unit Frames

### Party Frames

* Moved and Re-Scaled.
* Scaleable.

### Target Frame

* Added Health Text customisable with standard Blizzard "Status Text" option.
* Added Mana Text customisable with standard Blizzard "Status Text" option.

--------------------------------------

# Improved Blizzard UI needs you!

Improved Blizzard UI is on [Github](https://github.com/kaytotes/ImprovedBlizzardUI) and this is where all issues should be reported. New Feature requests are always welcome as are pull requests.

# Recommended Addons

Improved Blizzard UI works best with the following addons.

* [Baud Bag](https://www.curseforge.com/wow/addons/baud-bag)
* [Storyline](https://wow.curseforge.com/projects/storyline)

**Classic WoW**

* [ClassicAuraDurations](https://www.curseforge.com/wow/addons/classicauradurations)
* [ClassicCastbars](https://www.curseforge.com/wow/addons/classiccastbars)

# Credits

The following libraries have been used in the development of Improved Blizzard UI:

* [LibStub](https://www.wowace.com/projects/libstub)
* [Ace3](https://www.wowace.com/projects/ace3)
* [CallbackHandler-1.0](https://www.wowace.com/projects/callbackhandler)
* [LibSharedMedia-3.0](https://www.wowace.com/projects/libsharedmedia-3-0)
* [AceGUI-3.0-SharedMediaWidgets](https://www.wowace.com/projects/ace-gui-3-0-shared-media-widgets)