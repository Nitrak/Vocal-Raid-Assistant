local _, addon = ...

-- Shoutout to the OmniCD Devs!
local spellListRetail = {
	["DEATHKNIGHT"] = {
		[42650]  = {type = 1}, --Army of the Dead
		[46585]  = {type = 1}, --Raise Dead
		[47476]  = {type = 5}, --Strangulate
		[47568]  = {type = 1}, --Empower Rune Weapon
		[48707]  = {type = 2}, --Anti-Magic Shell
		[48743]  = {type = 2}, --Death Pact
		[48792]  = {type = 2}, --Icebound Fortitude
		[49028]  = {type = 1}, --Dancing Rune Weapon
		[49039]  = {type = 5}, --Lichborne
		[49206]  = {type = 1}, --Summon Gargoyle
		[51052]  = {type = 4}, --Anti-Magic Zone
		[55233]  = {type = 2}, --Vampiric Blood
		[61999]  = {type = 5}, --Raise Ally
		[108199] = {type = 5}, --Gorefiend's Grasp
		[152279] = {type = 1}, --Breath of Sindragosa
		[207167] = {type = 8}, --Blinding Sleet
		[207289] = {type = 1}, --Unholy Assault
		[207349] = {type = 1}, --Dark Arbiter
		[212552] = {type = 2}, --Wraith Walk
		[219809] = {type = 2}, --Tombstone
		[221562] = {type = 8}, --Asphyxiate
		[221699] = {type = 1}, --Blood Tap
		[275699] = {type = 1}, --Apocalypse
		[279302] = {type = 1}, --Frostwyrm's Fury
		[288853] = {type = 1}, --Raise Abomination
		[327574] = {type = 2}, --Sacrificial Pact
		[383269] = {type = 1}, --Abomination Limb
	},
	["DEMONHUNTER"] = {
		[179057] = {type = 8}, --Chaos Nova
		[183752] = {type = 2}, --Disrupt
		[185245] = {type = 1}, --Torment
		[187827] = {type = 2}, --Metamorphosis #Vengeance
		[188501] = {type = 5}, --Spectral Sight
		[189110] = {type = 1}, --Infernal Strike
		[195072] = {type = 1}, --Fel Rush
		[196555] = {type = 2}, --Netherwalk
		[196718] = {type = 4}, --Darkness
		[198013] = {type = 1}, --Eye Beam
		[198589] = {type = 2}, --Blur
		[198793] = {type = 5}, --Vengeful Retreat
		[200166] = {type = 1}, --Metamorphosis #Havoc
		[202137] = {type = 6}, --Sigil of Silence
		[202138] = {type = 8}, --Sigil of Chains
		[203720] = {type = 1}, --Demon Spikes
		[204021] = {type = 2}, --Fiery Brand
		[204596] = {type = 1}, --Sigil of Flame
		[205604] = {type = 2}, --Reverse Magic
		[206803] = {type = 2}, --Rain from Above
		[207407] = {type = 1}, --Soul Carver
		[207684] = {type = 8}, --Sigil of Misery
		[211881] = {type = 5}, --Fel Eruption
		[212084] = {type = 1}, --Fel Devastation
		[217832] = {type = 8}, --Imprison
		[258860] = {type = 1}, --Essence Break
		[258920] = {type = 1}, --Immolation Aura
		[258925] = {type = 1}, --Fel Barrage
		[263648] = {type = 2}, --Soul Barrier
		[278326] = {type = 4}, --Consume Magic
		[320341] = {type = 2}, --Bulk Extraction
		[342817] = {type = 1}, --Glaive Tempest
		[370965] = {type = 1}, --The Hunt
		[390163] = {type = 1}, --Sigil of Spite
	},
	["DRUID"] = {
		[99] 	 = {type = 8}, --Incapacitating Roar
		[740]    = {type = 4}, --Tranquility
		[1850]   = {type = 5}, --Dash
		[2782]   = {type = 5}, --Remove Corruption
		[2908]   = {type = 5}, --Soothe
		[5211]   = {type = 6}, --Mighty Bash
		[5217]   = {type = 1}, --Tigers Fury
		[20484]  = {type = 5}, --Rebirth
		[22812]  = {type = 2}, --Barkskin
		[22842]  = {type = 5}, --Frenzied Regeneration
		[29166]  = {type = 5}, --Innervate
		[33786]  = {type = 5}, --Cyclone
		[33891]  = {type = 4}, --Incarnation: Tree of Life
		[50334]  = {type = 1}, --Berserk
		[61336]  = {type = 2}, --Survival Instincts
		[61391]  = {type = 8}, --Typhoon
		[78675]  = {type = 8}, --Solar Beam
		[88423]  = {type = 5}, --Nature's Cure
		[102342] = {type = 3}, --Ironbark
		[102359] = {type = 8}, --Mass Entanglement
		[102543] = {type = 1}, --Incarnation: Avatar of Ashamane
		[102558] = {type = 2}, --Incarnation: Guardian of Ursoc
		[102560] = {type = 1}, --Incarnation: Chosen of Elune
		[102793] = {type = 8}, --Ursol's Vortex
		[106898] = {type = 5}, --Stampeding Roar
		[106951] = {type = 1}, --Berserk
		[108238] = {type = 2}, --Renewal
		[124974] = {type = 3}, --Nature's Vigil
		[132158] = {type = 5}, --Nature's Swiftness
		[155835] = {type = 1}, --Bristling Fur
		[194223] = {type = 1}, --Celestial Alignment
		[197721] = {type = 4}, --Flourish
		[200851] = {type = 2}, --Rage of the Sleeper
		[202359] = {type = 1}, --Astral Communion
		[202425] = {type = 1}, --Warrior of Elune
		[202770] = {type = 1}, --Fury of Elune
		[203651] = {type = 3}, --Overgrowth
		[204066] = {type = 8}, --Lunar Beam
		[205636] = {type = 1}, --Force of Nature
		[252216] = {type = 8}, --Tiger Dash
		[274837] = {type = 1}, --Feral Frenzy
		[319454] = {type = 1}, --Heart of the Wild
		[391528] = {type = 1}, --Convoke the Spirits
		[391888] = {type = 1}, --Adaptive Swarm
	},
	["HUNTER"] = {
		[781]	 = {type = 5}, --Disengage
		[1543]	 = {type = 5}, --Flare
		[5384]   = {type = 5}, --Feign Death
		[19574]  = {type = 1}, --Bestial Wrath
		[19801]  = {type = 5}, --Tranquilizing Shot
		[19577]  = {type = 8}, --Intimidation
		[34477]  = {type = 5}, --Misdirection
		[53480]  = {type = 3}, --Roar of Sacrifice
		[109248] = {type = 8}, --Binding Shot
		[109304] = {type = 2}, --Exhilaration
		[120360] = {type = 1}, --Barrage
		[120679] = {type = 1}, --Dire Beast
		[186257] = {type = 2}, --Aspect of the Cheetah
		[186265] = {type = 2}, --Aspect of the Turtle
		[186289] = {type = 1}, --Aspect of the Eagle
		[186387] = {type = 1}, --Bursting Shot
		[187650] = {type = 8}, --Freezing Trap
		[187698] = {type = 8}, --Tar Trap
		[190925] = {type = 1}, --Harpoon
		--[193530] = {type = 1}, --Aspect of the Wild
		--[194407] = {type = 1}, --Spitting Cobra
		[199483] = {type = 2}, --Camouflage
		[201430] = {type = 1}, --Stampede
		[203415] = {type = 1}, --Fury of the Eagle
		[205691] = {type = 1}, --Basilisk
		[208652] = {type = 1}, --Hawk
		[212431] = {type = 1}, --Explosive Shot
		[213691] = {type = 1}, --Scatter Shot
		[236776] = {type = 1}, --High Explosive Trap
		[257044] = {type = 1}, --Rapid Fire
		[260243] = {type = 1}, --Volley
		[264735] = {type = 2}, --Survival of the Fittest
		[266779] = {type = 1}, --Coordinated Assault
		[269751] = {type = 1}, --Flanking Strike
		[272651] = {type = 1}, --Command Pet
		[288613] = {type = 1}, --Trueshot
		[321530] = {type = 1}, --Bloodshed
		[359844] = {type = 1}, --Call of the Wild
		[360952] = {type = 1}, --Coordinated Assault
		[360966] = {type = 1}, --Spearhead
		[375891] = {type = 1}, --Death Chakram
		[392060] = {type = 8}, --Wailing Arrow
		[400456] = {type = 1}, --Salvo
		[430703] = {type = 1}, --Black Arrow
		[459796] = {type = 1}, --Rapid Fire Barrage
		[462031] = {type = 8}, --Implosive Trap
	},
	["MAGE"] = {
		[66]     = {type = 2}, --Invisibility
		[118]    = {type = 8}, --Polymorph
		[11426]  = {type = 2}, --Ice Barrier
		[12042]  = {type = 1}, --Arcane Power
		[12051]  = {type = 1}, --Evocation
		[12472]  = {type = 1}, --Icy Veins
		[45438]  = {type = 2}, --Ice Block
		[31661]  = {type = 1}, --Dragon's Breath
		[55342]  = {type = 2}, --Mirror Image
		[80353]  = {type = 1}, --Time Warp
		[110960] = {type = 2}, --Greater Invisibility | 110959
		[113724] = {type = 8}, --Ring of Frost
		[157981] = {type = 8}, --Blast Wave
		[190319] = {type = 1}, --Combustion
		[190336] = {type = 5}, --Conjure Refreshment
		[205021] = {type = 1}, --Ray of Frost
		[235219] = {type = 2}, --Cold Snap
		[235313] = {type = 5}, --Blazing Barrier
		[235450] = {type = 5}, --Prismatic Barrier
		[342245] = {type = 2}, --Alter Time
		[365350] = {type = 1}, --Arcane Surge
		[383121] = {type = 8}, --Mass Polymorph
		[376103] = {type = 1}, --Radiant Spark
		[382440] = {type = 1}, --Shifting Power
		[414658] = {type = 2}, --Ice Cold
		[414660] = {type = 5}, --Mass Barrier
		[414664] = {type = 5}, --Mass Invisibility
	},
	["MONK"] = {
		[115078] = {type = 8}, --Paralysis
		[115176] = {type = 2}, --Zen Meditation
		[115203] = {type = 2}, --Fortifying Brew
		[115310] = {type = 4}, --Revival
		[115399] = {type = 2}, --Black Ox Brew
		[116844] = {type = 8}, --Ring of Peace
		[116841] = {type = 5}, --Tiger's Lust
		[116849] = {type = 3}, --Life Cocoon
		[119381] = {type = 8}, --Leg Sweep
		[122278] = {type = 2}, --Dampen Harm
		[122470] = {type = 2}, --Touch of Karma
		[122783] = {type = 2}, --Diffuse Magic
		[123904] = {type = 1}, --Invoke Xuen, the White Tiger
		[132578] = {type = 1}, --Invoke Niuzao, the Black Ox
		[137639] = {type = 1}, --Storm, Earth, and Fire
		-- [152173] = {type = 1}, --Serenity
		[197908] = {type = 5}, --Mana Tea
		[243435] = {type = 2}, --Fortifying Brew
		[322109] = {type = 1}, --Touch of Death
		[322118] = {type = 4}, --Invoke Yu'lon, the Jade Serpent
		[325197] = {type = 4}, --Invoke Chi-Ji, the Red Crane
		[388615] = {type = 4}, --Restoral
		[388686] = {type = 1}, --Summon White Tiger Statue
		[388193] = {type = 1}, --Faeline Stomp
	},
	["PALADIN"] = {
		[498]    = {type = 2}, --Divine Protection
		[633]    = {type = 3}, --Lay on Hands
		[642]    = {type = 2}, --Divine Shield
		[853]    = {type = 8}, --Hammer of Justice
		[1022]   = {type = 3}, --Blessing of Protection
		[1044]   = {type = 5}, --Blessing of Freedom
		[4987]   = {type = 5}, --Cleanse
		[6940]   = {type = 3}, --Blessing of Sacrifice
		[10326]  = {type = 5}, --Turn Evil
		[20066]  = {type = 5}, --Repentance
		[31821]  = {type = 4}, --Aura Mastery
		[31850]  = {type = 2}, --Ardent Defender
		[31884]  = {type = 1}, --Avenging Wrath
		[86659]  = {type = 2}, --Guardian of Ancient Kings
		[105809] = {type = 1}, --Holy Avenger
		[114158] = {type = 1}, --Lights`s Hammer
		[114165] = {type = 1}, --Holy Prism
		[115750] = {type = 8}, --Blinding Light
		[148039] = {type = 5}, --Barrier of Faith
		[184662] = {type = 2}, --Shield of Vengeance
		[199452] = {type = 3}, --Ultimate Sacrifice
		[200652] = {type = 5}, --Tyr's Deliverance
		[204018] = {type = 3}, --Blessing of Spellwarding
		[205191] = {type = 2}, --Eye for an Eye
		[213644] = {type = 5}, --Cleanse Toxins
		[216331] = {type = 1}, --Avenging Crusader
		[228049] = {type = 3}, --Guardian of the Forgotten Queen
		[231895] = {type = 1}, --Crusade
		[255937] = {type = 1}, --Wake of Ashes
		[327193] = {type = 1}, --Moment of Glory
		[343527] = {type = 1}, --Execution Sentence
		[343721] = {type = 1}, --Final Reckoning
		[375576] = {type = 1}, --Divine Toll
		[378974] = {type = 1}, --Bastion of Light
		[388007] = {type = 1}, --Blessing of Summer
		[389539] = {type = 1}, --Sentinel
		[414170] = {type = 1}, --Daybreak
		[414273] = {type = 1}, --Hand of Divinity
		[432472] = {type = 1}, --Sacred Weapon
	},
	["PRIEST"] = {
		[586]	 = {type = 2}, --Fade
		[8122]   = {type = 8}, --Psychic Scream
		[10060]  = {type = 1}, --Power Infusion
		[15286]  = {type = 4}, --Vampiric Embrace
		[19236]  = {type = 2}, --Desperate Prayer
		[20711]  = {type = 2}, --Spirit Of Redemption
		[33206]  = {type = 3}, --Pain Suppression
		[32375]  = {type = 5}, --Mass Dispel
		[34433]  = {type = 1}, --Shadowfiend
		[47536]  = {type = 5}, --Rapture
		[47585]  = {type = 2}, --Dispersion
		[47788]  = {type = 3}, --Guardian Spirit
		[62618]  = {type = 4}, --Power Word: Barrier
		[64044]  = {type = 8}, --Psychic Horror
		[64843]  = {type = 4}, --Divine Hymn
		[64901]  = {type = 4}, --Symbol of Hope
		[73325]  = {type = 5}, --Leap of Faith
		[108968] = {type = 3}, --Void Shift
		[109964] = {type = 4}, --Spirit Shell
		[123040] = {type = 1}, --Mindbender spec 256
		[197862] = {type = 1}, --Archangel
		[197871] = {type = 1}, --Dark Archangel
		[200174] = {type = 1}, --Mindbender spec 258
		[200183] = {type = 2}, --Apotheosis
		[215982] = {type = 2}, --Spirit of the Redeemer
		[228260] = {type = 1}, --Void Eruption
		[246287] = {type = 4}, --Evangelism
		[265202] = {type = 4}, --Holy Word: Salvation
		[271466] = {type = 4}, --Luminous Barrier
		[316262] = {type = 1}, --Toughsteal
		[328530] = {type = 1}, --Divine Ascension
		[372835] = {type = 4}, --Lightwell
		[375901] = {type = 1}, --Mindgames
		[421453] = {type = 1}, --Ultimate Penitence
	},
	["ROGUE"] = {
		[1856]   = {type = 1}, --Vanish
		[1966]   = {type = 2}, --Faint
		[2094]   = {type = 8}, --Blind
		[5277]   = {type = 2}, --Evasion
		[5938]   = {type = 5}, --Shiv
		[13750]  = {type = 1}, --Adrenaline Rush
		[31224]  = {type = 2}, --Cloak of Shadows
		[51690]  = {type = 1}, --Killing Spree
		[57934]  = {type = 5}, --Tricks of the Trade
		[79140]  = {type = 1}, --Vendetta
		[114018] = {type = 5}, --Shroud of Concealment
		[121471] = {type = 1}, --Shadow Blades
		[137619] = {type = 1}, --Marked for Death
		[185311] = {type = 2}, --Crimson Vial
		[199754] = {type = 2}, --Riposte
		[212182] = {type = 5}, --Smoke Bombe
		[343142] = {type = 1}, --Dreadblades
		[360194] = {type = 1}, --Deathmark
		[385616] = {type = 1}, --Echoing Reprimand
		[384631] = {type = 1}, --Flagellation
		[385408] = {type = 1}, --Sepsis
		[385424] = {type = 1}, --Serrated Bone Spike
		[385627] = {type = 1}, --Kingsbane
	},
	["SHAMAN"] = {
		[2825]   = {type = 1}, --Bloodlust
		[8143]   = {type = 5}, --Tremor Totem
		[16191]  = {type = 5}, --Mana Tide Totem
		[20608]  = {type = 5}, --Reincarnation
		[51485]  = {type = 8}, --Earthgrab Totem
		[51490]  = {type = 5}, --Thunderstorm
		[51514]  = {type = 5}, --Hex
		[51533]  = {type = 1}, --Feral Spirit
		[58875]  = {type = 5}, --Spirit Walk
		[79206]  = {type = 5}, --Spiritwalker's Grace
		[98008]  = {type = 4}, --Spirit Link Totem
		[108271] = {type = 2}, --Astral Shift
		[108280] = {type = 4}, --Healing Tide Totem
		[108281] = {type = 4}, --Ancestral Guidance
		[114050] = {type = 1}, --Ascendance
		[191634] = {type = 1}, --Stormkeeper
		[192058] = {type = 8}, --Capacitor Totem
		[192222] = {type = 1}, --Liquid Magna Totem
		[192077] = {type = 5}, --Wind Rush Totem
		[192249] = {type = 1}, --Storm Elemental
		[193876] = {type = 1}, --Shamanism
		[198067] = {type = 1}, --Fire Elemental
		[198103] = {type = 2}, --Earth Elemental
		[198838] = {type = 3}, --Earthen Wall Totem
		[207399] = {type = 4}, --Ancestral Protection Totem
		[355580] = {type = 5}, --Static Field Totem
		[375982] = {type = 1}, --Primordial Wave
		[383013] = {type = 5}, --Poison Cleansing Totem
		[384352] = {type = 1}, --Doom Winds
	},
	["WARLOCK"] = {
		[698]	 = {type = 5}, --Ritual of Summoning
		[702]	 = {type = 1}, --Curse of Weakness
		[1714]   = {type = 1}, --Curse of Tongues
		[1122]   = {type = 1}, --Summon Infernal
		[5484]   = {type = 8}, --Howl of Terror
		[6789]   = {type = 5}, --Mortal Coil
		[29893]  = {type = 5}, --Soulwell
		[30283]  = {type = 8}, --Shadowfury
		[104773] = {type = 2}, --Unending Resolve
		[108416] = {type = 2}, --Dark Pact
		[111898] = {type = 1}, --Grimoire: Felguard
		[113858] = {type = 1}, --Dark Soul: Instability
		[113860] = {type = 1}, --Dark Soul: Misery
		[111771] = {type = 5}, --Demonic Gateway
		[205180] = {type = 1}, --Summon Darkglare
		[212459] = {type = 1}, --Call Fel Lord
		[221703] = {type = 2}, --Casting Circle
		[265187] = {type = 1}, --Summon Demonic Tyrant
		[267171] = {type = 1}, --Demonic Strength
		[267217] = {type = 1}, --Nether Portal
		[333889] = {type = 1}, --Fel Domination
		[386997] = {type = 1}, --Soul Rot
	},
	["WARRIOR"] = {
		[871]    = {type = 2}, --Shield Wall
		[1160]   = {type = 5}, --Demoralizing Shout
		[1161]   = {type = 5}, --Challenging Shout
		[1719]   = {type = 1}, --Recklessness
		[5246]   = {type = 8}, --Intimidating Shout
		[12975]  = {type = 2}, --Last Stand
		[18499]  = {type = 1}, --Berserker Rage
		[23920]  = {type = 2}, --Spell Reflection
		[46968]  = {type = 5}, --Shockwave
		[64382]  = {type = 1}, --Shattering Throw
		[97462]  = {type = 4}, --Rallying Cry
		[107570] = {type = 1}, --Storm Bolt
		[107574] = {type = 1}, --Avatar
		[118038] = {type = 2}, --Die by the Sword
		-- [152277] = {type = 1}, --Ravager
		[184364] = {type = 2}, --Enraged Regeneration
		[227847] = {type = 1}, --Bladestorm
		[228920] = {type = 1}, --Ravager
		[236273] = {type = 2}, --Duel
		[236320] = {type = 5}, --War Banner
		[262228] = {type = 1}, --Deadly Calm
		[383762] = {type = 2}, --Bitter Immunity
		[384318] = {type = 1}, --Thunderous Roar
		[392966] = {type = 2}, --Spell Block
		[376079] = {type = 1}, --Spear of Bastion
	},
	["EVOKER"] = {
		[355913] = {type = 5}, --Emerald Blossom
		[355936] = {type = 1}, --Dream Breath
		[357170] = {type = 3}, --Time Dilation
		[357208] = {type = 1}, --Fire Breath
		[357210] = {type = 1}, --Deep Breath
		[357214] = {type = 5}, --Wing Buffet
		[358267] = {type = 5}, --Hover
		[358385] = {type = 8}, --Landslide
		[359073] = {type = 1}, --Eternity Surge
		[359816] = {type = 4}, --Dream Flight
		[360806] = {type = 5}, --Sleep Walk
		[360823] = {type = 5}, --Naturalize
		[360827] = {type = 5}, --Blistering Scales
		[360995] = {type = 5}, --Verdant Embrace
		[363534] = {type = 4}, --Rewind
		[365585] = {type = 5}, --Expunge
		[367226] = {type = 5}, --Spiritbloom
		[368970] = {type = 5}, --Tailswipe
		[363916] = {type = 2}, --Obsidian Scales
		[368847] = {type = 1}, --Firestorm
		[370537] = {type = 4}, --Stasis
		[370553] = {type = 1}, --Tip the Scales
		[370665] = {type = 5}, --Rescue
		[370960] = {type = 2}, --Emerald Communion
		[371032] = {type = 5}, --Terror of the Skies
		[372048] = {type = 8}, --Oppressing Roar
		[374227] = {type = 4}, --Zephyr
		[374251] = {type = 5}, --Cauzerizing Flame
		[374348] = {type = 2}, --Renewing Blaze
		[374968] = {type = 5}, --Time Spiral
		[375087] = {type = 1}, --Dragonrage
		[390386] = {type = 1}, --Fury of the Aspects
		[396286] = {type = 8}, --Upheaval
		[403631] = {type = 1}, --Breath of Eons
		[404977] = {type = 5}, --Time Skip
		[406732] = {type = 5}, --Spatial Paradox
	},
	["GENERAL"] = {
		[20549]  = {type = 5}, --War Stomp
		[20594]  = {type = 5}, --Stoneform
		[25046]  = {type = 5}, --Arcane Torrent
		[58984]  = {type = 5}, --Shadowmeld
		[107079] = {type = 5}, --Quaking Palm
		[255654] = {type = 5}, --Bull Rush
		[381301] = {type = 1}, --Feral Hide Drums
	},
	["TRINKET"] = {
		-- pvp
		[336126] = {type = 12}, -- Verdant Gladiator's Medallion
		[336135] = {type = 12}, -- Verdant Gladiator's Sigil of Adaptation
		[345228] = {type = 12}, -- Verdant Gladiator's Badge of Ferocity
		[345229] = {type = 12}, -- Verdant Gladiator's Insignia of Alacrity
		[345231] = {type = 12}, -- Verdant Gladiator's Emblem

		-- pve
		[442489] = {type = 11}, -- Reactive Webbed Escutcheon
		[443124] = {type = 11}, -- Mad Queen's Mandate
		[443415] = {type = 11}, -- High Speaker's Accretion
		[443529] = {type = 11}, -- Burin of the Candle King
		[443535] = {type = 11}, -- Tome of Light's Devotion
		[443536] = {type = 11}, -- Bursting Lightshard
		[443552] = {type = 11}, -- Oppressive Orator's Larynx
		[443556] = {type = 11}, -- Twin Fang Instruments
		[444264] = {type = 11}, -- Foul Behemoth's Chelicera
		[444301] = {type = 11}, -- Swarmlord's Authority
		[444489] = {type = 11}, -- Skyterror's Corrosive Organ
		[448904] = {type = 11}, -- Ravenous Honey Buzzer
		[451568] = {type = 11}, -- Refracting Aggression Module
		[455467] = {type = 11}, -- Kaheti Shadeweaver's Emblem
	}
}

local spellListCata = {
	["DEATHKNIGHT"] = {
		[42650]  = {type = 1},
		[46585]  = {type = 1}, --Raise Dead
		[47476]  = {type = 8},
		[47568]  = {type = 1},
		[48707]  = {type = 2},
		[48743]  = {type = 2},
		[48792]  = {type = 2},
		[48982]  = {type = 2},
		[49005]  = {type = 2},
		[49016]  = {type = 1},
		[49028]  = {type = 2}, -- Dancing Rune Weapon
		[49039]  = {type = 2},
		[49203]  = {type = 8},
		[49206]  = {type = 1},
		[49222]  = {type = 2},
		[49576]  = {type = 5},
		[51052]  = {type = 4},
		[51271]  = {type = 1},
		[55233]  = {type = 2},
		[61999]  = {type = 5},

	},
	["DRUID"] = {
		[740]    = {type = 4},
		[5211]   = {type = 8},
		[20484]  = {type = 5},
		[22812]  = {type = 2},
		[22842]  = {type = 2},
		[29166]  = {type = 5},
		[33786]  = {type = 8},
		[48505]  = {type = 1},
		[50334]  = {type = 1},
		[50516]	 = {type = 8},
	},
	["HUNTER"] = {
		[5384]   = {type = 5},
		[19574]  = {type = 1},
		[19577]  = {type = 8},
		[19801]  = {type = 5},
		[23989]  = {type = 1},
		[34477]  = {type = 2},
	},
	["MAGE"] = {
		[118]    = {type = 8},
		[11426]  = {type = 2},
		[12042]  = {type = 1},
		[12051]  = {type = 1}, --Evocation
		[12472]  = {type = 1},
		[31661]  = {type = 1}, --Dragon's Breath
		[45438]  = {type = 5},
		[44572]  = {type = 8},
		[55342]  = {type = 1},
	},
	["PALADIN"] = {
		[498]	 = {type = 3},
		[633]	 = {type = 3},
		[642]	 = {type = 5},
		[853]	 = {type = 8},
		[1022]	 = {type = 3},
		[1044]	 = {type = 5}, -- Blessing of Freedom
		[6940]	 = {type = 3}, -- Blessing of Sacrifice
		[20066]	 = {type = 8},
		[31821]	 = {type = 4},
		[31842]	 = {type = 5},
		[54428]	 = {type = 5},
		[64205]  = {type = 4}, -- Divine Sacrifice
	},
	["PRIEST"] = {
		[724] 	 = {type = 3},
		[8122]	 = {type = 8},
		[10060]  = {type = 1},
		[19236]  = {type = 1},
		[20711]  = {type = 2}, --Spirit Of Redemption
		[32375]  = {type = 5},
		[33206]  = {type = 4},
		[34433]  = {type = 1},
		[47585]  = {type = 2},
		[47788]  = {type = 3},
		[64843]  = {type = 4},	-- Divine Hymn
		[64901]  = {type = 5},
	},
	["ROGUE"] = {
		[1856]	 = {type = 1}, --Vanish
		[1966]	 = {type = 2},
		[2094]	 = {type = 8},
		[5277]	 = {type = 2},
		[13750]	 = {type = 1},
		[31224]	 = {type = 2},
		[51690]	 = {type = 1},
		[51713]	 = {type = 1},
		[57934]	 = {type = 5},
	},
	["SHAMAN"] = {
		[2825]	 = {type = 1},
		[2894]	 = {type = 1}, --Fire Elemental
		[8143]	 = {type = 5},
		[16191]  = {type = 5}, -- Mana Tide Totem
		[20608]  = {type = 5}, --Reincarnation
		[30823]  = {type = 2},
		[32182]  = {type = 1},
		[51514]  = {type = 8},
		[51533]  = {type = 1}, --Feral Spirit
		[55198]  = {type = 2},
		[58875]  = {type = 5}, --Spirit Walk
	},
	["WARLOCK"] = {
		[1122]	 = {type = 1}, -- Summon Infernal
		[5484]	 = {type = 8},
		[5782]	 = {type = 8},
		[20707]  = {type = 5},
		[29893]  = {type = 5}, -- Create Soulwell
		[30283]  = {type = 8},
		[59672]  = {type = 2},
	},
	["WARRIOR"] = {
		[871]	 = {type = 2},
		[1161]	 = {type = 5},
		[1719]	 = {type = 1},
		[2565]	 = {type = 2},
		[5246]	 = {type = 8},
		[12975]  = {type = 2},
		[18499]  = {type = 1}, --Berserker Rage
		[20230]  = {type = 1},
		[23920]  = {type = 5},
		[46924]  = {type = 1},
		[46968]  = {type = 8},
		[64382]  = {type = 6},

	},
	["GENERAL"] = {
		[20594]	 = {type = 5}, --Stoneform
		[25046]  = {type = 5}, --Arcane Torrent
		[35476]	 = {type = 5}, --Drums of Battle
		[58984]	 = {type = 5}, --Shadowmeld
		[59752]	 = {type = 5}, --Will to Survive
		[351355] = {type = 5}, --Greater Drums of Battle
	},
	["TRINKET"] = {
		-- pvp
		-- pve
	}
}

local spellListClassic = {
	["DRUID"] = {
		[740]	 = {type = 4},
		[5211]	 = {type = 8},
		[20484]	 = {type = 5},
		[22812]	 = {type = 2},
		[22842]	 = {type = 2},
		[29166]	 = {type = 5},
	},
	["HUNTER"] = {
		[5384]	 = {type = 5},
		[19574]	 = {type = 1},
		[19577]	 = {type = 8},
		[19801]	 = {type = 5},
	},
	["MAGE"] = {
		[118]	 = {type = 8},
		[11426]	 = {type = 2},
		[11958]	 = {type = 5},
		[12042]	 = {type = 1},
		[12051]	 =  {type = 1}, --Evocation
	},
	["PALADIN"] = {
		[642]	 = {type = 5},
		[498]	 = {type = 2},
		[633]	 = {type = 2},
		[853]	 = {type = 8},
		[1022]	 = {type = 3},
		[6940]	 = {type = 3}, -- Blessing of Sacrifice,
		[20066]	 = {type = 8},
	},
	["PRIEST"] = {
		[724]	 = {type = 2},
		[8122]	 = {type = 8},
		[10060]	 = {type = 1},
		[19236]	 = {type = 2},
		[20711]  = {type = 2}, --Spirit Of Redemption
	},
	["ROGUE"] = {
		[1856]	 = {type = 1}, --Vanish
		[1966]	 = {type = 2},
		[2094]	 = {type = 8},
		[5277]	 = {type = 2},
		[13750]	 = {type = 1},
	},
	["SHAMAN"] = {
		[8143]	 = {type = 5},
		[16191]	 = {type = 5}, -- Mana Tide Totem
		[20608]	 = {type = 5}, --Reincarnation
	},
	["WARLOCK"] = {
		[1122]	 = {type = 1}, -- Summon Infernal
		[5484]	 = {type = 8},
		[5782]	 = {type = 8},
		[20707]	 = {type = 5},
	},
	["WARRIOR"] = {
		[871]	 = {type = 2},
		[1161]	 = {type = 5},
		[1719]	 = {type = 1},
		[2565]	 = {type = 2},
		[5246]	 = {type = 8},
		[12975]	 = {type = 2},
		[18499]	 = {type = 1}, --Berserker Rage
		[20230]	 = {type = 1},
		[23920]  = {type = 2},
	},
	["GENERAL"] = {
		[20580]	 = {type = 5},
		[20594]	 = {type = 5},
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
spellListCata = nil
--@end-version-classic@

--@version-cata@
spellList = spellListCata
spellListClassic = nil
--@end-version-cata@

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

