function VocalRaidAssistant:GetBarData() 
	return {
	
		[51052] = {
			desc = "",
			type = "premade",
			class = "DEATH KNIGHT",
			cd = 2*60,
		},
		[740] = {
			desc = "",
			type = "premade",
			class = "DRUID",
			cd = 8*60,
		},
		[115310] = {
			desc = "",
			type = "premade",
			class = "MONK",
			cd = 3*60,
		},
		[31821] = {
			desc = "",
			type = "premade",
			class = "PALADIN",
			cd = 3*60,
		},
		[64843] = {
			desc = "",
			type = "premade",
			class = "PRIEST",
			cd = 3*60,
		},
		[62618] = {
			desc = "",
			type = "premade",
			class = "PRIEST",
			cd = 3*60,
		},
		[15286] = {
			desc = "",
			type = "premade",
			class = "PRIEST",
			cd = 3*60,
		},
		[76577] = {
			desc = "",
			type = "premade",
			class = "ROGUE",
			cd = 3*60,
		},
		[108280] = {
			desc = "",
			type = "premade",
			class = "SHAMAN",
			cd = 3*60,
		},
		[98008] = {
			desc = "",
			type = "premade",
			class = "SHAMAN",
			cd = 3*60,
		},
		[97462] = {
			desc = "",
			type = "premade",
			class = "WARRIOR",
			cd = 3*60,
		},
		[159916] = {
			desc = "",
			type = "premade",
			class = "MAGE",
			cd = 2*60,
		},
	}
end

function VocalRaidAssistant:GetBarDataO() 
	return {
	
		[90355] = {
			desc = "",
			type = "premade",
			class = "HUNTER",
			duration = 40,
		},
		[80353] = {
			desc = "",
			type = "premade",
			class = "MAGE",
			duration = 40,
		},
		[2825] = {
			desc = "",
			type = "premade",
			class = "SHAMAN",
			duration = 40,
		},
		[32182] = {
			desc = "",
			type = "premade",
			class = "SHAMAN",
			duration = 40,
		},
		[178207] = {
			desc = "",
			type = "premade",
			class = "SHAMAN",
			duration = 40,
		},
		[64382] = {
			desc = "",
			type = "premade",
			class = "WARRIOR",
			duration = 10,
		},
		[172106] = {
			desc = "",
			type = "premade",
			class = "HUNTER",
			duration = 6,
		},
	}
end	

function VocalRaidAssistant:GetBarDataB() 
	return {
	
		[51052] = {
			desc = "",
			type = "premade",
			class = "DEATH KNIGHT",
			duration = 3,
		},
		[740] = {
			desc = "",
			type = "premade",
			class = "DRUID",
			duration = 8,
		},
		[102342] = {
			desc = "",
			type = "premade self",
			class = "DRUID",
			duration = 12,
		},
		[116849] = {
			desc = "",
			type = "premade self",
			class = "MONK",
			duration = 12,
		},
		[31821] = {
			desc = "",
			type = "premade",
			class = "PALADIN",
			duration = 6,
		},
		[6940] = {
			desc = "",
			type = "premade self",
			class = "PALADIN",
			duration = 12,
		},
		[64843] = {
			desc = "",
			type = "premade",
			class = "PRIEST",
			duration = 8,
		},
		[62618] = {
			desc = "",
			type = "premade",
			class = "PRIEST",
			duration = 10,
		},
		[15286] = {
			desc = "",
			type = "premade",
			class = "PRIEST",
			duration = 15,
		},
		[33206] = {
			desc = "",
			type = "premade self",
			class = "PRIEST",
			duration = 8,
		},
		[76577] = {
			desc = "",
			type = "premade",
			class = "ROGUE",
			duration = 5,
		},
		[108280] = {
			desc = "",
			type = "premade",
			class = "SHAMAN",
			duration = 10,
		},
		[98008] = {
			desc = "",
			type = "premade",
			class = "SHAMAN",
			duration = 6,
		},
		[97462] = {
			desc = "",
			type = "premade",
			class = "WARRIOR",
			duration = 10,
		},
		[159916] = {
			desc = "",
			type = "premade",
			class = "MAGE",
			duration = 6,
		},
	}
end	

function VocalRaidAssistant:GetSpellList ()
	return {
		auraApplied ={					-- aura applied [spellid] = ".mp3 file name",
			--general
			[20594] = "stoneform",
			[107079] = "quakingpalm",
			[58984] = "shadowmeld",
			--druid
			[102342] = "ironbark",
			[22812] = "barkskin",
			[61336] = "survivalinstincts",
			[33891] = "incarnationtree", --resto
			[192081] = "ironfur",
			[29166] = "innervate",
			[33786] = "cyclone",
			
			--demon hunter
			[198589] = "blur",
			[217832] = "imprison",
			--demon hunter
			[204021] = "fierybrand",
			[187827] = "metamorphosis",
			[211881] = "feleruption",
			--[207810] = "netherbond",
			--[207407] = "soulcarver",

			--paladin
			[1022] = "blessingofprotection", 
			[6940] = "sacrifice", 
			[86659] = "guardianofancientkings",
			[31850] = "ardentdefender",
			[204018] = "spellwarding",
			--[498] = "divineprotection",
			[642] = "divineshield",
			[31884] = "avengingwrath",
			[216331] = "avengingcrusader",
			[105809] = "holyavenger",
			--[156322] = "eternalflame",
			--[200652] = "tyrsdeliverance",
			--[209202] = "eyeoftyr",
			[853] = "hammerofjustice",
			[20066] = "repentance",
			--rogue
			[57934] = "tricksofthetrade",
			[2094] = "blind",
			--warrior
			[871] = "shieldwall",
			[12975] = "laststand",
			[118038] = "diebythesword",
			[190456] = "ignorepain",
			--[203524] = "neltharionsfury",
			[2565] = "shieldblock",
			[5246] = "intimidatingshout",
			[23920] = "spellreflection",
			
			--preist
			[33206] = "painSuppression", 
			[47788] = "guardianSpirit",
			--[207946] = "lightswrath",
			--[208065] = "lightoftuure",
			[8122] = "psychicscream",
			
			--shaman
			[114052] = "ascendance",
			--[207778] = "giftofthequeen",
			[79206] = "spiritwalker",
			[51514] = "hex",
			--mage
			[118] = "polymorph",
			--dk
			[48792] = "icebound",
			[49028] = "dancingruneweapon",
			[55233] = "vampiricblood",
			[48707] = "antimagicshell",
			[221562] = "asphyxiate",
			[49576] = "deathgrip",
			--[206977] = "bloodmirror",
			[194844] = "bonestorm",
			[194679] = "runetap",
			[219809] = "tombstone",
			--hunter
			[34477] = "misdirection",
			[53480] = "roarofsacrifice",
			[187650] = "freezingtrap",
			--lock
			[5782] = "fear",
			--monk
			[116849] = "lifeCocoon",
			[115203] = "fortifyingbrew",
			[122278] = "dampenharm",
			[122783] = "diffusemagic",
			[115176] = "zenmeditation",
			[325197] = "invokechiji",
			[115078] = "paralysis",
			--[205406] = "sheilunsgift",
			
		},
		auraRemoved = {					-- aura removed [spellid] = ".mp3 file name",
			
		},
		castStart = {					-- cast start [spellid] = ".mp3 file name",
			
		},
		castSuccess = {					--cast success [spellid] = ".mp3 file name",
			--general
			[178207] = "drums",
			[323436] = "purifysoul",
			--druid
			[740] = "tranquility",
			[106898] = "stampedingRoar",
			[77764] = "stampedingRoar", --cat
			[77761] = "stampedingRoar", --bear
			[20484] = "rebirth",
			[197721] = "flourish",
			[102793] = "ursolsvortex",
			[323764] = "convoke",
			[205636] = "forceofnature",
			--[124974] = "naturesvigil",
			--[200851] = "rageofthesleeper",
			--[208253] = "essenceofghanir",
			--demon hunter
			[196718] = "darkness",
			[179057] = "chaosnova",
			[202137] = "sigilofsilence",
			[207684] = "sigilofmisery",
			[202138] = "sigilofchains",
			[329554] = "foddertotheflame",
			--paladin	
			[31821] = "AuraMastery",
			[633] = "layonHands",
			[316958] = "ashenhallow",
			[304971] = "divinetoll",
			--rogue
			[76577] = "smokeBomb",

			--warrior
			[97462] = "rallyingcry", 
			[1160] = "demoralizingshout",
			[228920] = "ravager",
			[46968] = "shockwave",
			--priest
			[200183] = "apotheosis",
			[64843] = "divineHymn",
			[62618] = "barrier",
			[271466] = "luminousbarrier",
			[32375] = "massdispel",
			[15286] = "vampiricembrace",
			[64901] = "symbolofhope",
			[205369] = "mindbomb",
			[265202] = "salvation",
			[73325] = "leapoffaith",
			[34433] = "shadowfiend",
			[246287] = "evangelism",
			[47536] = "rapture",
			[325013] = "boonoftheascended",
			[323673] = "mindgames",
			[109964] = "spiritshell",
			--shaman
			[98008] = "spiritlinktotem",
			[108280] = "healingTide",
			[2825] = "bloodlust",
			[32182] = "heroism",
			[192077] = "windrushtotem",
			[8143] = "tremortotem",
			[207399] = "ancestralprotection",
			[198838] = "earthenshieldtotem",
			[192058] = "lightningsurgetotem",
			[320674] = "chainharvest",
			[328923] = "faetransfusion",
			[326059] = "primordialwave",
			[324386] = "vespertotem",
			--mage
			[80353] = "timewarp",
			--dk
			[51052] = "antiMagicZone",
			[61999] = "raiseally",
			[108199] = "gorefiendsgrasp",
			[315443] = "abominationlimb",
			--hunter
			[264667] = "primalrage",
			[109248] = "bindingshot",
			[328231] = "wildspirits",
			--warlock
			[20707] = "soulstone",
			[30283] = "shadowfury",
			[111771] = "gateway",
			-- monk
			[115310] = "Revival",
			[119381] = "legsweep",
			[116844] = "ringofpeace",
			[310454] = "weaponsoforder",
		
			
			
		},
		friendlyInterrupt = {			--friendly interrupt [spellid] = ".mp3 file name",
			[19647] = "lockout", -- Spell Lock
			[2139] = "lockout", -- Counter Spell
			[1766] = "lockout", -- Kick
			[6552] = "lockout", -- Pummel
			[47528] = "lockout", -- Mind Freeze
			[96231] = "lockout", -- Rebuke
			[93985] = "lockout", -- Skull Bash
			[97547] = "lockout", -- Solar Beam
			[57994] = "lockout", -- Wind Shear
			[116705] = "lockout", -- Spear Hand Strike
			[113287] = "lockout", -- Symbiosis Solar Beam
			[147362] = "lockout", -- Counter Shot
			[34490] = "lockout", -- Silencing Shot
			[183752] = "lockout", -- Consume Magic
			[187707] = "lockout", -- Muzzle
		},
	}
end

