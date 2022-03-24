local _, addon = ...

-- Info: The strings assigned to name and phonetic_name are only used for external sound file generation script
-- neural voices use name, legacy sound uses phonetic_name - if present
-- Shoutout to the OmniCD Devs!

local spellList = {
	["DRUID"] = {
		[740] =	{ name = "Tranquility", phonetic_name = "", type = "raidDefensive"},
		[5211] =	{ name = "Bash", phonetic_name = "", type = "cc"},
		[20484] =	{ name = "Rebirth", phonetic_name = "", type = "other"},
		[22812] =	{ name = "Barkskin", phonetic_name = "", type = "defensive"},
		[22842] =	{ name = "Frenzied Regeneration", phonetic_name = "", type = "defensive"},
		[29166] =	{ name = "Innervate", phonetic_name = "Enervaite", type = "other"},
		[33786] =	{ name = "Cyclone", phonetic_name = "", type = "disarm"},
	},
	["HUNTER"] = {
		[5384] =	{ name = "Feign Death", phonetic_name = "", type = "other"},
		[19574] =	{ name = "Bestial Wrath", phonetic_name = "", type = "offensive"},
		[19577] =	{ name = "Intimidation", phonetic_name = "", type = "cc"},
		[19801] =	{ name = "Tranquilizing Shot", phonetic_name = "", type = "dispel"},
	},
	["MAGE"] = {
		[118] =		{ name = "Polymorph", phonetic_name = "", type = "cc"},
		[11426] =	{ name = "Ice Barrier", phonetic_name = "", type = "defensive"},
		[12042] =	{ name = "Arcane Power", phonetic_name = "", type = "offensive"},
		[12472] =	{ name = "Icy Veins", phonetic_name = "", type = "offensive"},
		[11958] =	{ name = "Ice Block", phonetic_name = "", type = "immunity"},
	},
	["PALADIN"] = {
		[642] =		{ name = "Divine Shield", phonetic_name = "", type = "immunity"},
		[498] =		{ name = "Divine Protection", phonetic_name = "", type = "defensive"},
		[633] =		{ name = "Lay on Hands", phonetic_name = "", type = "defensive"},
		[853] =		{ name = "Hammer of Justice", phonetic_name = "", type = "cc"},
		[1022] = 	{ name = "Protection", phonetic_name = "", type = "externalDefensive"},
		[6940] = 	{ name = "Sacrifice", phonetic_name = "", type = "externalDefensive"}, -- Blessing of Sacrifice,
		[20066] =	{ name = "Repentance", phonetic_name = "", type = "cc"},
		--TODO[31842] =	{ name = "Divine Illumination", phonetic_name = "", type = "other"},
	},
	["PRIEST"] = {
		[8122] =	{ name = "Psychic Scream", phonetic_name = "", type = "cc"},
		[10060] =	{ name = "Power Infusion", phonetic_name = "", type = "offensive"},
		[19236] =	{ name = "Desperate Prayer", phonetic_name = "", type = "defensive"},
		[32375] =	{ name = "Mass Dispel", phonetic_name = "", type = "dispel"},
		[33206] =	{ name = "Pain Suppression", phonetic_name = "", type = "externalDefensive"},
		[34433] =	{ name = "Shadowfiend", phonetic_name = "", type = "offensive"},
	},
	["ROGUE"] = {
		[1966] =	{ name = "Feint", phonetic_name = "", type = "defensive"},
		[2094] =	{ name = "Blind", phonetic_name = "", type = "cc"},
		[5277] =	{ name = "Evasion", phonetic_name = "", type = "defensive"},
		[13750] =	{ name = "Adrenaline Rush", phonetic_name = "", type = "offensive"},
		[31224] =	{ name = "Cloak of Shadows", phonetic_name = "", type = "defensive"},
	},
	["SHAMAN"] = {
		[2825] =	{ name = "Bloodlust", phonetic_name = "", type = "offensive"},
		[8143] =	{ name = "Tremor Totem", phonetic_name = "", type = "counterCC"},
		[16191] =	{ name = "Mana Tide", phonetic_name = "", type = "other"}, -- Mana Tide Totem
		--TODO[30823] =	{ name = "Shamanistic Rage", phonetic_name = "", type = "defensive"},
		[32182] =	{ name = "Heroism", phonetic_name = "", type = "offensive"},
	},
	["WARLOCK"] = {
		[1122] =	{ name = "Infernal", phonetic_name = "", type = "offensive"}, -- Summon Infernal
		[5484] =	{ name = "Howl of Terror", phonetic_name = "", type = "cc"},
		[5782] =	{ name = "Fear", phonetic_name = "", type = "cc"},
		[20707] =	{ name = "Soulstone", phonetic_name = "Soelstone", type = "other"},
		[29893] =	{ name = "Soulwell", phonetic_name = "", type = "other"}, -- Create Soulwell
		[30283] =	{ name = "Shadowfury", phonetic_name = "Shadowfurey", type = "cc"},
	},
	["WARRIOR"] = {
		[871] =		{ name = "Shield Wall", phonetic_name = "", type = "defensive"},
		[1161] =	{ name = "Challenging Shout", phonetic_name = "", type = "other"},
		[1719] =	{ name = "Recklessness", phonetic_name = "", type = "offensive"},
		--TODO[20230] =	{ name = "Retaliation", phonetic_name = "", type = "offensive"},
		[2565] =	{ name = "Shield Block", phonetic_name = "", type = "defensive"},
		[5246] =	{ name = "Intimidating Shout", phonetic_name = "", type = "cc"},
		[12975] =	{ name = "Last Stand", phonetic_name = "", type = "defensive"},
		[23920] =	{ name = "Spell Reflection", phonetic_name = "", type = "counterCC"},
	},
	["GENERAL"] = {
		[20594] =	{ name = "Stone Form", phonetic_name = "", type = "racial"},
		[20580] =	{ name = "Shadowmeld", phonetic_name = "", type = "racial"},
		[35476] =	{ name = "Drums", phonetic_name = "", type = "offensive"}, -- Drums of Fury
	},
	["TRINKET"] = {
		-- pvp
		-- pve
	}
}

addon.interruptList = {
	[2139] =		{ name = "countered!" }, -- Counter Spell
	[1766] =		{ name = "countered!" }, -- Kick
	[6552] =		{ name = "countered!" } -- Pummel
}

addon.spellCorrections = {
	--- Druid
	-- Bash
	[6798] = 5211, -- Rank 2
	[8983] = 5211, -- Rank 3
	-- Tranquility
	[8918] = 740, -- Rank 2
	[9862] = 740, -- Rank 3
	[9863] = 740, -- Rank 4
	[26983] = 740, -- Rank 5
	-- Rebirth
	[20739] = 20484, -- Rank 2
	[20742] = 20484, -- Rank 3
	[20747] = 20484, -- Rank 4
	[20748] = 20484, -- Rank 5
	[26994] = 20484, -- Rank 5
	-- Frenzied Regen
	[22895] = 22842, -- Rank 2
	[22896] = 22842, -- Rank 3
	[26999] = 22842, -- Rank 4
	--- Mage
	-- Ice Barrier
	[13031] = 11426, -- Rank 2
	[13032] = 11426, -- Rank 3
	[13033] = 11426, -- Rank 4
	[27134] = 11426, -- Rank 5
	[33405] = 11426, -- Rank 6
	-- Polymorph
	[12824] = 118, -- Rank 2
	[12825] = 118, -- Rank 3
	[12826] = 118, -- Rank 4
	[28271] = 118, -- Turtle
	[28272] = 118, -- Pig
	--- Paladin
	-- Divine Shield
	[1020] = 642, -- Rank 2
	-- Divine Protection
	[5573] = 498, -- Rank 2
	-- Blessing of Protection
	[5599] = 1022, -- Rank 2
	[10278] = 1022, -- Rank 3
	-- Hammer of Justice
	[5588] = 853, -- Rank 2
	[5589] = 853, -- Rank 3
	[10308] = 853, -- Rank 4
	-- Lay on Hands
	[2800] = 633, -- Rank 2
	[10310] = 633, -- Rank 3
	[27154] = 633, -- Rank 4
	-- Blessing of Sacrifice
	[20729] = 6940, -- Rank 2
	[27147] = 6940, -- Rank 3
	[27148] = 6940, -- Rank 4
	--- Priest
	-- Psychic Scream
	[8124] = 8122, -- Rank 2
	[10888] = 8122, -- Rank 3
	[10890] = 8122, -- Rank 4
	-- Desperate Prayer
	[13908] = 19236, -- Rank 1
	[19238] = 19236, -- Rank 3
	[19240] = 19236, -- Rank 4
	[19241] = 19236, -- Rank 5
	[19242] = 19236, -- Rank 6
	[19243] = 19236, -- Rank 7
	[25437] = 19236, -- Rank 8
	--- Shaman
	--- Warlock
	-- Howl of Terror
	[17928] = 5484, -- Rank 2
	-- Fear
	[6213] = 5782, -- Rank 2
	[6215] = 5782, -- Rank 3
	-- Soulstone
	[20762] = 20707, -- Rank 2
	[20763] = 20707, -- Rank 3
	[20764] = 20707, -- Rank 4
	[20765] = 20707, -- Rank 5
	[27239] = 20707, -- Rank 6
	--- General
	-- Drums
	[351355] = 35476, -- Greater Drums
}

function addon:GetAllSpellIds()
	local spells = {}
	for _, v in pairs(spellList) do
		for k, v in pairs(v) do
			spells[k] = v
		end
	end
	return spells
end

function addon:GetSpellIdsByClass(name)
	return spellList[name]
end

