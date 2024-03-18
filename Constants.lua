local _, addon = ...
local L = addon.L

local defaultSpellsRetail = {
	["118"] = true,
	["642"] = true,
	["740"] = true,
	["871"] = true,
	["1022"] = true,
	["2094"] = true,
	["2825"] = true,
	["12975"] = true,
	["13750"] = true,
	["16191"] = true,
	["23920"] = true,
	["31821"] = true,
	["33206"] = true,
	["48707"] = true,
	["51052"] = true,
	["61336"] = true,
	["62618"] = true,
	["64843"] = true,
	["64901"] = true,
	["98008"] = true,
	["102342"] = true,
	["106898"] = true,
	["108280"] = true,
	["109964"] = true,
	["111771"] = true,
	["115078"] = true,
	["115310"] = true,
	["116849"] = true,
	["190319"] = true,
	["193530"] = true,
	["196718"] = true,
	["217832"] = true,
	["322109"] = true,
}

local defaultSpellsWrath = {
	["118"] = true,
	["642"] = true,
	["740"] = true,
	["871"] = true,
	["1022"] = true,
	["2094"] = true,
	["2825"] = true,
	["12975"] = true,
	["13750"] = true,
	["16191"] = true,
	["23920"] = true,
	["31821"] = true,
	["33206"] = true,
	["48707"] = true,
	["51052"] = true,
	["61336"] = true,
	["64843"] = true,
	["64901"] = true,
}

local defaultSpellsClassic = {
	["118"] = true,
	["642"] = true,
	["740"] = true,
	["871"] = true,
	["1022"] = true,
	["2094"] = true,
	["12975"] = true,
	["13750"] = true,
	["16191"] = true,
	["23920"] = true,
}

local defaultSpells = defaultSpellsRetail

--[===[@non-version-retail@
defaultSpellsRetail = nil

--@version-classic@
defaultSpells = defaultSpellsClassic
spellListWrath = nil
--@end-version-classic@

--@version-wrath@
defaultSpells = defaultSpellsWrath
spellListClassic = nil
--@end-version-wrath@

--@end-non-version-retail@]===]

addon.DATABASE_VERSION = 5

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
			minimap = {hide = VRA.IsRetail() or nil}
		},
		sound = {
			throttle = 0,
			channel = "Master"
		},
	}
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
	},
	["scenario"] = {
		name = SCENARIOS,
		order = 6
	}
}

addon.CATEGORY = {
	-- 1 -> 8 are used by Open Raid Lib
	[1] = L["Offensive"],
	[2] = L["Defensive-Personal"],
	[3] = L["Defensive-Target"],
	[4] = L["Defensive-Raid"],
	[5] = L["Utility"],
	[6] = L["Interrupt"],
	-- [7] is not used
	[8] = L["CC"],
	[99] = L["Covenant"]


	-- ["pvptrinket"] = L["PvP Trinket"],
	-- ["racial"] = L["Racial Traits"],
	-- ["trinket-defensive"] = L["Defensive"] .. " " .. INVTYPE_TRINKET,
	-- ["trinket-offensive"] = L["Offensive"] .. " " .. INVTYPE_TRINKET,
	-- ["covenant"] = L["Covenant"],
	-- ["interrupt"] = LOC_TYPE_INTERRUPT,
	-- ["dispel"] = DISPELS,
	-- ["cc"] = L["Crowd Control"],
	-- ["disarm"] = format("%s, %s, %s", LOC_TYPE_DISARM, LOC_TYPE_ROOT, LOC_TYPE_SILENCE),
	-- ["immunity"] = L["Immunity"],
	-- ["externalDefensive"] = L["External Defensive"],
	-- ["defensive"] = L["Defensive"],
	-- ["raidDefensive"] = L["Raid Defensive"],

	-- ["counterCC"] = L["Counter CC"],
	-- ["raidMovement"] = L["Raid Movement"],
	-- ["other"] = OTHER
}

addon.ICONCONFIG = {
	type = "launcher",
	icon = "Interface\\AddOns\\VocalRaidAssistant\\Media\\icon",
	--iconCoords = { -0.45, 1, -0.05, 1 },
	OnClick = function(clickedframe, button)
		addon:ChatCommand()
	end,
	OnTooltipShow = function(tooltip)
		tooltip:SetText(L["VRANAME"])
		tooltip:Show()
	end
}

addon.MSG_DELAY_SECONDS = 3
