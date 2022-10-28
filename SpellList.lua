local _, addon = ...

-- Shoutout to the OmniCD Devs!
local spellListRetail = {
	["DEATHKNIGHT"] = {
		[42650]  = {type = 1}, --Army of the Dead
		[46585]  = {type = 1}, --Raise Dead
		[47568]  = {type = 1}, --Empower Rune Weapon
		[48707]  = {type = 2}, --Anti-Magic Shell
		[48743]  = {type = 2}, --Death Pact
		[48792]  = {type = 2}, --Icebound Fortitude
		[49028]  = {type = 1}, --Dancing Rune Weapon
		[49206]  = {type = 1}, --Summon Gargoyle
		[51052]  = {type = 4}, --Anti-Magic Zone
		[55233]  = {type = 2}, --Vampiric Blood
		[108194] = {type = 8}, --Asphyxiate
		[108199] = {type = 5}, --Gorefiend's Grasp
		[152279] = {type = 1}, --Breath of Sindragosa
		[207167] = {type = 8}, --Blinding Sleet
		[207289] = {type = 1}, --Unholy Assault
		[212552] = {type = 2}, --Wraith Walk
		[219809] = {type = 2}, --Tombstone
		[221562] = {type = 8}, --Asphyxiate
		[275699] = {type = 1}, --Apocalypse
		[279302] = {type = 1}, --Frostwyrm's Fury
		[383269] = {type = 1}, --Abomination Limb
	},
	["DEMONHUNTER"] = {
		[179057] = {type = 8}, --Chaos Nova
		[187827] = {type = 2}, --Metamorphosis
		[188501] = {type = 5}, --Spectral Sight
		[191427] = {type = 1}, --Metamorphosis
		[196555] = {type = 2}, --Netherwalk
		[196718] = {type = 4}, --Darkness
		[198589] = {type = 2}, --Blur
		[202137] = {type = 6}, --Sigil of Silence
		[202138] = {type = 8}, --Sigil of Chains
		[204021] = {type = 2}, --Fiery Brand
		[207684] = {type = 8}, --Sigil of Misery
		[211881] = {type = 5}, --Fel Eruption
		[217832] = {type = 8}, --Imprison
		[263648] = {type = 2}, --Soul Barrier
		[320341] = {type = 2}, --Bulk Extraction
		[370965] = {type = 1}, --The Hunt
	},
	["DRUID"] = {
		[99] 	 = {type = 8}, --Incapacitating Roar
		[740]    = {type = 4}, --Tranquility
		[20484]  = {type = 5}, --Rebirth
		[22812]  = {type = 2}, --Barkskin
		[29166]  = {type = 5}, --Innervate
		[33891]  = {type = 4}, --Incarnation: Tree of Life
		[61336]  = {type = 2}, --Survival Instincts
		[77761]  = {type = 4}, --Stampeding Roar
		[102342] = {type = 3}, --Ironbark
		[102543] = {type = 1}, --Incarnation: Avatar of Ashamane
		[102558] = {type = 2}, --Incarnation: Guardian of Ursoc
		[102560] = {type = 1}, --Incarnation: Chosen of Elune
		[102793] = {type = 8}, --Ursol's Vortex
		[106898] = {type = 5}, --Stampeding Roar
		[106951] = {type = 1}, --Berserk
		[108238] = {type = 2}, --Renewal
		[124974] = {type = 3}, --Nature's Vigil
		[132469] = {type = 8}, --Typhoon
		[194223] = {type = 1}, --Celestial Alignment
		[197721] = {type = 4}, --Flourish
		[203651] = {type = 3}, --Overgrowth
		[319454] = {type = 1}, --Heart of the Wild
		[391528] = {type = 1}, --Convoke the Spirits
	},
	["HUNTER"] = {
		[19574]  = {type = 1}, --Bestial Wrath
		[19577]  = {type = 8}, --Intimidation
		[109248] = {type = 8}, --Binding Shot
		[109304] = {type = 2}, --Exhilaration
		[186257] = {type = 2}, --Aspect of the Cheetah
		[186265] = {type = 2}, --Aspect of the Turtle
		[186289] = {type = 1}, --Aspect of the Eagle
		[187650] = {type = 8}, --Freezing Trap
		[193530] = {type = 1}, --Aspect of the Wild
		[199483] = {type = 2}, --Camouflage
		[201430] = {type = 1}, --Stampede
		[264735] = {type = 2}, --Survival of the Fittest
		[266779] = {type = 1}, --Coordinated Assault
		[281195] = {type = 2}, --Survival of the Fittest
		[288613] = {type = 1}, --Trueshot
	},
	["MAGE"] = {
		[66]     = {type = 2}, --Invisibility
		[118]    = {type = 8}, --Polymorph
		[11426]  = {type = 2}, --Ice Barrier
		[12042]  = {type = 1}, --Arcane Power
		[12051]  = {type = 1}, --Evocation
		[12472]  = {type = 1}, --Icy Veins
		[45438]  = {type = 2}, --Ice Block
		[55342]  = {type = 2}, --Mirror Image
		[110960] = {type = 2}, --Greater Invisibility | 110959
		[113724] = {type = 8}, --Ring of Frost
		[190319] = {type = 1}, --Combustion
		[205021] = {type = 1}, --Ray of Frost
		[235219] = {type = 2}, --Cold Snap
		[235313] = {type = 5}, --Blazing Barrier
		[235450] = {type = 5}, --Prismatic Barrier
		[383121] = {type = 8}, --Mass Polymorph
	},
	["MONK"] = {
		[115080] = {type = 1}, --Touch of Death
		[115176] = {type = 2}, --Zen Meditation
		[115203] = {type = 2}, --Fortifying Brew
		[115310] = {type = 4}, --Revival
		[115399] = {type = 2}, --Black Ox Brew
		[116844] = {type = 8}, --Ring of Peace
		[116849] = {type = 3}, --Life Cocoon
		[119381] = {type = 8}, --Leg Sweep
		[122278] = {type = 2}, --Dampen Harm
		[122470] = {type = 2}, --Touch of Karma
		[122783] = {type = 2}, --Diffuse Magic
		[123904] = {type = 1}, --Invoke Xuen, the White Tiger
		[132578] = {type = 1}, --Invoke Niuzao, the Black Ox
		[137639] = {type = 1}, --Storm, Earth, and Fire
		[152173] = {type = 1}, --Serenity
		[197908] = {type = 5}, --Mana Tea
		[243435] = {type = 2}, --Fortifying Brew
		[322118] = {type = 4}, --Invoke Yu'lon, the Jade Serpent
		[388686] = {type = 1}, --Summon White Tiger Statue
	},
	["PALADIN"] = {
		[498]    = {type = 2}, --Divine Protection
		[633]    = {type = 3}, --Lay on Hands
		[642]    = {type = 2}, --Divine Shield
		[853]    = {type = 8}, --Hammer of Justice
		[1022]   = {type = 3}, --Blessing of Protection
		[1044]   = {type = 5}, --Blessing of Freedom
		[6940]   = {type = 3}, --Blessing of Sacrifice
		[31821]  = {type = 4}, --Aura Mastery
		[31850]  = {type = 2}, --Ardent Defender
		[31884]  = {type = 1}, --Avenging Wrath
		[86659]  = {type = 2}, --Guardian of Ancient Kings
		[105809] = {type = 1}, --Holy Avenger
		[115750] = {type = 8}, --Blinding Light
		[152262] = {type = 1}, --Seraphim
		[184662] = {type = 2}, --Shield of Vengeance
		[204018] = {type = 3}, --Blessing of Spellwarding
		[205191] = {type = 2}, --Eye for an Eye
		[216331] = {type = 1}, --Avenging Crusader
		[231895] = {type = 1}, --Crusade
		[327193] = {type = 1}, --Moment of Glory
	},
	["PRIEST"] = {
		[8122]   = {type = 8}, --Psychic Scream
		[10060]  = {type = 1}, --Power Infusion
		[15286]  = {type = 4}, --Vampiric Embrace
		[19236]  = {type = 2}, --Desperate Prayer
		[33206]  = {type = 3}, --Pain Suppression
		[34433]  = {type = 1}, --Shadowfiend
		[47536]  = {type = 5}, --Rapture
		[47585]  = {type = 2}, --Dispersion
		[47788]  = {type = 3}, --Guardian Spirit
		[62618]  = {type = 4}, --Power Word: Barrier
		[64044]  = {type = 8}, --Psychic Horror
		[64843]  = {type = 4}, --Divine Hymn
		[64901]  = {type = 4}, --Symbol of Hope
		[73325]  = {type = 5}, --Leap of Faith
		[109964] = {type = 4}, --Spirit Shell
		[123040] = {type = 1}, --Mindbender spec 256
		[200174] = {type = 1}, --Mindbender spec 258
		[200183] = {type = 2}, --Apotheosis
		[205369] = {type = 5}, --Mind Bomb
		[228260] = {type = 1}, --Void Eruption
		[246287] = {type = 4}, --Evangelism
		[265202] = {type = 4}, --Holy Word: Salvation
		[271466] = {type = 4}, --Luminous Barrier
		[372835] = {type = 4}, --Lightwell
	},
	["ROGUE"] = {
		[1966] =	{ type = "defensive"},
		[2094] =	{ type = "cc"},
		[5277] =	{ type = "defensive"},
		[5938] =	{ type = "dispel"},
		[13750] =	{ type = "offensive"},
		[31224] =	{ type = "defensive"},
		[51690] =	{ type = "offensive"},
		[57934] =	{ type = "other"},
		[76577] =	{ type = "other"}, -- Smoke Bomb,
		[79140] =	{ type = "offensive"},
		[114018] =	{ type = "other"}, -- Shroud of Consealment
		[121471] =	{ type = "offensive"},
		[185311] =	{ type = "defensive"},
		[323547] =	{ type = "covenant"},
		[323654] =	{ type = "covenant"},
		[328305] =	{ type = "covenant"},
		[328547] =	{ type = "covenant"},
	},
	["SHAMAN"] = {
		[2825] =	{ type = "offensive"},
		[8143] =	{ type = "counterCC"},
		[16191] =	{ type = "other"}, -- Mana Tide Totem
		[32182] =	{ type = "offensive"},
		[51514] =	{ type = "cc"},
		[79206] =	{ type = "counterCC"}, -- Spiritwalker's Grace
		[98008] =	{ type = "raidDefensive"}, -- -- Spirit Link Totem
		[108271] =	{ type = "defensive"},
		[108281] =	{ type = "defensive"},
		[108280] =	{ type = "raidDefensive"},	-- Healing Tide Totem,
		[114052] =	{ type = "offensive"},
		[191634] =	{ type = "offensive"},
		[192058] =	{ type = "cc"},
		[192077] =	{ type = "raidMovement"}, -- Wind Rush Totem
		[198103] =  { type = "other" },
		[198838] =	{ type = "defensive"},
		[207399] =	{ type = "defensive"}, -- Ancestral Protection Totem,
		[320137] =	{ type = "offensive"},
		[320674] =	{ type = "covenant"},
		[328923] =	{ type = "covenant"},
		[326059] =	{ type = "covenant"},
		[324386] =	{ type = "covenant"},
	},
	["WARLOCK"] = {
		[1122] =	{ type = "offensive"}, -- Summon Infernal
		[5484] =	{ type = "cc"},
		[5782] =	{ type = "cc"},
		[20707] =	{ type = "other"},
		[29893] =	{ type = "other"}, -- Create Soulwell
		[30283] =	{ type = "cc"},
		[104773] =	{ type = "defensive"},
		[108416] =	{ type = "defensive"},
		[111771] =	{ type = "other"}, -- Demonic Gateway
		[111898] =	{ type = "cc"}, -- Grimoire: Felguard
		[113858] =	{ type = "offensive"}, -- Dark Soul: Instability
		[113860] =	{ type = "offensive"}, -- Dark Soul: Misery
		[205180] =	{ type = "offensive"}, -- Summon Darkglare
		[265187] =	{ type = "offensive"}, -- Summon Demonic Tyrant
		[333889] =	{ type = "offensive"},
		[312321] =	{ type = "covenant"},
		[321792] =	{ type = "covenant"},
		[325289] =	{ type = "covenant"},
		[325640] =	{ type = "covenant"},
	},
	["WARRIOR"] = {
		[871] =		{ type = "defensive"},
		[1160] =	{ type = "defensive"},
		[1161] =	{ type = "other"},
		[1719] =	{ type = "offensive"},
		[2565] =	{ type = "defensive"},
		[5246] =	{ type = "cc"},
		[12323] = 	{ type = "cc"},
		[12975] =	{ type = "defensive"},
		[23920] =	{ type = "counterCC"},
		[46968] =	{ type = "offensive"},
		[64382] =	{ type = "other"},
		[97462] =	{ type = "raidDefensive"},
		[107570] =	{ type = "cc"},
		[118038] =	{ type = "defensive"},
		[184364] =	{ type = "defensive"},
		[190456] =	{ type = "defensive"},
		[228920] =	{ type = "offensive"},
		[307865] =	{ type = "covenant"},
		[317349] =	{ type = "covenant"},
		[324143] =	{ type = "covenant"},
		[325886] =	{ type = "covenant"},
	},
	["GENERAL"] = {
		[20594] =	{ type = "racial"},
		[58984] =	{ type = "racial"},
		[107079] =	{ type = "racial"},
		[178207] =	{ type = "offensive"}, -- Drums of Fury
		[300728] =	{ type = "covenant"},
		[310143] =	{ type = "covenant"},
		[323436] =	{ type = "covenant"},
		[324631] =	{ type = "covenant"},
		[324739] =	{ type = "covenant"},
		[348477] =	{ type = "other"},
	},
	["TRINKET"] = {
		-- pvp
		[196029] =	{ type = "pvptrinket" }, -- Sinful Gladiator's Relentless Brooch 181335
		[336135] =	{ type = "pvptrinket" }, -- Sinful Gladiator's Sigil of Adaptation	181816
		[336126] =	{ type = "pvptrinket" }, -- Sinful Gladiator's Medallion 181333
		[345228] =	{ type = "pvptrinket" }, -- Sinful Gladiator's Badge of Ferocity 175921
		[345231] =	{ type = "pvptrinket" }, -- Sinful Gladiator's Emblem 178447
		-- pve
		[329840] =	{ type = "trinket-defensive"}, -- Blood-Spattered Scale 179331
		[344907] =	{ type = "trinket-defensive"}, -- Splintered Heart of Al'ar 184018
		[345801] =	{ type = "trinket-defensive"}, -- Soulletting Ruby 178809
		[348139] = 	{ type = "trinket-offensive" }, -- Instructor's Divine Bell 184842
		[358712] =	{ type = "trinket-defensive"}, -- Shard of Annhylde's Aegis 186424
	}
}

local spellListWrath = {
	["DEATHKNIGHT"] = {
		[42650] =	{ type = "offensive"},
		[47568] =	{ type = "offensive"},
		[48707] =	{ type = "defensive"},
		[48743] =	{ type = "defensive"},
		[48792] =	{ type = "defensive"},
		[48982] =	{ type = "defensive"},
		[49039] =	{ type = "other"},
		[49206] =	{ type = "offensive"},
		[49576] =	{ type = "disarm"},
		[49028] =	{ type = "defensive"}, -- Dancing Rune Weapon
		[51052] =	{ type = "raidDefensive" },
		[55233] =	{ type = "defensive"},
		[61999] =	{ type = "other" },

		[47476] =	{ type = "cc" },
		[49005] =	{ type = "defensive" },
		[49016] =	{ type = "offensive" },
		[51271] =	{ type = "offensive" },
		[49203] =	{ type = "cc" },
		[49222] =	{ type = "defensive" },

	},
	["DRUID"] = {
		[740] =		{ type = "raidDefensive"},
		[5211] =	{ type = "cc"},
		[20484] =	{ type = "other"},
		[22812] =	{ type = "defensive"},
		[22842] =	{ type = "defensive"},
		[29166] =	{ type = "other"},
		[33786] =	{ type = "cc"},
		[48505] =	{ type = "offensive"},
		[50334] =	{ type = "offensive"},
	},
	["HUNTER"] = {
		[5384] =	{ type = "other"},
		[19574] =	{ type = "offensive"},
		[19577] =	{ type = "cc"},
		[19801] =	{ type = "dispel"},
		[23989] =	{ type = "offensive"},
		[34477] =	{ type = "defensive"},
	},
	["MAGE"] = {
		[118] =		{ type = "cc"},
		[11426] =	{ type = "defensive"},
		[12042] =	{ type = "offensive"},
		[12472] =	{ type = "offensive"},
		[55342] =	{ type = "offensive"},
		[44572] =	{ type = "cc"},
		[45438] =	{ type = "immunity"},
	},
	["PALADIN"] = {
		[642] =		{ type = "immunity"},
		[498] =		{ type = "defensive"},
		[633] =		{ type = "defensive"},
		[853] =		{ type = "cc"},
		[1022] = 	{ type = "externalDefensive"},
		[6940] = 	{ type = "externalDefensive"}, -- Blessing of Sacrifice,
		[20066] =	{ type = "cc"},
		[31821] =	{ type = "raidDefensive"},
		[31842] =	{ type = "other"},
		[54428] =	{ type = "other"},
	},
	["PRIEST"] = {
		[724] =		{ type = "defensive"},
		[8122] =	{ type = "cc"},
		[10060] =	{ type = "offensive"},
		[19236] =	{ type = "defensive"},
		[32375] =	{ type = "dispel"},
		[33206] =	{ type = "externalDefensive"},
		[34433] =	{ type = "offensive"},
		[47585] =	{ type = "defensive"},
		[47788] =	{ type = "externalDefensive"},
		[64843] =	{ type = "raidDefensive"},	-- Divine Hymn
		[64901] =	{ type = "other"},
	},
	["ROGUE"] = {
		[1966] =	{ type = "defensive"},
		[2094] =	{ type = "cc"},
		[5277] =	{ type = "defensive"},
		[13750] =	{ type = "offensive"},
		[31224] =	{ type = "defensive"},
		[51690] =	{ type = "offensive"},
		[51713] =	{ type = "offensive"},
		[57934] =	{ type = "other"},
	},
	["SHAMAN"] = {
		[2825] =	{ type = "offensive"},
		[8143] =	{ type = "counterCC"},
		[16191] =	{ type = "other"}, -- Mana Tide Totem
		[30823] =	{ type = "defensive"},
		[32182] =	{ type = "offensive"},
		[51514] =	{ type = "cc"},
		[55198] =	{ type = "defensive"},
	},
	["WARLOCK"] = {
		[1122] =	{ type = "offensive"}, -- Summon Infernal
		[5484] =	{ type = "cc"},
		[5782] =	{ type = "cc"},
		[20707] =	{ type = "other"},
		[29893] =	{ type = "other"}, -- Create Soulwell
		[30283] =	{ type = "cc"},
		[59672] =	{ type = "defensive"},
	},
	["WARRIOR"] = {
		[871] =		{ type = "defensive"},
		[1161] =	{ type = "other"},
		[1719] =	{ type = "offensive"},
		[2565] =	{ type = "defensive"},
		[5246] =	{ type = "cc"},
		[12975] =	{ type = "defensive"},
		[20230] =	{ type = "offensive"},
		[23920] =	{ type = "counterCC"},
		[46924] =	{ type = "offensive"},
		[46968] =	{ type = "cc"},
		[64382] =	{ type = "other"},

	},
	["GENERAL"] = {
		[20594] =	{ type = "racial"},
		[35476] =	{ type = "offensive"}, -- Drums of Fury
		[58984] =	{ type = "racial"},
		[59752] =	{ type = "racial"},
	},
	["TRINKET"] = {
		-- pvp
		-- pve
	}
}

local spellListClassic = {
	["DRUID"] = {
		[740] =		{ type = "raidDefensive"},
		[5211] =	{ type = "cc"},
		[20484] =	{ type = "other"},
		[22812] =	{ type = "defensive"},
		[22842] =	{ type = "defensive"},
		[29166] =	{ type = "other"},
	},
	["HUNTER"] = {
		[5384] =	{ type = "other"},
		[19574] =	{ type = "offensive"},
		[19577] =	{ type = "cc"},
		[19801] =	{ type = "dispel"},
	},
	["MAGE"] = {
		[118] =		{ type = "cc"},
		[11426] =	{ type = "defensive"},
		[12042] =	{ type = "offensive"},
		[11958] =	{ type = "immunity"},
	},
	["PALADIN"] = {
		[642] =		{ type = "immunity"},
		[498] =		{ type = "defensive"},
		[633] =		{ type = "defensive"},
		[853] =		{ type = "cc"},
		[1022] = 	{ type = "externalDefensive"},
		[6940] = 	{ type = "externalDefensive"}, -- Blessing of Sacrifice,
		[20066] =	{ type = "cc"},
	},
	["PRIEST"] = {
		[724] =		{ type = "defensive"},
		[8122] =	{ type = "cc"},
		[10060] =	{ type = "offensive"},
		[19236] =	{ type = "defensive"},
	},
	["ROGUE"] = {
		[1966] =	{ type = "defensive"},
		[2094] =	{ type = "cc"},
		[5277] =	{ type = "defensive"},
		[13750] =	{ type = "offensive"},
	},
	["SHAMAN"] = {
		[8143] =	{ type = "counterCC"},
		[16191] =	{ type = "other"}, -- Mana Tide Totem
	},
	["WARLOCK"] = {
		[1122] =	{ type = "offensive"}, -- Summon Infernal
		[5484] =	{ type = "cc"},
		[5782] =	{ type = "cc"},
		[20707] =	{ type = "other"},
	},
	["WARRIOR"] = {
		[871] =		{ type = "defensive"},
		[1161] =	{ type = "other"},
		[1719] =	{ type = "offensive"},
		[20230] =	{ type = "offensive"},
		[2565] =	{ type = "defensive"},
		[5246] =	{ type = "cc"},
		[12975] =	{ type = "defensive"},
	},
	["GENERAL"] = {
		[20594] =	{ type = "racial"},
		[20580] =	{ type = "racial"},
	},
	["TRINKET"] = {
		-- pvp
		-- pve
	}
}

local spellList = spellListRetail

--[===[@non-version-retail@
spellListRetail = nil

--@version-classic@
spellList = spellListClassic
spellListWrath = nil
--@end-version-classic@

--@version-wrath@
spellList = spellListWrath
spellListClassic = nil
--@end-version-wrath@

--@end-non-version-retail@]===]

local allSupportedSpells = {}
do
	for k, v in pairs(spellList) do
		for i, j in pairs(v) do
			allSupportedSpells[i] = true
		end
	end
end

function addon:IsSpellSupported(spellID)
	return allSupportedSpells[spellID] ~= nil
end

function addon:GetAllSpellIds()
	return allSupportedSpells
end

function addon:GetSpellEntries(category)
	return spellList[category]
end

function addon:GetFullSpellListNoCategories()
	local tempTable = {}
	for category,x in pairs(spellList) do
		for spellID, v in pairs(x) do
			table.insert(tempTable, { [spellID] =  v.type })
		end
	end
	return tempTable
end

