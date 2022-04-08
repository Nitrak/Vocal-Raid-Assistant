local _, addon = ...

-- Info: The strings assigned to name and phonetic_name are only used for external sound file generation script
-- neural voices use name, legacy sound uses phonetic_name - if present
-- Shoutout to the OmniCD Devs!

local spellList = {
	["DEATHKNIGHT"] = {
		[42650] =	{ name = "Army of the Dead", phonetic_name = "", type = "offensive"},
		[47568] =	{ name = "Empower Rune Weapon", phonetic_name = "", type = "offensive"},
		[48707] =	{ name = "Anti Magic Shell", phonetic_name = "", type = "defensive"},
		[48743] =	{ name = "Death Pact", phonetic_name = "", type = "defensive"},
		[48792] =	{ name = "Icebound", phonetic_name = "", type = "defensive"},
		[49039] =	{ name = "Lichborne", phonetic_name = "Litchborne", type = "other"},
		[49206] =	{ name = "Summon Gargoyle", phonetic_name = "", type = "offensive"},
		[49576] =	{ name = "Death Grip", phonetic_name = "", type = "disarm"},
		[49028] =	{ name = "Rune Weapon", phonetic_name = "Rune-Weapon", type = "defensive"}, -- Dancing Rune Weapon
		[51052] =	{ name = "Anti Magic Zone", phonetic_name = "", type = "raidDefensive" },
		[55233] =	{ name = "Vampiric Blood", phonetic_name = "", type = "defensive"},
		[61999] =	{ name = "Raise Ally", phonetic_name = "Raise Alleie", type = "other" },
		[108199] =	{ name = "Gorefiend's Grasp", phonetic_name = "", type = "disarm"},
		[114556] =	{ name = "Purgatory", phonetic_name = "", type = "defensive"},
		[152279] =	{ name = "Breath of Sindragosa", phonetic_name = "", type = "offensive"},
		[194679] =	{ name = "Rune Tap", phonetic_name = "", type = "defensive"},
		[194844] =	{ name = "Bonestorm", phonetic_name = "", type = "defensive"},
		[206931] =	{ name = "Blooddrinker", phonetic_name = "", type = "defensive"},
		[207167] =	{ name = "Blinding Sleet", phonetic_name = "", type = "cc"},
		[207289] =	{ name = "Unholy Assault", phonetic_name = "", type = "offensive"},
		[219809] =	{ name = "Tombstone", phonetic_name = "", type = "defensive"},
		[221562] =	{ name = "Asphyxiate", phonetic_name = "", type = "defensive"},
		[279302] =	{ name = "Frostwyrm's Fury", phonetic_name = "Frostwerm's Fury", type = "offensive"},
		[315443] =	{ name = "Abomination Limb", phonetic_name = "", type = "covenant"},
		[327574] =	{ name = "Sacrificial Pact", phonetic_name = "", type = "defensive"},
	},
	["DEMONHUNTER"] = {
		[179057] =	{ name = "Chaos Nova", phonetic_name = "", type = "cc"},
		[187827] =	{ name = "Metamorphosis", phonetic_name = "", type = "defensive"},
		[196555] =	{ name = "Netherwalk", phonetic_name = "", type = "immunity"},
		[196718] =	{ name = "Darkness", phonetic_name = "", type = "raidDefensive"},
		[198589] =	{ name = "Blur", phonetic_name = "", type = "defensive"},
		[202137] =	{ name = "Sigil of Silence", phonetic_name = "", type = "disarm"},
		[202138] =	{ name = "Chains", phonetic_name = "", type = "disarm"},
		[209258] =	{ name = "Last Resort", phonetic_name = "", type = "defensive"},
		[204021] =	{ name = "Fiery Brand", phonetic_name = "", type = "defensive"},
		[205604] =	{ name = "Reverse Magic", phonetic_name = "", type = "counterCC"},
		[205630] =	{ name = "Illidan's Grasp", phonetic_name = "", type = "cc"},
		[206491] =	{ name = "Nemesis", phonetic_name = "", type = "offensive"},
		[206803] =	{ name = "Rain from Above", phonetic_name = "", type = "defensive"},
		[207684] =	{ name = "Sigil of Misery", phonetic_name = "", type = "cc"},
		[258925] =	{ name = "Fel Barrage", phonetic_name = "", type = "offensive"},
		[211881] =	{ name = "Fel Eruption", phonetic_name = "", type = "cc"},
		[212084] =	{ name = "Fel Devastation", phonetic_name = "", type = "offensive"},
		[217832] =	{ name = "Imprison", phonetic_name = "", type = "cc"},
		[320341] =	{ name = "Bulk Extraction", phonetic_name = "", type = "defensive"},
		[329554] =	{ name = "Fodder to the Flame", phonetic_name = "", type = "covenant"},
	},
	["DRUID"] = {
		[740] =		{ name = "Tranquility", phonetic_name = "", type = "raidDefensive"},
		[2908] =	{ name = "Soothe", phonetic_name = "", type = "dispel"},
		[5211] =	{ name = "Bash", phonetic_name = "", type = "cc"}, -- Mighty Bash
		[20484] =	{ name = "Rebirth", phonetic_name = "", type = "other"},
		[22812] =	{ name = "Barkskin", phonetic_name = "", type = "defensive"},
		[22842] =	{ name = "Frenzied Regeneration", phonetic_name = "", type = "defensive"},
		[29166] =	{ name = "Innervate", phonetic_name = "Enervaite", type = "other"},
		[33786] =	{ name = "Cyclone", phonetic_name = "", type = "disarm"},
		[33891] =	{ name = "Incarnation: Tree", phonetic_name = "", type = "offensive"}, -- Incarnation: Tree of Life resto
		[50334] =	{ name = "Berserk", phonetic_name = "", type = "offensive"},
		[61336] =	{ name = "Survival Instincts", phonetic_name = "", type = "defensive"},
		[77761] =	{ name = "Roar", phonetic_name = "", type = "other"}, -- Stampeding Roar bear
		-- [77764] =	{ name = "Roar", phonetic_name = "", type = "other"}, -- Stampeding Roar cat
		[78675] =	{ name = "Solar Beam", phonetic_name = "", type = "interrupt"},
		[80313] =	{ name = "Pulverize", phonetic_name = "", type = "defensive"},
		[102342] =	{ name = "Iron Bark", phonetic_name = "", type = "externalDefensive"},
		[102359] =	{ name = "Entanglement", phonetic_name = "", type = "disarm"}, -- Mass Entanglement
		[102558] =	{ name = "Incarnation: Bear", phonetic_name = "", type = "offensive"}, -- Incarnation: Guardian of Ursoc
		[102793] =	{ name = "Vortex", phonetic_name = "Vortex", type = "disarm"}, -- "Ursol's Vortex"
		[106951] =	{ name = "Berserk", phonetic_name = "", type = "offensive"},
		[108238] =	{ name = "Renewal", phonetic_name = "", type = "defensive"},
		[155835] =	{ name = "Bristling Fur", phonetic_name = "", type = "defensive"},
		-- [106898] =	{ name = "Roar", phonetic_name = "", type = "other"}, -- Stampeding Roar
		[194223] =	{ name = "Celestial Alignment", phonetic_name = "", type = "offensive"},
		[197721] =	{ name = "Flourish", phonetic_name = "", type = "offensive"},
		[202246] =	{ name = "Overrun", phonetic_name = "", type = "cc"},
		[202770] =	{ name = "Fury of Elune", phonetic_name = "", type = "offensive"},
		[205636] =	{ name = "Trees", phonetic_name = "", type = "other"}, -- Force of Nature
		[209749] =	{ name = "Faerie Swarm", phonetic_name = "", type = "disarm"},
		[305497] =	{ name = "Thorns", phonetic_name = "", type = "defensive"},
		[323546] =	{ name = "Ravenous Frenzy", phonetic_name = "", type = "covenant"},
		[323764] =	{ name = "Convoke", phonetic_name = "", type = "covenant"}, -- Convoke the Spirits
		[329042] =	{ name = "Emerald Slumber", phonetic_name = "", type = "other"},
		[354654] =	{ name = "Grove Protection", phonetic_name = "", type = "defensive"},
	},
	["HUNTER"] = {
		[5384] =	{ name = "Feign Death", phonetic_name = "", type = "other"},
		[19574] =	{ name = "Bestial Wrath", phonetic_name = "", type = "offensive"},
		[19577] =	{ name = "Intimidation", phonetic_name = "", type = "cc"},
		[19801] =	{ name = "Tranquilizing Shot", phonetic_name = "", type = "dispel"},
		[34477] =	{ name = "Misdirection", phonetic_name = "", type = "defensive"},
		[53480] =	{ name = "Roar of Sacrifice", phonetic_name = "", type = "externalDefensive"},
		[109248] =	{ name = "Binding Shot", phonetic_name = "", type = "other"},
		[109304] =	{ name = "Exhilaration", phonetic_name = "", type = "defensive"},
		[186265] =	{ name = "Turtle", phonetic_name = "", type = "immunity"}, -- Aspect of the Turtle
		[186289] =	{ name = "Aspect of the Eagle", phonetic_name = "", type = "offensive"},
		[187650] =	{ name = "Freezing Trap", phonetic_name = "", type = "cc"},
		[193530] =	{ name = "Aspect of the Wild", phonetic_name = "", type = "offensive"},
		[201430] =	{ name = "Stampede", phonetic_name = "", type = "offensive"},
		[264667] =	{ name = "Primal Rage", phonetic_name = "", type = "offensive"},
		[266779] =	{ name = "Coordinated Assault", phonetic_name = "", type = "offensive"},
		[281195] =	{ name = "Survival of the Fittest", phonetic_name = "", type = "defensive"},
		[288613] =	{ name = "Trueshot", phonetic_name = "", type = "offensive"},
		[308491] =	{ name = "Resonating Arrow", phonetic_name = "", type = "covenant"},
		[321530] =	{ name = "Bloodshed", phonetic_name = "", type = "offensive"},
		[328231] =	{ name = "Wild Spirits", phonetic_name = "", type = "covenant"},
	},
	["MAGE"] = {
		[118] =		{ name = "Polymorph", phonetic_name = "", type = "cc"},
		[11426] =	{ name = "Ice Barrier", phonetic_name = "", type = "defensive"},
		[12042] =	{ name = "Arcane Power", phonetic_name = "", type = "offensive"},
		[12472] =	{ name = "Icy Veins", phonetic_name = "", type = "offensive"},
		[45438] =	{ name = "Ice Block", phonetic_name = "", type = "immunity"},
		[55342] =	{ name = "Mirror Image", phonetic_name = "", type = "offensive"},
		[80353] =	{ name = "Time Warp", phonetic_name = "", type = "offensive"},
		[86949] =	{ name = "Cauterize", phonetic_name = "", type = "defensive"},
		[110909] =	{ name = "Alter Time", phonetic_name = "", type = "defensive"},
		[190319] =	{ name = "Combustion", phonetic_name = "", type = "offensive"},
		[198144] =	{ name = "Ice Form", phonetic_name = "", type = "offensive"},
		[235313] =	{ name = "Blazing Barrier", phonetic_name = "", type = "defensive"},
		[235450] =	{ name = "Prismatic Barrier", phonetic_name = "", type = "defensive"},
		[314791] =	{ name = "Shifting Power", phonetic_name = "", type = "covenant"},
		[314793] =	{ name = "Mirrors of Torment", phonetic_name = "", type = "covenant"},
		[321507] =	{ name = "Touch of the Magi", phonetic_name = "", type = "offensive"},
		[324220] =	{ name = "Deathborne", phonetic_name = "", type = "covenant"},
	},
	["MONK"] = {
		[115078] =	{ name = "Paralysis", phonetic_name = "", type = "cc"},
		[115176] =	{ name = "Zen Meditation", phonetic_name = "", type = "defensive"},
		[115203] =	{ name = "Fortifying Brew", phonetic_name = "", type = "defensive"},
		[115288] =	{ name = "Energizing Elixir", phonetic_name = "", type = "offensive"},
		[115310] =	{ name = "Revival", phonetic_name = "", type = "raidDefensive"},
		[115399] =	{ name = "Black Ox Brew", phonetic_name = "", type = "defensive"},
		[116841] =	{ name = "Tiger's Lust", phonetic_name = "", type = "other"},
		[116844] =	{ name = "Ring of Peace", phonetic_name = "", type = "disarm"},
		[116849] =	{ name = "Life Cocoon", phonetic_name = "", type = "externalDefensive"},
		[119381] =	{ name = "Leg sweep", phonetic_name = "", type = "cc"},
		[122278] =	{ name = "Dampen Harm", phonetic_name = "", type = "defensive"},
		[122783] =	{ name = "Diffuse Magic", phonetic_name = "", type = "defensive"},
		[122470] =	{ name = "Touch of Karma", phonetic_name = "", type = "immunity"},
		[123904] =	{ name = "Invoke Xuen", phonetic_name = "Invoke Xuean", type = "offensive"},
		[132578] =	{ name = "Invoke Niuzao", phonetic_name = "Invoke Nieuezo", type = "defensive"},
		[137639] =	{ name = "Storm, Earth, and Fire", phonetic_name = "", type = "offensive"},
		[152173] =	{ name = "Serenity", phonetic_name = "", type = "offensive"},
		[197908] =	{ name = "Mana Tea", phonetic_name = "", type = "other"},
		[243435] =	{ name = "Fortifying Brew", phonetic_name = "", type = "defensive"},
		[310454] =	{ name = "Weapons of Order", phonetic_name = "", type = "covenant"},
		[322109] =	{ name = "Touch of Death", phonetic_name = "", type = "offensive"},
		[322118] =	{ name = "Invoke Yu'lon", phonetic_name = "Invoke Yu loen", type = "offensive"},
		[322507] =	{ name = "Celestial Brew", phonetic_name = "", type = "defensive"},
		[325153] =	{ name = "Exploding Keg", phonetic_name = "", type = "defensive"},
		[325197] =	{ name = "Invoke Chi-Ji", phonetic_name = "Invoke Chee Ji", type = "offensive"},
		[325216] =	{ name = "Bonedust Brew", phonetic_name = "", type = "covenant"},
		[326860] =	{ name = "Fallen Order", phonetic_name = "", type = "covenant"},
	},
	["PALADIN"] = {
		[498] =		{ name = "Divine Protection", phonetic_name = "", type = "defensive"},
		[633] =		{ name = "Lay on Hands", phonetic_name = "", type = "defensive"},
		[642] =		{ name = "Divine Shield", phonetic_name = "", type = "immunity"},
		[853] =		{ name = "Hammer of Justice", phonetic_name = "", type = "cc"},
		[1022] = 	{ name = "Protection", phonetic_name = "", type = "externalDefensive"},
		[6940] = 	{ name = "Sacrifice", phonetic_name = "", type = "externalDefensive"}, -- Blessing of Sacrifice,
		[20066] =	{ name = "Repentance", phonetic_name = "", type = "cc"},
		[31821] =	{ name = "Aura Mastery", phonetic_name = "", type = "raidDefensive"},
		[31850] =	{ name = "Ardent Defender", phonetic_name = "", type = "defensive"},
		[31884] =	{ name = "Avenging Wrath", phonetic_name = "", type = "offensive"},
		[86659] =	{ name = "Guardian of Ancient Kings", phonetic_name = "", type = "defensive"}, -- Guardian of the Ancient Kings,
		[105809] =	{ name = "Holy Avenger", phonetic_name = "", type = "offensive"},
		[114158] =	{ name = "Light's Hammer", phonetic_name = "", type = "offensive"},
		[115750] =	{ name = "Blinding Light", phonetic_name = "", type = "cc"},
		[184662] =	{ name = "Shield of Vengeance", phonetic_name = "", type = "defensive"},
		[204018] =	{ name = "Spellwarding", phonetic_name = "", type = "externalDefensive"}, -- Blessing of Spellwarding
		[216331] =	{ name = "Avenging Crusader", phonetic_name = "", type = "offensive"},
		[231895] =	{ name = "Crusade", phonetic_name = "", type = "offensive"},
		[304971] =	{ name = "Divine Toll", phonetic_name = "", type = "covenant"},
		[316958] =	{ name = "Ashen Hallow", phonetic_name = "", type = "covenant"},
		[327193] =	{ name = "Moment of Glory", phonetic_name = "", type = "offensive"},
	},
	["PRIEST"] = {
		[8122] =	{ name = "Psychic Scream", phonetic_name = "", type = "cc"},
		[10060] =	{ name = "Power Infusion", phonetic_name = "", type = "offensive"},
		[15286] =	{ name = "Vampiric Embrace", phonetic_name = "", type = "raidDefensive"},
		[19236] =	{ name = "Desperate Prayer", phonetic_name = "", type = "defensive"},
		[32375] =	{ name = "Mass Dispel", phonetic_name = "", type = "dispel"},
		[33206] =	{ name = "Pain Suppression", phonetic_name = "", type = "externalDefensive"},
		[34433] =	{ name = "Shadowfiend", phonetic_name = "", type = "offensive"},
		[47536] =	{ name = "Rapture", phonetic_name = "", type = "offensive"},
		[47585] =	{ name = "Dispersion", phonetic_name = "", type = "defensive"},
		[47788] =	{ name = "Guardian Spirit", phonetic_name = "", type = "externalDefensive"},
		[62618] =	{ name = "Barrier", phonetic_name = "", type = "raidDefensive"}, -- Power Word: Barrier
		[64044] =	{ name = "Psychic Horror", phonetic_name = "", type = "cc"},
		[64843] =	{ name = "Divine Hymn", phonetic_name = "", type = "raidDefensive"},	-- Divine Hymn
		[64901] =	{ name = "Symbol of Hope", phonetic_name = "", type = "other"},
		[73325] =	{ name = "Leap of Faith", phonetic_name = "", type = "other"},
		[88625] =	{ name = "Chastise", phonetic_name = "", type = "cc"}, -- Holy Word: Chastise
		[108968] =	{ name = "Void Shift", phonetic_name = "", type = "defensive"},
		[109964] =	{ name = "Spirit Shell", phonetic_name = "", type = "offensive"},
		[200183] =	{ name = "Apotheosis", phonetic_name = "", type = "offensive"},
		[205369] =	{ name = "Mind Bomb", phonetic_name = "", type = "cc"},
		[228260] =	{ name = "Void Eruption", phonetic_name = "", type = "offensive"},
		[246287] =	{ name = "Evangelism", phonetic_name = "", type = "offensive"},
		[265202] =	{ name = "Salvation", phonetic_name = "", type = "raidDefensive"}, -- Holy Word: Salvation
		[271466] =	{ name = "Luminous Barrier", phonetic_name = "", type = "raidDefensive"},
		[319952] =	{ name = "Madness", phonetic_name = "", type = "offensive"}, -- Surrender to Madness
		[323673] =	{ name = "Mind Games", phonetic_name = "", type = "covenant"},
		[324724] =	{ name = "Unholy Nova", phonetic_name = "", type = "covenant"},
		[325013] =	{ name = "Boon of the Ascended", phonetic_name = "", type = "covenant"},
		[327661] =	{ name = "Fae Guardians", phonetic_name = "Fei Guardians", type = "covenant"}
	},
	["ROGUE"] = {
		[1966] =	{ name = "Feint", phonetic_name = "", type = "defensive"},
		[2094] =	{ name = "Blind", phonetic_name = "", type = "cc"},
		[5277] =	{ name = "Evasion", phonetic_name = "", type = "defensive"},
		[5938] =	{ name = "Shiv", phonetic_name = "", type = "dispel"},
		[13750] =	{ name = "Adrenaline Rush", phonetic_name = "", type = "offensive"},
		[31224] =	{ name = "Cloak of Shadows", phonetic_name = "", type = "defensive"},
		[51690] =	{ name = "Killing Spree", phonetic_name = "", type = "offensive"},
		[57934] =	{ name = "Tricks of the Trade", phonetic_name = "", type = "other"},
		[76577] =	{ name = "Smoke Bomb", phonetic_name = "", type = "other"}, -- Smoke Bomb,
		[79140] =	{ name = "Vendetta", phonetic_name = "", type = "offensive"},
		[114018] =	{ name = "Shroud", phonetic_name = "", type = "other"}, -- Shroud of Consealment
		[121471] =	{ name = "Shadow Blades", phonetic_name = "", type = "offensive"},
		[185311] =	{ name = "Crimson Vial", phonetic_name = "", type = "defensive"},
	},
	["SHAMAN"] = {
		[2825] =	{ name = "Bloodlust", phonetic_name = "", type = "offensive"},
		[8143] =	{ name = "Tremor Totem", phonetic_name = "", type = "counterCC"},
		[16191] =	{ name = "Mana Tide", phonetic_name = "", type = "other"}, -- Mana Tide Totem
		[32182] =	{ name = "Heroism", phonetic_name = "", type = "offensive"},
		[51514] =	{ name = "Hex", phonetic_name = "", type = "cc"},
		[79206] =	{ name = "Spiritwalker", phonetic_name = "", type = "counterCC"}, -- Spiritwalker's Grace
		[98008] =	{ name = "Spirit Link", phonetic_name = "", type = "raidDefensive"}, -- -- Spirit Link Totem
		[108271] =	{ name = "Astral Shift", phonetic_name = "", type = "defensive"},
		[108281] =	{ name = "Ancestral Guidance", phonetic_name = "Ancestral Guiadence", type = "defensive"},
		[108280] =	{ name = "Healing Tide", phonetic_name = "", type = "raidDefensive"},	-- Healing Tide Totem,
		[114052] =	{ name = "Ascendance", phonetic_name = "", type = "offensive"},
		[191634] =	{ name = "Stormkeeper", phonetic_name = "", type = "offensive"},
		[192058] =	{ name = "Capacitor Totem", phonetic_name = "", type = "cc"},
		[192077] =	{ name = "Wind Rush", phonetic_name = "", type = "raidMovement"}, -- Wind Rush Totem
		[198103] =  { name = "Earth Elemental", phonetic_name = "", type = "other" },
		[198838] =	{ name = "Earthen Wall Totem", phonetic_name = "", type = "defensive"},
		[207399] =	{ name = "Ancestral Protection", phonetic_name = "", type = "defensive"}, -- Ancestral Protection Totem,
		[320137] =	{ name = "Stormkeeper", phonetic_name = "", type = "offensive"},
		[320674] =	{ name = "Chain Harvest", phonetic_name = "", type = "covenant"},
		[328923] =	{ name = "Fae Transfusion", phonetic_name = "Fei Transfusion", type = "covenant"},
		[326059] =	{ name = "Primordial Wave", phonetic_name = "", type = "covenant"},
		[324386] =	{ name = "Vesper Totem", phonetic_name = "", type = "covenant"},
	},
	["WARLOCK"] = {
		[1122] =	{ name = "Infernal", phonetic_name = "", type = "offensive"}, -- Summon Infernal
		[5484] =	{ name = "Howl of Terror", phonetic_name = "", type = "cc"},
		[5782] =	{ name = "Fear", phonetic_name = "", type = "cc"},
		[20707] =	{ name = "Soulstone", phonetic_name = "Soelstone", type = "other"},
		[29893] =	{ name = "Soulwell", phonetic_name = "", type = "other"}, -- Create Soulwell
		[30283] =	{ name = "Shadowfury", phonetic_name = "Shadowfurey", type = "cc"},
		[104773] =	{ name = "Unending Resolve", phonetic_name = "", type = "defensive"},
		[108416] =	{ name = "Dark Pact", phonetic_name = "", type = "defensive"},
		[111771] =	{ name = "Gateway", phonetic_name = "", type = "other"}, -- Demonic Gateway
		[111898] =	{ name = "Felguard", phonetic_name = "", type = "cc"}, -- Grimoire: Felguard
		[113858] =	{ name = "Instability", phonetic_name = "", type = "offensive"}, -- Dark Soul: Instability
		[113860] =	{ name = "Misery", phonetic_name = "", type = "offensive"}, -- Dark Soul: Misery
		[205180] =	{ name = "Darkglare", phonetic_name = "", type = "offensive"}, -- Summon Darkglare
		[265187] =	{ name = "Demonic Tyrant", phonetic_name = "", type = "offensive"}, -- Summon Demonic Tyrant
		[333889] =	{ name = "Fel Domination", phonetic_name = "", type = "offensive"},
	},
	["WARRIOR"] = {
		[871] =		{ name = "Shield Wall", phonetic_name = "", type = "defensive"},
		[1160] =	{ name = "Demoralizing Shout", phonetic_name = "", type = "defensive"},
		[1161] =	{ name = "Challenging Shout", phonetic_name = "", type = "other"},
		[1719] =	{ name = "Recklessness", phonetic_name = "", type = "offensive"},
		[2565] =	{ name = "Shield Block", phonetic_name = "", type = "defensive"},
		[5246] =	{ name = "Intimidating Shout", phonetic_name = "", type = "cc"},
		[12975] =	{ name = "Last Stand", phonetic_name = "", type = "defensive"},
		[23920] =	{ name = "Spell Reflection", phonetic_name = "", type = "counterCC"},
		[46968] =	{ name = "Shockwave", phonetic_name = "", type = "offensive"},
		[64382] =	{ name = "Shattering Throw", phonetic_name = "", type = "other"},
		[97462] =	{ name = "Rallying Cry", phonetic_name = "Ralyan Cry", type = "raidDefensive"},
		[118038] =	{ name = "Die by the Sword", phonetic_name = "", type = "defensive"},
		[190456] =	{ name = "Ignore Pain", phonetic_name = "", type = "defensive"},
		[228920] =	{ name = "Ravager", phonetic_name = "", type = "offensive"},
	},
	["GENERAL"] = {
		[20594] =	{ name = "Stone Form", phonetic_name = "", type = "racial"},
		[58984] =	{ name = "Shadowmeld", phonetic_name = "", type = "racial"},
		[107079] =	{ name = "Quaking Palm", phonetic_name = "", type = "racial"},
		[178207] =	{ name = "Drums", phonetic_name = "", type = "offensive"}, -- Drums of Fury
		[323436] =	{ name = "Purify Soul", phonetic_name = "", type = "covenant"},
		[324631] =	{ name = "Fleshcraft", phonetic_name = "", type = "covenant"},
		[348477] =	{ name = "Reanimator", phonetic_name = "Re-animator", type = "other"},
	},
	["TRINKET"] = {
		-- pvp
		[196029] =	{ name = "Relentless Brooch", phonetic_name = "", type = "pvptrinket" }, -- Sinful Gladiator's Relentless Brooch 181335
		[336135] =	{ name = "Sigil of Adaptation", phonetic_name = "", type = "pvptrinket" }, -- Sinful Gladiator's Sigil of Adaptation	181816
		[336126] =	{ name = "Medallion", phonetic_name = "", type = "pvptrinket" }, -- Sinful Gladiator's Medallion 181333
		[345228] =	{ name = "Badge of Ferocity", phonetic_name = "", type = "pvptrinket" }, -- Sinful Gladiator's Badge of Ferocity 175921
		[345231] =	{ name = "Emblem", phonetic_name = "", type = "pvptrinket" }, -- Sinful Gladiator's Emblem 178447
		-- pve
		[329840] =	{ name = "Blood-Spattered Scale", phonetic_name = "", type = "trinket-defensive"}, -- Blood-Spattered Scale 179331
		[344907] =	{ name = "Splintered Heart", phonetic_name = "", type = "trinket-defensive"}, -- Splintered Heart of Al'ar 184018
		[345801] =	{ name = "Soulletting Ruby", phonetic_name = "", type = "trinket-defensive"}, -- Soulletting Ruby 178809
		[348139] = 	{ name = "Divine Bell", phonetic_name = "", type = "trinket-offensive" }, -- Instructor's Divine Bell 184842
		[358712] =	{ name = "Aegis", phonetic_name = "", type = "trinket-defensive"}, -- Shard of Annhylde's Aegis 186424
	}
}

addon.spellCorrections = {
	-- Shaman Hex
	[162624] = 51514, -- Tome of Hex: Wicker Mongrel
	[172405] = 51514, -- Tome of Hex: Living Honey
	[210873] = 51514, -- Tome of Hex: Compy
	[211004] = 51514, -- Tome of Hex: Spider
	[211010] = 51514, -- Tome of Hex: Snake
	[211015] = 51514, -- Tome of Hex: Cockroach
	[269352] = 51514, -- Tome of Hex: Skeletal Hatchling
	[277778] = 51514, -- Tome of Hex: Zandalari Tendonripper
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
	-- Druid Roar
	[77764] = 77761, -- Roar: Cat form
	[106898] = 77761 -- Roar: General
}

function addon:IsSpellSupported(spellID)
	return spellList[spellID] ~= nil
end

function addon:GetAllSpellIds()
	local spells = {}
	for _, v in pairs(spellList) do
		for k, v in pairs(v) do
			spells[k] = v
		end
	end
	return spells
end

function addon:GetSpellEntries(category)
	return spellList[category]
end

