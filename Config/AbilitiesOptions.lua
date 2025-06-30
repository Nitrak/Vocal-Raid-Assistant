-- Config/AbilitiesOptions.lua
local addonName, addon = ...
local L = addon.L

local borderlessCoords = { 0.07, 0.93, 0.07, 0.93 }

local function indexOf(array, value)
	for i, v in ipairs(array) do
		if v == value then return i end
	end
	return nil
end

local function spellOption(spellID)
	local spellname, icon, description

	if addon:IsTWW() then
		spellname = C_Spell.GetSpellName(spellID)
		icon = C_Spell.GetSpellTexture(spellID)
		description = C_Spell.GetSpellDescription(spellID)
	else
		spellname, _, icon = GetSpellInfo(spellID)
		description = GetSpellDescription(spellID)
	end

	icon = addon.spellIconCorrections[icon] or icon
	spellname = addon.spellNameCorrections[spellID] and L[spellID] or spellname

	if spellname then
		return {
			type = 'toggle',
			image = icon,
			imageCoords = borderlessCoords,
			name = spellname,
			desc = description
		}
	else
		return {
			type = 'toggle',
			name = L["unknown spell, id:"] .. spellID
		}
	end
end

local function createOptionsForCategory(category)
	local args = {}
	if category == "All Active" then
		local spellList = addon:GetFullSpellListNoCategories()
		if spellList then
			for _, x in pairs(spellList) do
				for spellID, v in pairs(x) do
					local cat = addon.CATEGORY[v]
					args[cat] = args[cat] or {
						name = cat,
						type = 'group',
						order = indexOf(addon.CATEGORY, v),
						inline = true,
						args = {}
					}
					args[cat].args[tostring(spellID)] = spellOption(spellID)
				end
			end
		end
	else
		local spellEntries = addon:GetSpellEntries(category)
		if spellEntries then
			for spellID, v in pairs(spellEntries) do
				local cat = addon.CATEGORY[v.type]
				args[cat] = args[cat] or {
					name = cat,
					type = 'group',
					order = indexOf(addon.CATEGORY, v),
					inline = true,
					args = {}
				}
				args[cat].args[tostring(spellID)] = spellOption(spellID)
			end
		end
	end
	return args
end

function addon:createSpellCategory(category, name, icon, order)
	return {
		icon = icon or nil,
		iconCoords = icon and borderlessCoords or nil,
		name = name,
		order = order or nil,
		type = "group",
		get = function(info) return addon:getSpellOption(info) end,
		set = function(info, val) addon:setSpellOption(info, val) end,
		hidden = function(info)
			return category == "All Active" and tonumber(info[#info]) ~= nil and not addon:getSpellOption(info)
		end,
		args = createOptionsForCategory(category)
	}
end
function addon:restoreDefaultSpells(area)
	addon.profile.general.area[area].spells = {}
	for k, v in pairs(addon.DEFAULT_SPELLS) do
		addon.profile.general.area[area].spells[k] = v
	end
	addon.profile.general.area[area].enableInterrupts = true
end

function addon:clearAll(area)
	addon:restoreDefaultSpells(area)
	for k, _ in pairs(addon.profile.general.area[area].spells) do
		addon.profile.general.area[area].spells[k] = false
	end
	addon.profile.general.area[area].enableInterrupts = false
end

function addon:importSpellSelection(importString, area)
	local success, importDeserialized = addon.EXP:Deserialize(importString)
	if success then
		for k, v in pairs(importDeserialized) do
			addon.profile.general.area[area].spells[k] = v
		end
		addon.ACR:NotifyChange("VocalRaidAssistantConfig")
	else
		addon:prettyPrint("Vocal Raid Assistant: Invalid import string.")
	end
end

addon.ConfigAbilitiesOptions = {
	name = L["Abilities"],
	type = "group",
	order = 2,
	childGroups = "tab",
	args = {}
}

local spells = {
	name = L["Abilities"],
	type = "group",
	disabled = function(info)
		return not addon.profile.general.area[info[2]].enabled
	end,
	args = {
		selectedArea = {
			name = L["Copy Settings From:"],
			desc = L["Select the area you want to copy settings from"],
			order = 1,
			type = "select",
			values = function(info)
				local t = { [''] = "" }
				for k, v in pairs(addon.ZONES) do
					if k ~= info[2] then
						t[k] = v.name
					end
				end
				return t
			end,
			get = function(info)
				return addon.profile.general.area[info[2]].copyZone
			end,
			set = function(info, val)
				addon.profile.general.area[info[2]].copyZone = val
			end
		},
		copySelected = {
			name = L["Copy"],
			desc = L["Copy the selected area settings to this area"],
			order = 2,
			type = "execute",
			disabled = function(info)
				return not addon.profile.general.area[info[2]].copyZone or addon.profile.general.area[info[2]].copyZone == ''
			end,
			func = function(info)
				local t, source = {}, addon.profile.general.area[info[2]].copyZone
				for k, v in pairs(addon.profile.general.area[source]) do
					t[k] = v
				end
				addon.profile.general.area[info[2]] = t
				addon.profile.general.area[info[2]].copyZone = nil
			end,
			confirm = function(info)
				return L["Copy Settings: "] .. addon.ZONES[addon.profile.general.area[info[2]].copyZone].name .. " -> " .. addon.ZONES[info[2]].name
			end
		},
		clearAll = {
			name = L["Clear All"],
			order = 3,
			type = "execute",
			func = function(info)
				addon:clearAll(info[2])
			end,
			confirm = true
		},
		restoreDefault = {
			name = L["Restore Defaults"],
			order = 4,
			type = "execute",
			func = function(info)
				addon:restoreDefaultSpells(info[2])
			end,
			confirm = true
		},
		importSelectedSpells = {
			name = L["Import Area"],
			order = 5,
			type = "execute",
			func = function(info)
				if not addon.popUpSemaphore then
					addon.popUpSemaphore = true
					local dialog = StaticPopup_Show("VRA_IMPORT")
					if dialog then
						dialog.data = info[2]
					else
						addon:prettyPrint("Import failed, please join the Discord and make us aware this failed")
					end
				end
			end
		},
		exportSelectedSpells = {
			name = L["Export Area"],
			order = 6,
			type = "execute",
			func = function(info)
				if not addon.popUpSemaphore then
					addon.popUpSemaphore = true
					local dialog = StaticPopup_Show("VRA_EXPORT")
					if dialog then
						dialog.editBox:SetText(VRA.EXP:Serialize(addon.profile.general.area[info[2]].spells))
						dialog.editBox:HighlightText()
					else
						addon:prettyPrint("Export failed, please join the Discord and make us aware this failed")
					end
				end
			end
		},
		specials = {
			type = "group",
			name = L["Specials"],
			inline = true,
			order = 7,
			args = {
				toggleInterrupts = {
					type = "toggle",
					name = L["Interrupts"],
					desc = L["Play sound on interrupts"],
					--width = 1.05,
					order = 1,
					get = function(info) return addon.profile.general.area[info[2]].enableInterrupts end,
					set = function(info, val)
						addon.profile.general.area[info[2]].enableInterrupts = val
						if val then addon:playSpell("countered") end
					end
				},
				toggleTaunts = {
					type = "toggle",
					name = L["Taunts"],
					desc = L["Play sound on taunts"],
					--width = 1.05,
					order = 2,
					get = function(info) return addon.profile.general.area[info[2]].enableTaunts end,
					set = function(info, val)
						addon.profile.general.area[info[2]].enableTaunts = val
						if val then addon:playSpell("taunted") end
					end
				},
				toggleCheatDeath = {
					type = "toggle",
					name = L["Cheat Death"],
					desc = L["Play sound on Cheat Death abilities"],
					--width = 1.05,
					order = 3,
					get = function(info) return addon.profile.general.area[info[2]].enableCheatDeaths end,
					set = function(info, val) addon.profile.general.area[info[2]].enableCheatDeaths = val end
				},
				toggleBattleres = {
					type = "toggle",
					name = L["Battleres"],
					desc = L["Play sound on combat resurrections"],
					order = 4,
					get = function(info) return addon.profile.general.area[info[2]].enableBattleres end,
					set = function(info, val) addon.profile.general.area[info[2]].enableBattleres = val
						if val then addon:playSpell("battleres") end
					end
				},
				toggleCombatOnly = {
					type = "toggle",
					name = L["Combat only"],
					desc = L["Combat only description"],
					--width = 1.05,
					order = 5,
					get = function(info) return addon.profile.general.area[info[2]].combatOnly end,
					set = function(info, val) addon.profile.general.area[info[2]].combatOnly = val end
				},
				onlyself = {
					type = 'toggle',
					name = L["OnlySelfExternalsName"],
					desc = L["OnlySelfExternalsDesc"],
					order = 6,
					get = function(info) return addon.profile.general.area[info[2]].onlySelf end,
					set = function(info, val) addon.profile.general.area[info[2]].onlySelf = val end
				}
			}
		}
	}
}

-- Add spell categories to spell UI
spells.args["GENERAL"] = addon:createSpellCategory("GENERAL", L["General Spells"], nil, 0)

for i = 1, MAX_CLASSES do
	local class = CLASS_SORT_ORDER[i]
	local name = LOCALIZED_CLASS_NAMES_MALE[class]
	local icon = class == "DEATHKNIGHT" and "Interface\\Icons\\spell_deathknight_classicon.png" or "Interface\\Icons\\ClassIcon_" .. class
	spells.args[class] = addon:createSpellCategory(class, name, icon, i)
end

spells.args["TRINKET"] = addon:createSpellCategory("TRINKET", INVTYPE_TRINKET, nil, MAX_CLASSES + 1)
spells.args["All Active"] = addon:createSpellCategory("All Active", L["All Active"], nil, MAX_CLASSES + 2)

-- Add zones to abilities UI
for k, v in pairs(addon.ZONES) do
	addon.ConfigAbilitiesOptions.args[k] = {
		name = v.name,
		type = "group",
		childGroups = "tab",
		order = v.order,
		args = {
			enable = {
				type = "toggle",
				name = L["Enable"],
				order = 1,
				get = function(info) return addon.profile.general.area[info[2]].enabled end,
				set = function(info, val) addon.profile.general.area[info[2]].enabled = val end
			},
			spells = spells
		}
	}
end
