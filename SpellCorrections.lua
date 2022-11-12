local _, addon = ...

-- Retail
local spellCorrectionsRetail = {
	-- Shaman Hex
	[162624] = 51514, -- Tome of Hex: Wicker Mongrel
	[172405] = 51514, -- Tome of Hex: Living Honey
	[210873] = 51514, -- Tome of Hex: Compy
	[211004] = 51514, -- Tome of Hex: Spider
	[211010] = 51514, -- Tome of Hex: Snake
	[211015] = 51514, -- Tome of Hex: Cockroach
	[269352] = 51514, -- Tome of Hex: Skeletal Hatchling
	[277778] = 51514, -- Tome of Hex: Zandalari Tendonripper
	[309328] = 51514, -- Tome of Hex: Living Honey
	-- Mage Polymorph
	[28271] = 118, -- Tome of Polymorph: Turtle
	[28272] = 118, -- Polymorph: Pig
	[61305] = 118, -- Tome of Polymorph: Black Cat
	[61721] = 118, -- Tome of Polymorph: Rabbit
	[126819] = 118, -- Tome of Polymorph: Porcupine
	[161353] = 118, -- Tome of Polymorph: Polar Bear Cub
	[161354] = 118, -- Tome of Polymorph: Monkey
	[277787] = 118, -- Tome of Polymorph: Direhorn
	[277792] = 118, -- Tome of Polymorph: Bumblebee
	[321395] = 118, -- Polymorph: Maw Rat
	-- Mage Alter Time
	[108978] = 342245,
	-- Druid Roar
	[77764] = 77761, -- Roar: Cat form
	[106898] = 77761, -- Roar: General
	-- Druid Berserk
	[106951] = 50334,
	-- Metamorphosis
	[191427] = 200166,
	-- Touch of Death
	[322109] = 115080,
	-- Ascendance
	[114051] = 114050,
	[114052] = 114050
}

-- Wrath
local spellCorrectionsWrath = {
	--- Druid
	-- Bash
	[6798] = 5211, -- Rank 2
	[8983] = 5211, -- Rank 3
	-- Tranquility
	[8918] = 740, -- Rank 2
	[9862] = 740, -- Rank 3
	[9863] = 740, -- Rank 4
	[26983] = 740, -- Rank 5
	[48446] = 740, -- Rank 6
	[48447] = 740, -- Rank 7
	-- Rebirth
	[20739] = 20484, -- Rank 2
	[20742] = 20484, -- Rank 3
	[20747] = 20484, -- Rank 4
	[20748] = 20484, -- Rank 5
	[26994] = 20484, -- Rank 5
	--- Mage
	-- Ice Barrier
	[13031] = 11426, -- Rank 2
	[13032] = 11426, -- Rank 3
	[13033] = 11426, -- Rank 4
	[27134] = 11426, -- Rank 5
	[33405] = 11426, -- Rank 6
	[43038] = 11426, -- Rank 7
	[43039] = 11426, -- Rank 8
	-- Polymorph
	[12824] = 118, -- Rank 2
	[12825] = 118, -- Rank 3
	[12826] = 118, -- Rank 4
	[28271] = 118, -- Turtle
	[28272] = 118, -- Pig
	[61305] = 118, -- Black Cat
	[61721] = 118, -- Rabbit
	[61780] = 118, -- Turkey

	--- Paladin
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
	[48788] = 633, -- Rank 5
	--- Priest
	-- Lightwell
	[27870] = 724, -- Rank 2
	[27871] = 724, -- Rank 3
	[28275] = 724, -- Rank 4
	[48086] = 724, -- Rank 5
	[48087] = 724, -- Rank 6
	-- Psychic Scream
	[8124] = 8122, -- Rank 2
	[10888] = 8122, -- Rank 3
	[10890] = 8122, -- Rank 4
	-- Desperate Prayer
	[19238] = 19236, -- Rank 2
	[19240] = 19236, -- Rank 3
	[19241] = 19236, -- Rank 4
	[19242] = 19236, -- Rank 5
	[19243] = 19236, -- Rank 6
	[25437] = 19236, -- Rank 7
	[48172] = 19236, -- Rank 8
	[48173] = 19236, -- Rank 9
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
	[47883] = 20707, -- Rank 7
	--- General
	-- Drums
	[351355] = 35476, -- Greater Drums
}

-- Classic
local spellCorrectionsClassic = {
	--- Druid
	-- Bash
	[6798] = 5211, -- Rank 2
	[8983] = 5211, -- Rank 2
	-- Tranquility
	[8918] = 740, -- Rank 2
	[9862] = 740, -- Rank 3
	[9863] = 740, -- Rank 4
	-- Rebirth
	[20739] = 20484, -- Rank 2
	[20742] = 20484, -- Rank 3
	[20747] = 20484, -- Rank 4
	[20748] = 20484, -- Rank 5
	-- Frenzied Regen
	[22895] = 22842, -- Rank 2
	[22896] = 22842, -- Rank 3
	--- Mage
	-- Ice Barrier
	[13031] = 11426, -- Rank 2
	[13032] = 11426, -- Rank 3
	[13033] = 11426, -- Rank 4
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
	-- Blessing of Sacrifice
	[20729] = 6940, -- Rank 2
	--- Priest
	-- Lightwell
	[27870] = 724, -- Rank 2
	[27871] = 724, -- Rank 3
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
	--- Shaman
	-- Mana Tide
	[17355] = 16191, -- Rank 2
	[17360] = 16191, -- Rank 3
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
}

addon.spellCorrections = spellCorrectionsRetail

--[===[@non-version-retail@
spellCorrectionsRetail = nil

--@version-classic@
addon.spellCorrections = spellCorrectionsClassic
spellCorrectionsWrath = nil
--@end-version-classic@

--@version-wrath@
addon.spellCorrections = spellCorrectionsWrath
spellCorrectionsClassic = nil
--@end-version-wrath@

--@end-non-version-retail@]===]
