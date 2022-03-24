local _, addon = ...
local L = addon.L

local defaultSpells = {
	
}

addon.DATABASE_VERSION = 2

addon.DEFAULT_SPELLS = defaultSpells

addon.DEFAULTS = {
	profile = {
		general = {
			area = {
				arena = {
					spells = defaultSpells
				},
				none = {
					spells = defaultSpells
				},
				party = {
					enabled = true,
					enableInterrupts = true,
					spells = defaultSpells
				},
				raid = {
					enabled = true,
					enableInterrupts = true,
					spells = defaultSpells
				},
				pvp = {
					spells = defaultSpells
				},
				scenario = {
					spells = defaultSpells
				}
			},
			watchFor = 6, -- COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
			minimap = {}
		},
		sound = {
			soundpack = "en-US-SaraNeural",
			throttle = 0,
			channel = "Master"
		},
		version = addon.DATABASE_VERSION
	}
}

addon.SOUND_PACKS = {
	["en-US-AnaNeural"] = "Ana",
	["en-US-ElizabethNeural"] = "Elizabeth",
	["legacy-en-Julie"] = "Julie (Legacy)",
	["en-US-SaraNeural"] = "Sara",
	["en-US-EricNeural"] = "Eric",
	["en-US-GuyNeural"] = "Guy"
}

addon.SOUND_CHANNEL = {
	["Master"] = L["Master"],
	["SFX"] = L["Sound"],
	["Ambience"] = L["Ambience"],
	["Music"] = L["Music"],
	["Dialog"] = L["Dialog"]
}

addon.FILTER_VALUES = {
	["player"] = COMBATLOG_OBJECT_AFFILIATION_MINE,
	["grouporraid"] = bit.bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID)
}

addon.ZONES = {
	["raid"] = {
		name = RAIDS,
		order = 1
	},
	["party"] = {
		name = DUNGEONS,
		order = 2
	},
	["none"] = {
		name = BUG_CATEGORY2,
		order = 3
	},
	["arena"] = {
		name = ARENA,
		order = 4
	},
	["pvp"] = {
		name = BATTLEGROUNDS,
		order = 5
	}
}

addon.CATEGORY_SORT_ORDER = {
	"racial",
	"interrupt",
	"raidDefensive",
	"externalDefensive",
	"defensive",
	"immunity",
	"offensive",
	"dispel",
	"cc",
	"counterCC",
	"disarm",
	"raidMovement",
	"trinket-offensive",
	"trinket-defensive",
	"pvptrinket",
	"other"
}

addon.CATEGORY = {
	["pvptrinket"] = L["PvP Trinket"],
	["racial"] = L["Racial Traits"],
	["trinket-defensive"] = L["Defensive"].." "..INVTYPE_TRINKET,
	["trinket-offensive"] = L["Offensive"].." "..INVTYPE_TRINKET,
	["interrupt"] = LOC_TYPE_INTERRUPT,
	["dispel"] = DISPELS,
	["cc"] = L["Crowd Control"],
	["disarm"] = format("%s, %s, %s", LOC_TYPE_DISARM, LOC_TYPE_ROOT, LOC_TYPE_SILENCE),
	["immunity"] = L["Immunity"],
	["externalDefensive"] = L["External Defensive"],
	["defensive"] = L["Defensive"],
	["raidDefensive"] = L["Raid Defensive"],
	["offensive"] = L["Offensive"],
	["counterCC"] = L["Counter CC"],
	["raidMovement"] = L["Raid Movement"],
	["other"] = OTHER
}

addon.ICONCONFIG = {
	type = "launcher",
	icon = "Interface\\COMMON\\VoiceChat-Speaker",
	iconCoords = {-0.45, 1, -0.05, 1},
	OnClick = function(clickedframe, button)
		addon:ChatCommand()
	end,
	OnTooltipShow = function(tooltip)
		tooltip:SetText(L["VRANAME"])
		tooltip:Show()
	end
}
