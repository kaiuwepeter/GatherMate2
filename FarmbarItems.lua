--[[
	Farmbar Item Database
	Importiert aus GatheringTracker für Checkbox-Auswahl
]]

local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
local Farmbar = GatherMate:GetModule("Farmbar")

-- Item-Datenbank nach Kategorie gruppiert
Farmbar.AvailableItems = {
	herbalism = {
		-- Midnight
		-- (noch keine Herbs bekannt)

		-- The War Within
		{id = 210796, name = "Mycobloom", expansion = "TWW"},
		{id = 210797, name = "Mycobloom", expansion = "TWW", quality = 2},
		{id = 210798, name = "Mycobloom", expansion = "TWW", quality = 3},
		{id = 210799, name = "Arathor's Spear", expansion = "TWW"},
		{id = 210800, name = "Arathor's Spear", expansion = "TWW", quality = 2},
		{id = 210801, name = "Arathor's Spear", expansion = "TWW", quality = 3},
		{id = 210802, name = "Blessing Blossom", expansion = "TWW"},
		{id = 210803, name = "Blessing Blossom", expansion = "TWW", quality = 2},
		{id = 210804, name = "Blessing Blossom", expansion = "TWW", quality = 3},
		{id = 210805, name = "Luredrop", expansion = "TWW"},
		{id = 210806, name = "Luredrop", expansion = "TWW", quality = 2},
		{id = 210807, name = "Luredrop", expansion = "TWW", quality = 3},
		{id = 210808, name = "Orbinid", expansion = "TWW"},
		{id = 210809, name = "Orbinid", expansion = "TWW", quality = 2},
		{id = 210810, name = "Orbinid", expansion = "TWW", quality = 3},

		-- Dragonflight
		{id = 191460, name = "Hochland-Lotusblüte", expansion = "DF"},
		{id = 191461, name = "Hochland-Lotusblüte", expansion = "DF", quality = 2},
		{id = 191462, name = "Hochland-Lotusblüte", expansion = "DF", quality = 3},
		{id = 191467, name = "Blasenkelp", expansion = "DF"},
		{id = 191468, name = "Blasenkelp", expansion = "DF", quality = 2},
		{id = 191469, name = "Blasenkelp", expansion = "DF", quality = 3},
		{id = 191470, name = "Saxifrag", expansion = "DF"},
		{id = 191471, name = "Saxifrag", expansion = "DF", quality = 2},
		{id = 191472, name = "Saxifrag", expansion = "DF", quality = 3},
		{id = 191464, name = "Writhebark", expansion = "DF"},
		{id = 191465, name = "Writhebark", expansion = "DF", quality = 2},
		{id = 191466, name = "Writhebark", expansion = "DF", quality = 3},

		-- Shadowlands
		{id = 168586, name = "Rising Glory", expansion = "SL"},
		{id = 168589, name = "Marrowroot", expansion = "SL"},
		{id = 170554, name = "Vigil's Torch", expansion = "SL"},
		{id = 168583, name = "Widowbloom", expansion = "SL"},
		{id = 169701, name = "Death Blossom", expansion = "SL"},
		{id = 171315, name = "Nightshade", expansion = "SL"},

		-- BFA
		{id = 152505, name = "Riverbud", expansion = "BFA"},
		{id = 152506, name = "Star Moss", expansion = "BFA"},
		{id = 152507, name = "Winter's Kiss", expansion = "BFA"},
		{id = 152508, name = "Siren's Pollen", expansion = "BFA"},
		{id = 152509, name = "Akunda's Bite", expansion = "BFA"},
		{id = 152511, name = "Anchor Weed", expansion = "BFA"},

		-- Legion
		{id = 124101, name = "Aethril", expansion = "Legion"},
		{id = 124102, name = "Dreamleaf", expansion = "Legion"},
		{id = 124103, name = "Foxflower", expansion = "Legion"},
		{id = 124104, name = "Fjarnskaggl", expansion = "Legion"},
		{id = 124105, name = "Starlight Rose", expansion = "Legion"},
		{id = 151565, name = "Astral Glory", expansion = "Legion"},

		-- WoD
		{id = 109124, name = "Frostweed", expansion = "WoD"},
		{id = 109125, name = "Fireweed", expansion = "WoD"},
		{id = 109126, name = "Gorgrond Flytrap", expansion = "WoD"},
		{id = 109127, name = "Starflower", expansion = "WoD"},
		{id = 109128, name = "Nagrand Arrowbloom", expansion = "WoD"},
		{id = 109129, name = "Talador Orchid", expansion = "WoD"},

		-- MoP
		{id = 72234, name = "Green Tea Leaf", expansion = "MoP"},
		{id = 72235, name = "Silkweed", expansion = "MoP"},
		{id = 72237, name = "Rain Poppy", expansion = "MoP"},
		{id = 72238, name = "Golden Lotus", expansion = "MoP"},
		{id = 79010, name = "Snow Lily", expansion = "MoP"},
		{id = 79011, name = "Fool's Cap", expansion = "MoP"},

		-- Cata
		{id = 52983, name = "Cinderbloom", expansion = "Cata"},
		{id = 52984, name = "Stormvine", expansion = "Cata"},
		{id = 52985, name = "Azshara's Veil", expansion = "Cata"},
		{id = 52986, name = "Heartblossom", expansion = "Cata"},
		{id = 52987, name = "Twilight Jasmine", expansion = "Cata"},
		{id = 52988, name = "Whiptail", expansion = "Cata"},

		-- Wrath
		{id = 36901, name = "Goldclover", expansion = "Wrath"},
		{id = 36903, name = "Adder's Tongue", expansion = "Wrath"},
		{id = 36904, name = "Tiger Lily", expansion = "Wrath"},
		{id = 36905, name = "Lichbloom", expansion = "Wrath"},
		{id = 36906, name = "Icethorn", expansion = "Wrath"},
		{id = 36907, name = "Talandra's Rose", expansion = "Wrath"},
		{id = 36908, name = "Frost Lotus", expansion = "Wrath"},

		-- TBC
		{id = 22785, name = "Felweed", expansion = "TBC"},
		{id = 22786, name = "Dreaming Glory", expansion = "TBC"},
		{id = 22787, name = "Ragveil", expansion = "TBC"},
		{id = 22789, name = "Terocone", expansion = "TBC"},
		{id = 22790, name = "Ancient Lichen", expansion = "TBC"},
		{id = 22791, name = "Netherbloom", expansion = "TBC"},
		{id = 22792, name = "Nightmare Vine", expansion = "TBC"},
		{id = 22793, name = "Mana Thistle", expansion = "TBC"},

		-- Classic (wichtigste)
		{id = 2447, name = "Peacebloom", expansion = "Classic"},
		{id = 2449, name = "Earthroot", expansion = "Classic"},
		{id = 765, name = "Silverleaf", expansion = "Classic"},
		{id = 2450, name = "Briarthorn", expansion = "Classic"},
		{id = 3820, name = "Stranglekelp", expansion = "Classic"},
		{id = 3356, name = "Kingsblood", expansion = "Classic"},
		{id = 3357, name = "Liferoot", expansion = "Classic"},
		{id = 3818, name = "Fadeleaf", expansion = "Classic"},
		{id = 3821, name = "Goldthorn", expansion = "Classic"},
		{id = 3358, name = "Khadgar's Whisker", expansion = "Classic"},
		{id = 8831, name = "Purple Lotus", expansion = "Classic"},
		{id = 8838, name = "Sungrass", expansion = "Classic"},
		{id = 13463, name = "Dreamfoil", expansion = "Classic"},
		{id = 13464, name = "Golden Sansam", expansion = "Classic"},
		{id = 13465, name = "Mountain Silversage", expansion = "Classic"},
		{id = 13468, name = "Black Lotus", expansion = "Classic"},
	},

	mining = {
		-- The War Within
		{id = 210930, name = "Bismuth", expansion = "TWW"},
		{id = 210931, name = "Bismuth", expansion = "TWW", quality = 2},
		{id = 210932, name = "Bismuth", expansion = "TWW", quality = 3},
		{id = 210933, name = "Aqirite", expansion = "TWW"},
		{id = 210934, name = "Aqirite", expansion = "TWW", quality = 2},
		{id = 210935, name = "Aqirite", expansion = "TWW", quality = 3},
		{id = 210936, name = "Ironclaw Ore", expansion = "TWW"},
		{id = 210937, name = "Ironclaw Ore", expansion = "TWW", quality = 2},
		{id = 210938, name = "Ironclaw Ore", expansion = "TWW", quality = 3},
		{id = 210939, name = "Null Stone", expansion = "TWW"},

		-- Dragonflight
		{id = 189143, name = "Draconium Ore", expansion = "DF"},
		{id = 188658, name = "Draconium Ore", expansion = "DF", quality = 2},
		{id = 190395, name = "Draconium Ore", expansion = "DF", quality = 3},
		{id = 190396, name = "Serevite Ore", expansion = "DF"},
		{id = 190394, name = "Serevite Ore", expansion = "DF", quality = 2},
		{id = 190311, name = "Serevite Ore", expansion = "DF", quality = 3},

		-- Shadowlands
		{id = 171828, name = "Laestrite Ore", expansion = "SL"},
		{id = 171829, name = "Solenium Ore", expansion = "SL"},
		{id = 171830, name = "Oxxein Ore", expansion = "SL"},
		{id = 171831, name = "Phaedrum Ore", expansion = "SL"},
		{id = 171832, name = "Sinvyr Ore", expansion = "SL"},
		{id = 171833, name = "Elethium Ore", expansion = "SL"},

		-- BFA
		{id = 152512, name = "Monelite Ore", expansion = "BFA"},
		{id = 152513, name = "Platinum Ore", expansion = "BFA"},
		{id = 152579, name = "Storm Silver Ore", expansion = "BFA"},

		-- Legion
		{id = 123918, name = "Leystone Ore", expansion = "Legion"},
		{id = 123919, name = "Felslate", expansion = "Legion"},
		{id = 151564, name = "Empyrium", expansion = "Legion"},

		-- WoD
		{id = 109118, name = "Blackrock Ore", expansion = "WoD"},
		{id = 109119, name = "True Iron Ore", expansion = "WoD"},

		-- MoP
		{id = 72092, name = "Ghost Iron Ore", expansion = "MoP"},
		{id = 72093, name = "Kyparite", expansion = "MoP"},
		{id = 72094, name = "Black Trillium Ore", expansion = "MoP"},
		{id = 72103, name = "White Trillium Ore", expansion = "MoP"},

		-- Cata
		{id = 53038, name = "Obsidium Ore", expansion = "Cata"},
		{id = 52185, name = "Elementium Ore", expansion = "Cata"},
		{id = 52183, name = "Pyrite Ore", expansion = "Cata"},

		-- Wrath
		{id = 36909, name = "Cobalt Ore", expansion = "Wrath"},
		{id = 36912, name = "Saronite Ore", expansion = "Wrath"},
		{id = 36910, name = "Titanium Ore", expansion = "Wrath"},

		-- TBC
		{id = 23424, name = "Fel Iron Ore", expansion = "TBC"},
		{id = 23425, name = "Adamantite Ore", expansion = "TBC"},
		{id = 23426, name = "Khorium Ore", expansion = "TBC"},
		{id = 23427, name = "Eternium Ore", expansion = "TBC"},

		-- Classic
		{id = 2770, name = "Copper Ore", expansion = "Classic"},
		{id = 2771, name = "Tin Ore", expansion = "Classic"},
		{id = 2775, name = "Silver Ore", expansion = "Classic"},
		{id = 2772, name = "Iron Ore", expansion = "Classic"},
		{id = 2776, name = "Gold Ore", expansion = "Classic"},
		{id = 3858, name = "Mithril Ore", expansion = "Classic"},
		{id = 7911, name = "Truesilver Ore", expansion = "Classic"},
		{id = 10620, name = "Thorium Ore", expansion = "Classic"},
		{id = 11370, name = "Dark Iron Ore", expansion = "Classic"},
	},

	fishing = {
		-- The War Within
		{id = 222533, name = "Bismuth Bitterling", expansion = "TWW"},
		{id = 222534, name = "Crystalline Sturgeon", expansion = "TWW"},
		{id = 222536, name = "Specular Rainbowfish", expansion = "TWW"},
		{id = 222537, name = "Quiet River Bass", expansion = "TWW"},
		{id = 222538, name = "Awc Perch", expansion = "TWW"},
		{id = 222539, name = "Regal Dottyback", expansion = "TWW"},
		{id = 222540, name = "Roaring Anglerseeker", expansion = "TWW"},
		{id = 222541, name = "Goldengill Trout", expansion = "TWW"},
		{id = 222542, name = "Bloody Perch", expansion = "TWW"},
		{id = 222543, name = "Cursed Ghoulfish", expansion = "TWW"},
		{id = 222544, name = "Kaheti Slum Shark", expansion = "TWW"},
		{id = 222545, name = "Sanguine Dogfish", expansion = "TWW"},
		{id = 222546, name = "Pale Huskfish", expansion = "TWW"},
		{id = 222547, name = "Whispering Stargazer", expansion = "TWW"},

		-- Dragonflight
		{id = 194730, name = "Cerulean Spinefish", expansion = "DF"},
		{id = 194967, name = "Temporal Dragonhead", expansion = "DF"},
		{id = 194968, name = "Thousandbite Piranha", expansion = "DF"},
		{id = 194969, name = "Aileron Seamoth", expansion = "DF"},
		{id = 194970, name = "Scalebelly Mackerel", expansion = "DF"},
		{id = 194966, name = "Islefin Dorado", expansion = "DF"},

		-- Shadowlands
		{id = 173032, name = "Lost Sole", expansion = "SL"},
		{id = 173033, name = "Iridescent Amberjack", expansion = "SL"},
		{id = 173034, name = "Silvergill Pike", expansion = "SL"},
		{id = 173035, name = "Pocked Bonefish", expansion = "SL"},
		{id = 173036, name = "Spinefin Piranha", expansion = "SL"},
		{id = 173037, name = "Elysian Thade", expansion = "SL"},

		-- BFA
		{id = 152543, name = "Slimy Mackerel", expansion = "BFA"},
		{id = 152544, name = "Great Sea Catfish", expansion = "BFA"},
		{id = 152545, name = "Lane Snapper", expansion = "BFA"},
		{id = 152546, name = "Frenzied Fangtooth", expansion = "BFA"},
		{id = 152547, name = "Tiragarde Perch", expansion = "BFA"},
		{id = 152548, name = "Sand Shifter", expansion = "BFA"},

		-- Legion
		{id = 124107, name = "Cursed Queenfish", expansion = "Legion"},
		{id = 124108, name = "Mossgill Perch", expansion = "Legion"},
		{id = 124109, name = "Highmountain Salmon", expansion = "Legion"},
		{id = 124110, name = "Stormray", expansion = "Legion"},
		{id = 124111, name = "Runescale Koi", expansion = "Legion"},
		{id = 124112, name = "Black Barracuda", expansion = "Legion"},

		-- WoD
		{id = 111595, name = "Crescent Saberfish", expansion = "WoD"},
		{id = 111664, name = "Abyssal Gulper Eel", expansion = "WoD"},
		{id = 111665, name = "Sea Scorpion", expansion = "WoD"},
		{id = 111666, name = "Fire Ammonite", expansion = "WoD"},
		{id = 111667, name = "Blind Lake Sturgeon", expansion = "WoD"},

		-- MoP
		{id = 74856, name = "Emperor Salmon", expansion = "MoP"},
		{id = 74857, name = "Jade Lungfish", expansion = "MoP"},
		{id = 74859, name = "Golden Carp", expansion = "MoP"},
		{id = 74860, name = "Reef Octopus", expansion = "MoP"},
		{id = 74861, name = "Krasarang Paddlefish", expansion = "MoP"},

		-- Cata
		{id = 53062, name = "Sharptooth", expansion = "Cata"},
		{id = 53063, name = "Mountain Trout", expansion = "Cata"},
		{id = 53064, name = "Highland Guppy", expansion = "Cata"},
		{id = 53066, name = "Blackbelly Mudfish", expansion = "Cata"},
		{id = 53067, name = "Striped Lurker", expansion = "Cata"},
		{id = 53068, name = "Lavascale Catfish", expansion = "Cata"},

		-- Wrath
		{id = 41800, name = "Deep Sea Monsterbelly", expansion = "Wrath"},
		{id = 41801, name = "Moonglow Cuttlefish", expansion = "Wrath"},
		{id = 41802, name = "Imperial Manta Ray", expansion = "Wrath"},
		{id = 41805, name = "Borean Man O' War", expansion = "Wrath"},
		{id = 41806, name = "Musselback Sculpin", expansion = "Wrath"},
		{id = 41807, name = "Dragonfin Angelfish", expansion = "Wrath"},
		{id = 41809, name = "Glacial Salmon", expansion = "Wrath"},
		{id = 41810, name = "Fangtooth Herring", expansion = "Wrath"},
		{id = 41814, name = "Glassfin Minnow", expansion = "Wrath"},

		-- TBC
		{id = 27422, name = "Barbed Gill Trout", expansion = "TBC"},
		{id = 27425, name = "Spotted Feltail", expansion = "TBC"},
		{id = 27429, name = "Zangarmarsh Sporefish", expansion = "TBC"},
		{id = 27435, name = "Figluster's Mudfish", expansion = "TBC"},
		{id = 27437, name = "Icefin Bluefish", expansion = "TBC"},
		{id = 27438, name = "Golden Darter", expansion = "TBC"},
		{id = 27439, name = "Furious Crawdad", expansion = "TBC"},

		-- Classic
		{id = 6291, name = "Raw Brilliant Smallfish", expansion = "Classic"},
		{id = 6289, name = "Raw Longjaw Mud Snapper", expansion = "Classic"},
		{id = 6308, name = "Raw Bristle Whisker Catfish", expansion = "Classic"},
		{id = 6317, name = "Raw Loch Frenzy", expansion = "Classic"},
		{id = 21071, name = "Raw Sagefish", expansion = "Classic"},
	},

	logging = {
		-- Midnight
		{id = 256963, name = "Thalassian Lumber", expansion = "Midnight"},

		-- The War Within
		{id = 248012, name = "Dornic Fir Lumber", expansion = "TWW"},

		-- Dragonflight
		{id = 251773, name = "Dragonpine Lumber", expansion = "DF"},

		-- Shadowlands
		{id = 251772, name = "Arden Lumber", expansion = "SL"},

		-- BFA
		{id = 251768, name = "Darkpine Lumber", expansion = "BFA"},

		-- Legion
		{id = 251767, name = "Fel-Touched Lumber", expansion = "Legion"},

		-- WoD
		{id = 251766, name = "Shadowmoon Lumber", expansion = "WoD"},

		-- MoP
		{id = 251763, name = "Bamboo Lumber", expansion = "MoP"},

		-- Cata
		{id = 251764, name = "Ashwood Lumber", expansion = "Cata"},

		-- Wrath
		{id = 251762, name = "Coldwind Lumber", expansion = "Wrath"},

		-- TBC
		{id = 242691, name = "Olemba Lumber", expansion = "TBC"},

		-- Classic
		{id = 245586, name = "Ironwood Lumber", expansion = "Classic"},
	},
}

-- Hilfsfunktion: Hole alle Items für eine Kategorie
function Farmbar:GetAvailableItemsForCategory(categoryKey)
	return self.AvailableItems[categoryKey] or {}
end

-- Hilfsfunktion: Gruppiere Items nach Expansion
function Farmbar:GetItemsByExpansion(categoryKey)
	local items = self:GetAvailableItemsForCategory(categoryKey)
	local byExpansion = {}

	for _, item in ipairs(items) do
		local exp = item.expansion or "Other"
		if not byExpansion[exp] then
			byExpansion[exp] = {}
		end
		table.insert(byExpansion[exp], item)
	end

	return byExpansion
end
