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
	-- Shaman Stormkeeper
	[383009] = 191634,
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
	-- Arcane Torrent (Different SpellID per Class)
	[28730] = 25046,
	[50613] = 25046,
	[69179] = 25046,
	[80483] = 25046,
	[129597] = 25046,
	[155145] = 25046,
	[202719] = 25046,
	[232633] = 25046,
	-- Druid Stampeding Roar
	[77761] = 106898,
	-- Typhoon
	[132469] = 61391,
	-- Ascendance
	[114051] = 114050,
	[114052] = 114050,
	-- Survival of the Fittest
	[281195] = 264735,
	-- Divine Toll
	[304971] = 375576,
	-- Blessing of Summer
	[388010] = 388007,
	[388013] = 388007,
	[388007] = 388007,
	[388011] = 388007,
	[328622] = 388007,
	[328282] = 388007,
	[328620] = 388007,
	[328281] = 388007,
	-- Faeline Stomp
	[327104] = 388193,
	-- Elysian Decree
	[306830] = 390163,
	-- Convoke the Spirits
	[323764] = 391528,
	-- Adaptive Swarm
	[325727] = 391888,
	-- Flagellation
	[323654] = 384631,
	-- Sepsis
	[328305] = 385408,
	-- Serrated Bone Spike
	[328547] = 385424,
	-- Primordial Wave
	[326059] = 375982,
	-- Soul Rot
	[325640] = 386997,
	-- Death Chakram
	[325028] = 375891,
	-- Radiant Spark
	[307443] = 376103,
	-- Shifting Power
	[314791] = 382440,
	-- Mindgames
	[323673] = 375901,
	-- Echoing Reprimand
	[323547] = 385616,
	-- Devine Protection
	[403876] = 498,
	--Raise Abomination
	[455395] = 288853
}

local spellIconCorrections = {
	-- These are icon ids!
	-- Vengeance DH Meta
	[135860] = 1247263
}

local spellNameCorrections = {
	[115203] = true,
	[243435] = true,
	[422083] = true,
	[422750] = true
}

-- Cata
local spellCorrectionsCata = {
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
	-- Typhoon
	[53223] = 50516, -- Rank 2
	[53225] = 50516, -- Rank 3
	[53226] = 50516, -- Rank 4
	[61384] = 50516, -- Rank 5
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
	-- Arcane Torrent (Different SpellID per Class / Power Type)
	[28730] = 25046,
	[50613] = 25046
	--- General
	--
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
addon.spellIconCorrections = spellIconCorrections
addon.spellNameCorrections = spellNameCorrections

--[===[@non-version-retail@
spellCorrectionsRetail = nil

--@version-classic@
addon.spellCorrections = spellCorrectionsClassic
spellCorrectionsCata = nil
--@end-version-classic@

--@version-cata@
addon.spellCorrections = spellCorrectionsCata
spellCorrectionsClassic = nil
--@end-version-cata@

--@end-non-version-retail@]===]
