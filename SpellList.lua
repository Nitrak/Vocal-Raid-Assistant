local _, addon = ...

-- Shoutout to the OmniCD Devs!
local spellListRetail = {
	["DEATHKNIGHT"] = {
		[42650] =	{ type = "offensive"},
		[47568] =	{ type = "offensive"},
		[48707] =	{ type = "defensive"},
		[48743] =	{ type = "defensive"},
		[48792] =	{ type = "defensive"},
		[49039] =	{ type = "other"},
		[49206] =	{ type = "offensive"},
		[49576] =	{ type = "disarm"},
		[49028] =	{ type = "defensive"}, -- Dancing Rune Weapon
		[51052] =	{ type = "raidDefensive" },
		[55233] =	{ type = "defensive"},
		[61999] =	{ type = "other" },
		[108199] =	{ type = "disarm"},
		[114556] =	{ type = "defensive"},
		[152279] =	{ type = "offensive"},
		[194679] =	{ type = "defensive"},
		[194844] =	{ type = "defensive"},
		[206931] =	{ type = "defensive"},
		[207167] =	{ type = "cc"},
		[207289] =	{ type = "offensive"},
		[219809] =	{ type = "defensive"},
		[221562] =	{ type = "defensive"},
		[279302] =	{ type = "offensive"},
		[311648] =	{ type = "covenant"},
		[312202] =	{ type = "covenant"},
		[315443] =	{ type = "covenant"},
		[324128] =	{ type = "covenant"},
		[327574] =	{ type = "defensive"},
	},
	["DEMONHUNTER"] = {
		[179057] =	{ type = "cc"},
		[187827] =	{ type = "defensive"},
		[196555] =	{ type = "immunity"},
		[196718] =	{ type = "raidDefensive"},
		[198589] =	{ type = "defensive"},
		[202137] =	{ type = "disarm"},
		[202138] =	{ type = "disarm"},
		[209258] =	{ type = "defensive"},
		[204021] =	{ type = "defensive"},
		[205604] =	{ type = "counterCC"},
		[205630] =	{ type = "cc"},
		[206491] =	{ type = "offensive"},
		[206803] =	{ type = "defensive"},
		[207684] =	{ type = "cc"},
		[258925] =	{ type = "offensive"},
		[211881] =	{ type = "cc"},
		[212084] =	{ type = "offensive"},
		[217832] =	{ type = "cc"},
		[306830] =	{ type = "covenant"},
		[317009] =	{ type = "covenant"},
		[320341] =	{ type = "defensive"},
		[323639] =	{ type = "covenant"},
		[329554] =	{ type = "covenant"},
	},
	["DRUID"] = {
		[99] =		{ type = "cc"},
		[740] =		{ type = "raidDefensive"},
		[2908] =	{ type = "dispel"},
		[5211] =	{ type = "cc"}, -- Mighty Bash
		[20484] =	{ type = "other"},
		[22812] =	{ type = "defensive"},
		[22842] =	{ type = "defensive"},
		[29166] =	{ type = "other"},
		[33786] =	{ type = "disarm"},
		[33891] =	{ type = "offensive"}, -- Incarnation: Tree of Life resto
		[50334] =	{ type = "offensive"},
		[61336] =	{ type = "defensive"},
		[77761] =	{ type = "other"}, -- Stampeding Roar bear
		[78675] =	{ type = "interrupt"},
		[80313] =	{ type = "defensive"},
		[102342] =	{ type = "externalDefensive"},
		[102359] =	{ type = "disarm"}, -- Mass Entanglement
		[102558] =	{ type = "offensive"}, -- Incarnation: Guardian of Ursoc
		[102793] =	{ type = "disarm"}, -- "Ursol's Vortex"
		[106951] =	{ type = "offensive"},
		[108238] =	{ type = "defensive"},
		[155835] =	{ type = "defensive"},
		[194223] =	{ type = "offensive"},
		[197721] =	{ type = "offensive"},
		[202246] =	{ type = "cc"},
		[202770] =	{ type = "offensive"},
		[205636] =	{ type = "other"}, -- Force of Nature
		[209749] =	{ type = "disarm"},
		[305497] =	{ type = "defensive"},
		[323546] =	{ type = "covenant"},
		[323764] =	{ type = "covenant"}, -- Convoke the Spirits
		[325727] =	{ type = "covenant"},
		[327022] =	{ type = "covenant"}, --Kindred Spirits empowerment
		[327037] =	{ type = "covenant"}, --Kindred Spirits empowerment
		[327071] =	{ type = "covenant"}, --Kindred Spirits empowerment
		[329042] =	{ type = "other"},
		[338142] =	{ type = "covenant"}, --Kindred Spirits solo empowerment
		[338018] =	{ type = "covenant"}, --Kindred Spirits solo empowerment
		[338035] =	{ type = "covenant"}, --Kindred Spirits solo empowerment
		[354654] =	{ type = "defensive"},
	},
	["HUNTER"] = {
		[5384] =	{ type = "other"},
		[19574] =	{ type = "offensive"},
		[19577] =	{ type = "cc"},
		[19801] =	{ type = "dispel"},
		[34477] =	{ type = "defensive"},
		[53480] =	{ type = "externalDefensive"},
		[109248] =	{ type = "other"},
		[109304] =	{ type = "defensive"},
		[186265] =	{ type = "immunity"}, -- Aspect of the Turtle
		[186289] =	{ type = "offensive"},
		[187650] =	{ type = "cc"},
		[193530] =	{ type = "offensive"},
		[201430] =	{ type = "offensive"},
		[264667] =	{ type = "offensive"},
		[266779] =	{ type = "offensive"},
		[281195] =	{ type = "defensive"},
		[288613] =	{ type = "offensive"},
		[308491] =	{ type = "covenant"},
		[321530] =	{ type = "offensive"},
		[324149] =	{ type = "covenant"},
		[325028] =	{ type = "covenant"},
		[328231] =	{ type = "covenant"},
	},
	["MAGE"] = {
		[118] =		{ type = "cc"},
		[11426] =	{ type = "defensive"},
		[12042] =	{ type = "offensive"},
		[12472] =	{ type = "offensive"},
		[45438] =	{ type = "immunity"},
		[55342] =	{ type = "offensive"},
		[80353] =	{ type = "offensive"},
		[86949] =	{ type = "defensive"},
		[342245] =	{ type = "defensive"},
		[190319] =	{ type = "offensive"},
		[198144] =	{ type = "offensive"},
		[235313] =	{ type = "defensive"},
		[235450] =	{ type = "defensive"},
		[307443] =	{ type = "covenant"},
		[314791] =	{ type = "covenant"},
		[314793] =	{ type = "covenant"},
		[321507] =	{ type = "offensive"},
		[324220] =	{ type = "covenant"},
	},
	["MONK"] = {
		[115078] =	{ type = "cc"},
		[115176] =	{ type = "defensive"},
		[115203] =	{ type = "defensive"},
		[115288] =	{ type = "offensive"},
		[115310] =	{ type = "raidDefensive"},
		[115399] =	{ type = "defensive"},
		[116841] =	{ type = "other"},
		[116844] =	{ type = "disarm"},
		[116849] =	{ type = "externalDefensive"},
		[119381] =	{ type = "cc"},
		[122278] =	{ type = "defensive"},
		[122783] =	{ type = "defensive"},
		[122470] =	{ type = "immunity"},
		[123904] =	{ type = "offensive"},
		[132578] =	{ type = "defensive"},
		[137639] =	{ type = "offensive"},
		[152173] =	{ type = "offensive"},
		[197908] =	{ type = "other"},
		[243435] =	{ type = "defensive"},
		[310454] =	{ type = "covenant"},
		[322109] =	{ type = "offensive"},
		[322118] =	{ type = "offensive"},
		[322507] =	{ type = "defensive"},
		[325153] =	{ type = "defensive"},
		[325197] =	{ type = "offensive"},
		[325216] =	{ type = "covenant"},
		[326860] =	{ type = "covenant"},
		[327104] =	{ type = "covenant"},
	},
	["PALADIN"] = {
		[498] =		{ type = "defensive"},
		[633] =		{ type = "defensive"},
		[642] =		{ type = "immunity"},
		[853] =		{ type = "cc"},
		[1022] = 	{ type = "externalDefensive"},
		[6940] = 	{ type = "externalDefensive"}, -- Blessing of Sacrifice,
		[20066] =	{ type = "cc"},
		[31821] =	{ type = "raidDefensive"},
		[31850] =	{ type = "defensive"},
		[31884] =	{ type = "offensive"},
		[86659] =	{ type = "defensive"}, -- Guardian of the Ancient Kings,
		[105809] =	{ type = "offensive"},
		[114158] =	{ type = "offensive"},
		[115750] =	{ type = "cc"},
		[184662] =	{ type = "defensive"},
		[204018] =	{ type = "externalDefensive"}, -- Blessing of Spellwarding
		[216331] =	{ type = "offensive"},
		[231895] =	{ type = "offensive"},
		[304971] =	{ type = "covenant"},
		[316958] =	{ type = "covenant"},
		[328204] =	{ type = "covenant"},
		[328281] =	{ type = "covenant"},
		[328282] =	{ type = "covenant"},
		[328620] =	{ type = "covenant"},
		[328622] =	{ type = "covenant"},
		[327193] =	{ type = "offensive"},
	},
	["PRIEST"] = {
		[8122] =	{ type = "cc"},
		[10060] =	{ type = "offensive"},
		[15286] =	{ type = "raidDefensive"},
		[19236] =	{ type = "defensive"},
		[32375] =	{ type = "dispel"},
		[33206] =	{ type = "externalDefensive"},
		[34433] =	{ type = "offensive"},
		[47536] =	{ type = "offensive"},
		[47585] =	{ type = "defensive"},
		[47788] =	{ type = "externalDefensive"},
		[62618] =	{ type = "raidDefensive"}, -- Power Word: Barrier
		[64044] =	{ type = "cc"},
		[64843] =	{ type = "raidDefensive"},	-- Divine Hymn
		[64901] =	{ type = "other"},
		[73325] =	{ type = "other"},
		[88625] =	{ type = "cc"}, -- Holy Word: Chastise
		[108968] =	{ type = "defensive"},
		[109964] =	{ type = "offensive"},
		[200183] =	{ type = "offensive"},
		[205369] =	{ type = "cc"},
		[228260] =	{ type = "offensive"},
		[246287] =	{ type = "offensive"},
		[265202] =	{ type = "raidDefensive"}, -- Holy Word: Salvation
		[271466] =	{ type = "raidDefensive"},
		[319952] =	{ type = "offensive"}, -- Surrender to Madness
		[323673] =	{ type = "covenant"},
		[324724] =	{ type = "covenant"},
		[325013] =	{ type = "covenant"},
		[327661] =	{ type = "covenant"}
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

