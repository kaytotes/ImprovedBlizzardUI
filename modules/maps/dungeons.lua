--[[
    modules\maps\dungeons.lua
    Displays Dungeon & Raid Portals on the World Map
]]
local addonName, Loc = ...;

local DungeonsFrame = CreateFrame('Frame', nil, UIParent);

local portalList = {
    -- Dungeons: Eastern Kingdoms
    {name = Loc['Baradin Hold'], id = 752, continent = 732, zone = 708, x = -1204, y = 1079, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Blackrock Caverns'], id = 753, continent = 0, zone = 28, x = -7615, y = -1242, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackrock Caverns'], id = 753, continent = 0, zone = 29, x = -7615, y = -1242, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackrock Caverns'], id = 753, continent = 0, zone = 28, x = -7570, y = -1328, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackrock Caverns'], id = 753, continent = 0, zone = 29, x = -7570, y = -1328, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackrock Depths'], id = 704, continent = 0, zone = 28, x = -7179, y = -922, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackrock Depths'], id = 704, continent = 0, zone = 29, x = -7179, y = -922, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackrock Mountain'], id = nil, continent = 0, zone = 29, x = -7781, y = -1128, type = 'Raid', desc = Loc['Blackrock Caverns'] .. ', ' .. Loc['Blackrock Spire'] .. ',|n' .. Loc['Blackrock Depths'] .. ', ' .. Loc['Blackwing Lair'] .. ',|n' .. Loc['Molten Core']},
    {name = Loc['Blackrock Mountain'], id = nil, continent = 0, zone = 28, x = -7365, y = -1101, type = 'Raid', desc = Loc['Blackrock Caverns'] .. ', ' .. Loc['Blackrock Spire'] .. ',|n' .. Loc['Blackrock Depths'] .. ', ' .. Loc['Blackwing Lair'] .. ',|n' .. Loc['Molten Core']},
    {name = Loc['Blackrock Spire'], id = nil, continent = 0, zone = 28, x = -7524, y = -1230, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackrock Spire'], id = nil, continent = 0, zone = 29, x = -7524, y = -1230, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackwing Descent'], id = 754, continent = 0, zone = 29, x = -7538, y = -1196, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Blackwing Lair'], id = 755, continent = 0, zone = 28, x = -7662, y = -1218, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackwing Lair'], id = 755, continent = 0, zone = 29, x = -7662, y = -1218, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Gnomeregan'], id = 691, continent = 0, zone = 27, x = -5184, y = 603, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Gnomeregan'], id = 691, continent = 0, zone = 895, x = -5183, y = 598, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Gnomeregan'], id = 691, continent = 0, zone = 27, x = -5145, y = 898, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Grim Batol'], id = 757, continent = 0, zone = 700, x = -4058, y = -3450, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Karazhan'], id = 799, continent = 0, zone = 32, x = -11111, y = -2006, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Lower Blackrock Spire'], id = 721, continent = 0, zone = 28, x = -7518, y = -1334, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Lower Blackrock Spire'], id = 721, continent = 0, zone = 29, x = -7518, y = -1334, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Magisters\' Terrace'], id = 798, continent = 530, zone = 499, x = 12884, y = -7333, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Molten Core'], id = 696, continent = 0, zone = 28, x = -7509, y = -1040, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Molten Core'], id = 696, continent = 0, zone = 29, x = -7509, y = -1040, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Molten Core'], id = 696, continent = 0, zone = 28, x = -7509, y = -1040, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Molten Core'], id = 696, continent = 0, zone = 29, x = -7509, y = -1040, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Return to Karazhan'], id = 1115, continent = 0, zone = 32, x = -11037, y = -2001, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Scarlet Halls'], id = 871, continent = 0, zone = 20, x = 2867, y = -822, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Scarlet Monastery'], id = nil, continent = 0, zone = 20, x = 2828, y = -698, type = 'Dungeon', desc = Loc['Scarlet Monastery'] .. ', ' .. Loc['Scarlet Halls']},
    {name = Loc['Scarlet Monastery'], id = 874, continent = 0, zone = 20, x = 2916, y = -802, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Scholomance'], id = 898, continent = 0, zone = 22, x = 1262, y = -2581, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Shadowfang Keep'], id = 764, continent = 0, zone = 21, x = -233, y = 1564, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Stratholme: Crusader\'s Square'], id = 765, continent = 0, zone = 23, x = 3391, y = -3407, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Stratholme: The Gauntlet'], id = 765.2, continent = 0, zone = 23, x = 3183, y = -4038, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Sunwell Plateau'], id = 789, continent = 530, zone = 499, x = 12559, y = -6774, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Temple of Atal\'Hakkar'], id = 687, continent = 0, zone = 38, x = -10429, y = -3829, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Bastion of Twilight'], id = 758, continent = 0, zone = 700, x = -4895, y = -4230, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['The Deadmines'], id = 756, continent = 0, zone = 39, x = -11075, y = 1527, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Deadmines'], id = 756, continent = 0, zone = 39, x = -11207, y = 1674, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Stockade'], id = 690, continent = 0, zone = 301, x = -8806, y = 813, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Stockade'], id = 690, continent = 0, zone = 30, x = -8806, y = 813, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Throne of the Tides'], id = 767, continent = 0, zone = 613, x = -5720, y = 5345, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Throne of the Tides'], id = 767, continent = 0, zone = 614, x = -5720, y = 5345, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Uldaman'], id = 692, continent = 0, zone = 17, x = -6093, y = -3183, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Uldaman'], id = 692, continent = 0, zone = 17, x = -6065, y = -2955, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Upper Blackrock Spire'], id = 995, continent = 0, zone = 28, x = -7487, y = -1324, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Upper Blackrock Spire'], id = 995, continent = 0, zone = 29, x = -7487, y = -1324, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Zul\'Aman'], id = 781, continent = 530, zone = 463, x = 6851, y = -7991, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Zul\'Gurub'], id = 793, continent = 0, zone = 37, x = -11915, y = -1207, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Zul\'Gurub'], id = 793, continent = 0, zone = 689, x = -11915, y = -1207, type = 'Dungeon', desc = Loc['Dungeon']},

    -- Dungeons: Kalimdor
    {name = Loc['Blackfathom Deeps'], id = 688, continent = 1, zone = 43, x = 4137, y = 887, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Caverns of Time'], id = nil, continent = 1, zone = 161, x = -8172, y = -4746, type = 'Raid', desc = Loc['Black Morass'] .. ', ' .. Loc['Culling of Stratholme'] .. ',|n' .. Loc['Dragon Soul'] .. ', ' .. Loc['End Time'] .. ', ' .. Loc['Hour of Twilight'] .. ',|n' .. Loc['Hyjal Summit'] .. ', ' .. Loc['Old Hillsbrad Foothills'] .. ',|n' .. Loc['Well of Eternity']},
    {name = Loc['Dire Maul: Capital Gardens'], id = 699.2, continent = 1, zone = 121, x = -3767, y = 1249, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Dire Maul: Gordok Commons'], id = 699, continent = 1, zone = 121, x = -3520, y = 1101, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Dire Maul: Warpwood Quarter'], id = 699.5, continent = 1, zone = 121, x = -3769, y = 934, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Firelands'], id = 800, continent = 1, zone = 606, x = 3988, y = -2944, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Halls of Origination'], id = 759, continent = 1, zone = 720, x = -10182, y = -1996, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Lost City of the Tol\'vir'], id = 747, continent = 1, zone = 720, x = -10681, y = -1307, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Maraudon'], id = 750, continent = 1, zone = 101, x = -1422, y = 2922, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Maraudon: Earth Song Falls'], id = 750.2, continent = 1, zone = 101, x = -1379, y = 2915, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Maraudon: Foulspore Cavern'], id = 750, continent = 1, zone = 101, x = -1473, y = 2617, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Maraudon: The Wicked Grotto'], id = 750, continent = 1, zone = 101, x = -1182, y = 2876, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Onyxia\'s Lair'], id = 718, continent = 1, zone = 141, x = -4718, y = -3734, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Ragefire Chasm'], id = 680, continent = 1, zone = 4, x = 1816, y = -4418, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Ragefire Chasm'], id = 680, continent = 1, zone = 321, x = 1815, y = -4418, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Razorfen Downs'], id = 760, continent = 1, zone = 61, x = -4722, y = -2342, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Razorfen Kraul'], id = 761, continent = 1, zone = 607, x = -4465, y = -1666, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Ruins of Ahn\'Qiraj'], id = 717, continent = 1, zone = 261, x = -8414, y = 1504, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Ruins of Ahn\'Qiraj'], id = 717, continent = 1, zone = 772, x = -8414, y = 1504, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Temple of Ahn\'Qiraj'], id = 766, continent = 1, zone = 261, x = -8236, y = 1993, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Temple of Ahn\'Qiraj'], id = 766, continent = 1, zone = 772, x = -8236, y = 1993, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['The Vortex Pinnacle'], id = 769, continent = 1, zone = 720, x = -11514, y = -2311, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Throne of the Four Winds'], id = 773, continent = 1, zone = 720, x = -11354, y = 59, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Wailing Caverns'], id = 749, continent = 1, zone = 11, x = -837, y = -2033, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Wailing Caverns'], id = 749, continent = 1, zone = 11, x = -742, y = -2216, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Zul\'Farrak'], id = 686, continent = 1, zone = 161, x = -6798, y = -2891, type = 'Dungeon', desc = Loc['Dungeon']},

    -- Dungeons: Caverns of Time
    {name = Loc['Dragon Soul'], id = 824, continent = 1, zone = 161, x = -8267, y = -4514, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['End Time'], id = 820, continent = 1, zone = 161, x = -8293, y = -4458, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Hour of Twilight'], id = 819, continent = 1, zone = 161, x = -8292, y = -4584, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Hyjal Summit'], id = 775, continent = 1, zone = 161, x = -8171, y = -4168, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Old Hillsbrad Foothills'], id = 734, continent = 1, zone = 161, x = -8348, y = -4060, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Black Morass'], id = 733, continent = 1, zone = 161, x = -8752, y = -4194, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Culling of Stratholme'], id = 521, continent = 1, zone = 161, x = -8755, y = -4454, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Well of Eternity'], id = 816, continent = 1, zone = 161, x = -8595, y = -4004, type = 'Dungeon', desc = Loc['Dungeon']},

    -- Dungeons: Outland
    {name = Loc['Auchenai Crypts'], id = 722, continent = 530, zone = 478, x = -3361, y = 5136, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Black Temple'], id = 796, continent = 530, zone = 473, x = -3648, y = 318, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Coilfang Reservoir'], id = nil, continent = 530, zone = 467, x = 562, y = 6942, type = 'Raid', desc = Loc['Serpentshrine Cavern'] .. ', ' .. Loc['Slave Pens'] .. ',|n' .. Loc['Steamvault'] .. ', ' .. Loc['Underbog']},
    {name = Loc['Gruul\'s Lair'], id = 776, continent = 530, zone = 475, x = 3530, y = 5121, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Hellfire Ramparts'], id = 797, continent = 530, zone = 465, x = -363, y = 3078, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Magtheridon\'s Lair'], id = 779, continent = 530, zone = 465, x = -339, y = 3132, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Mana-Tombs'], id = 732, continent = 530, zone = 478, x = -3168, y = 4943, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Sethekk Halls'], id = 723, continent = 530, zone = 478, x = -3362, y = 4750, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Shadow Labyrinth'], id = 724, continent = 530, zone = 478, x = -3554, y = 4943, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Arcatraz'], id = 731, continent = 530, zone = 479, x = 3309, y = 1337, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Blood Furnace'], id = 725, continent = 530, zone = 465, x = -301, y = 3160, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Botanica'], id = 729, continent = 530, zone = 479, x = 3409, y = 1486, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Eye'], id = 782, continent = 530, zone = 479, x = 3087, y = 1379, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['The Mechanar'], id = 730, continent = 530, zone = 479, x = 2865, y = 1549, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Shattered Halls'], id = 710, continent = 530, zone = 465, x = -309, y = 3076, type = 'Dungeon', desc = Loc['Dungeon']},

    -- Dungeons: Northrend
    {name = Loc['Azjol-Nerub'], id = nil, continent = 571, zone = 488, x = 3727, y = 2152, type = 'Dungeon', desc = Loc['Azjol-Nerub'] .. ', ' .. Loc['The Old Kingdom']},
    {name = Loc['Drak\'Tharon Keep'], id = 534, continent = 571, zone = 490, x = 4574, y = -2029, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Drak\'Tharon Keep'], id = 534, continent = 571, zone = 496, x = 4882, y = -2046, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Gundrak'], id = 530, continent = 571, zone = 496, x = 6965, y = -4407, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Gundrak (rear entrance)'], id = 530, continent = 571, zone = 496, x = 6709, y = -4654, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Halls of Lightning'], id = 525, continent = 571, zone = 495, x = 9176, y = -1377, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Halls of Stone'], id = 526, continent = 571, zone = 495, x = 8922, y = -979, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Icecrown Citadel'], id = 604, continent = 571, zone = 492, x = 5855, y = 2103, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Naxxramas'], id = 535, continent = 571, zone = 488, x = 3668, y = -1260, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['The Frozen Halls'], id = nil, continent = 571, zone = 492, x = 5691, y = 2143, type = 'Dungeon', desc = Loc['The Forge of Souls'] .. ', ' .. Loc['The Pit of Saron'] .. ',|n' .. Loc['The Halls of Reflection']},
    {name = Loc['The Nexus'], id = nil, continent = 571, zone = 486, x = 3864, y = 6986, type = 'Raid', desc = Loc['The Nexus'] .. ', ' .. Loc['The Oculus'] .. ',|n' .. Loc['The Eye of Eternity']},
    {name = Loc['The Violet Hold'], id = 536, continent = 571, zone = 504, x = 5690, y = 500, type = 'Dungeon', desc = Loc['Dungeon'], level = 1},
    {name = Loc['Trial of the Champion'], id = 542, continent = 571, zone = 492, x = 8571, y = 792, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Trial of the Crusader'], id = 543, continent = 571, zone = 492, x = 8515, y = 733, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Ulduar'], id = 529, continent = 571, zone = 495, x = 9348, y = -1114, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Utgarde Keep'], id = 523, continent = 571, zone = 491, x = 1101, y = -4903, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Utgarde Pinnacle'], id = 524, continent = 571, zone = 491, x = 1240, y = -4857, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Vault of Archavon'], id = 532, continent = 571, zone = 501, x = 5377, y = 2840, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Wyrmrest Temple'], id = nil, continent = 571, zone = 488, x = 3672, y = 289, type = 'Raid', desc = Loc['The Ruby Sanctum'] .. ', ' .. Loc['The Obsidian Sanctum']},

    -- Dungeons: Deepholm
    {name = Loc['The Stonecore'], id = 768, continent = 646, zone = 640, x = 1024, y = 637, type = 'Dungeon', desc = Loc['Dungeon']},

    -- Dungeons: Pandaria
    {name = Loc['Gate of the Setting Sun'], id = 875, continent = 870, zone = 811, x = 694, y = 2080, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Heart of Fear'], id = 897, continent = 870, zone = 858, x = 166, y = 4060, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Mogu\'shan Palace'], id = 885, continent = 870, zone = 811, x = 1392, y = 436, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Mogu\'shan Vaults'], id = 896, continent = 870, zone = 809, x = 3982, y = 1109, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Shado-Pan Monastery'], id = 877, continent = 870, zone = 809, x = 3636, y = 2536, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Siege of Niuzao Temple'], id = 887, continent = 870, zone = 810, x = 1435, y = 5086, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Siege of Orgrimmar'], id = 953, continent = 870, zone = 811, x = 1203, y = 644, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Stormstout Brewery'], id = 876, continent = 870, zone = 807, x = -712, y = 1263, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Temple of the Jade Serpent'], id = 867, continent = 870, zone = 806, x = 960, y = -2468, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Terrace of Endless Spring'], id = 886, continent = 870, zone = 873, x = 955, y = -56, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Throne of Thunder'], id = 930, continent = 1064, zone = 928, x = 7253, y = 5026, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Throne of Thunder'], id = 930, continent = 870, zone = 810, x = 1926, y = 4222, type = 'Raid', desc = Loc['Portal']},

    -- Throne of Thunder
    {name = Loc['Eternal Guardian'], id = nil, continent = 1098, zone = 930, x = 6288, y = 4922, type = 'Misc'},
    {name = Loc['Eternal Guardian'], id = nil, continent = 1098, zone = 930, x = 6110, y = 4670, type = 'Misc'},
    {name = Loc['Eternal Guardian'], id = nil, continent = 1098, zone = 930, x = 6495, y = 4741, type = 'Misc'},

    -- Dungeons: Draenor
    {name = Loc['Auchindoun'], id = 984, continent = 1116, zone = 946, x = 1489, y = 3079, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Blackrock Foundry'], id = 988, continent = 1116, zone = 949, x = 8029, y = 870, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Bloodmaul Slag Mines'], id = 964, continent = 1116, zone = 941, x = 7266, y = 4458, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Grimrail Depot'], id = 993, continent = 1116, zone = 949, x = 7840, y = 551, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Hellfire Citadel'], id = 1026, continent = 1116, zone = 945, x = 4058, y = -683, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Highmaul'], id = 994, continent = 1116, zone = 950, x = 3471, y = 7434, type = 'Raid', desc = Loc['Raid']},
    {name = Loc['Iron Docks'], id = 987, continent = 1116, zone = 949, x = 8854, y = 1359, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Shadowmoon Burial Grounds'], id = 969, continent = 1116, zone = 947, x = 766, y = 128, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['Skyreach'], id = 989, continent = 1116, zone = 948, x = 27, y = 2525, type = 'Dungeon', desc = Loc['Dungeon']},
    {name = Loc['The Everbloom'], id = 1008, continent = 1116, zone = 949, x = 7110, y = 197, type = 'Dungeon', desc = Loc['Dungeon']},

    -- Dungeons: Legion
    {name = Loc['Violet Hold'], id = 1066, continent = 1220, zone = 1014, x = -959, y = 4328, type = 'Dungeon', desc = Loc['Dungeon']},

};

local icons = {};

local function GetTexture(type)
    if (type == 'Dungeon') then
        return 'Interface\\Minimap\\Dungeon';
    elseif (type == 'Raid') then
        return 'Interface\\Minimap\\Raid';
    else
        return 'Interface\\MINIMAP\\TempleofKotmogu_ball_orange';
    end
end

local function UpdateMap()
    if (WorldMapFrame:IsVisible()) then
        -- Get the info we need
        local zoneId = GetCurrentMapAreaID();
        local continentId = GetAreaMapInfo(zoneId);

        for i, portal in pairs(portalList) do
            if (zoneId == portal.zone and continentId == portal.continent) then -- We're on the right map page
                -- Create the Icons
                if (not icons[i]) then
                    local icon = CreateFrame('Button', nil, WorldMapPOIFrame);
                    icons[i] = icon; -- Store it

                    -- Set icon properties
                    icon:SetSize(20, 20);
                    icon.Texture = icon:CreateTexture(icons[i..'Texture'], 'BACKGROUND');
                    icon.Texture:ClearAllPoints();
                    icon.Texture:SetPoint('CENTER', icon);
                    icon.Texture:SetTexture(GetTexture(portal.type));
                    icon.Texture:SetTexCoord(0, 1, 0, 1);
                    icon.Texture:SetSize(30, 30);

                    -- If we have a link then create that too
                    if (portal.id) then icon:SetHighlightTexture(GetTexture(portal.type)) end

                    icon.HighlightTexture = icon:CreateTexture(icons[i..'HighlightTexture'], 'HIGHLIGHT')
                    icon:SetScript('OnEnter', WorldMapPOI_OnEnter);
                    icon:SetScript('OnLeave', WorldMapPOI_OnLeave);
                    icon:SetScript('OnClick', function()
                        if (portal.id) then
                            SetMapByID(portal.id);
                        end
                    end)
                    icon.name = portal.name;
                    icon.poiID = 0;
                    icon.description = portal.desc;
                end

                -- Actually show the Icon
                local void, left, top, right, bottom = GetCurrentMapZone();

                if (left and top and right and bottom) then
                    local level, minY, minX, maxY, maxX = GetCurrentMapDungeonLevel();

                    if (FramesDB.showMapDungeons) then
                        if minY and minX and maxY and maxX then
                            WorldMapPOIFrame_AnchorPOI(icons[i], (maxY - portal.y) / abs(maxY - minY), (maxX - portal.x) / abs(maxX - minX), 201)
                        else
                            WorldMapPOIFrame_AnchorPOI(icons[i], (left - portal.y) / abs(right - left), (top - portal.x) / abs(bottom - top), 201)
                        end

                        icons[i]:Show();
                    else
                        icons[i]:Hide();
                    end
                end
            else
                -- Hide any buttons we shouldn't be able to see
                if (icons[i] and icons[i]:IsShown()) then
                    icons[i]:Hide();
                end
            end
        end
    end
end

hooksecurefunc('WorldMapFrame_Update', UpdateMap);