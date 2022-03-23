local addonName, addon = ...
local L = VRA.L
local WagoAnalytics = VRA.WAGO

local tostring = tostring
local profile = {}
local popUpSemaphore = false

local function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

StaticPopupDialogs["VRA_IMPORT"] = {
	text = L["Insert import string"],
	button1 = L["Import"],
	button2 = L["Cancel"],
	timeout = 0,
	OnAccept = function(self, data, data2)
		importSpellSelection(self.editBox:GetText(), data)
		popUpSemaphore = false
		WagoAnalytics:IncrementCounter("Import String")
	end,
	OnCancel = function(self, data, data2)
		popUpSemaphore = false
	end,
	hasEditBox = true,
	whileDead = true,
	preferredIndex = 3 -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

StaticPopupDialogs["VRA_EXPORT"] = {
	text = L["Export string (Ctrl-C)"],
	button1 = L["Close"],
	timeout = 0,
	OnAccept = function(self, data, data2)
		popUpSemaphore = false
		WagoAnalytics:IncrementCounter("Export String")
	end,
	hasEditBox = true,
	whileDead = true,
	preferredIndex = 3 -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

local borderlessCoords = {0.07, 0.93, 0.07, 0.93}
local function spellOption(spellID)
	local spellname, _, icon = GetSpellInfo(spellID)
	local description = GetSpellDescription(spellID)
	if (spellname ~= nil) then
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

local function createOptionsForClass(class)
	local spellList = addon:GetSpellIdsByClass(class)
	local args = {}
	if (spellList ~= nil) then
		for spellID, v in pairs(spellList) do
			args[v.type] = args[v.type] or {
				name = addon.CATEGORY[v.type],
				type = 'group',
				order = indexOf(addon.PRIORITY,v.type),
				inline = true,
				args = {}
			}
			args[v.type].args[tostring(spellID)] = spellOption(spellID)
		end
	end
	return args
end

local function setFilterValue(info, val)
	local filter = addon.FILTER_VALUES[info]
	if (filter ~= nil) then
		if (val) then
			profile.general.watchFor = bit.bor(profile.general.watchFor, filter)
		else
			profile.general.watchFor = bit.band(profile.general.watchFor, bit.bnot(filter))
		end
	end
end

local function getFilterValue(info)
	local filter = addon.FILTER_VALUES[info]
	if (filter ~= nil) then
		return (bit.band(profile.general.watchFor, filter) == filter)
	end
end

local function getSpellOption(info)
	return profile.general.area[info[2]].spells[info[#info]]
end

local function setSpellOption(info, val)
	profile.general.area[info[2]].spells[info[#info]] = val
	if (val == true) then
		addon:playSpell(info[#info])
	end
end

local function restoreDefaultSpells(area)
	profile.general.area[area].spells = {}
	for k, v in pairs(addon.DEFAULT_SPELLS) do
		profile.general.area[area].spells[k] = v
	end
	profile.general.area[area].enableInterrupts = true
end

local function clearAll(area)
	restoreDefaultSpells(area)
	for k, _ in pairs(profile.general.area[area].spells) do
		profile.general.area[area].spells[k] = false
	end
	profile.general.area[area].enableInterrupts = false
end

function importSpellSelection(importString, area)
	local success, importDeserialized = addon.EXP:Deserialize(importString)
	if (success) then
		for k, v in pairs(importDeserialized) do
			profile.general.area[area].spells[k] = v
		end
		addon.ACR:NotifyChange("VocalRaidAssistantConfig")
	else
		print("Vocal Raid Assistant: Invalid import string.")
	end
end

local mainOptions = {
	name = "Vocal Raid Assistant",
	type = "group",
	args = {
		generalOptions = {
			name = L["General"],
			type = "group",
			order = 1,
			args = {
				title = {
					name = "|cffffd200" .. "Vocal Raid Assistant",
					order = 1,
					type = "description",
					fontSize = "large"
				},
				about = {
					order = 2,
					type = "description",
					name = L["Credits"]
				},
				version = {
					order = 3,
					type = "description",
					name = "Version: " .. addon.version
				},
				discord = {
					order = 4,
					type = "input",
					name = L["Discord"],
					get = function()
						return "https://discord.gg/UZMzqap"
					end
				},
				linebreak1 = {
					order = 5,
					type = 'description',
					name = ''
				},
				minimapIcon = {
					order = 6,
					type = "toggle",
					name = L["Minimap Icon"],
					get = function()
						return not profile.general.minimap.hide
					end,
					set = function(info, val)
						profile.general.minimap.hide = not val
						if profile.general.minimap.hide then
							VRA.ICON:Hide(addonName)
						else
							VRA.ICON:Show(addonName)
						end
					end

				},
				linebreak2 = {
					order = 7,
					type = 'description',
					name = '\n\n'
				},
				watchFor = {
					type = 'group',
					inline = true,
					name = L["Alert for"],
					desc = L["VRA should alert you for"],
					get = function(info)
						return getFilterValue(info[#info])
					end,
					set = function(info, val)
						setFilterValue(info[#info], val)
					end,
					order = 8,
					args = {
						player = {
							type = 'toggle',
							name = L["My own abilities"],
							order = 1
						},
						grouporraid = {
							type = 'toggle',
							name = L["Party member abilities"],
							order = 2
						},
						onlyself = {
							type = 'toggle',
							name = L["OnlySelfExternalsName"],
							desc = L["OnlySelfExternalsDesc"],
							get = function(info)
								return profile.general.onlySelf
							end,
							set = function(info, val)
								profile.general.onlySelf = val
							end,
							order = 3
						}
					}
				},
				voice = {
					type = 'group',
					inline = true,
					name = L["Voice"],
					get = function(info)
						return profile.sound[info[#info]]
					end,
					set = function(info, val)
						profile.sound[info[#info]] = val
					end,
					order = 9,
					args = {
						soundpack = {
							type = 'select',
							name = L["Soundpack"],
							values = addon.SOUND_PACKS,
							order = 1
						},
						playButton = {
							type = 'execute',
							name = L["Test"],
							func = function()
								addon:playSpell("98008")
							end,
							order = 2
						},
						throttle = {
							type = 'range',
							max = 60,
							min = 0,
							step = 0.5,
							name = L["Throttle"],
							desc = L["The minimum interval between two alerts in seconds"],
							order = 3
						},
						void = { -- To ensure channel, volume and enabled is on a new line.
							type = 'description',
							name = "",
							desc = "",
							order = 4
						},
						channel = {
							type = 'select',
							name = L["Output channel"],
							desc = L["Output channel desc"],
							values = addon.SOUND_CHANNEL,
							order = 5
						},
						volume = {
							type = 'range',
							max = 1,
							min = 0,
							step = 0.1,
							name = L["Volume"],
							desc = L["Adjusting the voice volume"],
							set = function(info, value)
								SetCVar("Sound_" .. profile.sound.channel .. "Volume", tostring(value))
							end,
							get = function()
								return tonumber(GetCVar("Sound_" .. profile.sound.channel .. "Volume"))
							end,
							order = 6
						},
						channelEnabled = {
							type = 'toggle',
							name = function()
								return profile.sound.channel .. " channel"
							end,
							width = "double",
							desc = L["Enables or disables channel"],
							set = function(info, value)
								if (profile.sound.channel == "Master") then
									SetCVar("Sound_EnableAllSound", (value and 1 or 0))
								else
									SetCVar("Sound_Enable" .. profile.sound.channel, (value and 1 or 0))
								end
							end,
							get = function()
								if (profile.sound.channel == "Master") then
									return tonumber(GetCVar("Sound_EnableAllSound")) == 1 and true or false
								else
									return tonumber(GetCVar("Sound_Enable" .. profile.sound.channel)) == 1 and true or false
								end
							end,
							order = 7
						}
					}
				}
			}
		},
		abilitiesOptions = {
			name = L["Abilities"],
			type = "group",
			order = 2,
			childGroups = "tab",
			args = {}
		}
	}
}

local spells = {
	name = L["Abilities"],
	type = "group",
	disabled = function(info)
		return not profile.general.area[info[2]].enabled
	end,
	args = {
		selectedArea = {
			name = L["Copy Settings From:"],
			desc = L["Select the area you want to copy settings from"],
			order = 1,
			type = "select",
			values = function(info)
				local t = {
					[''] = ""
				}
				for k, v in pairs(addon.ZONES) do
					if k ~= info[2] then
						t[k] = v.name
					end
				end
				return t
			end,
			get = function(info)
				return profile.general.area[info[2]].copyZone
			end,
			set = function(info, val)
				profile.general.area[info[2]].copyZone = val
			end
		},
		copySelected = {
			name = L["Copy"],
			desc = L["Copy the selected area settings to this area"],
			order = 2,
			type = "execute",
			disabled = function(info)
				return not profile.general.area[info[2]].copyZone or profile.general.area[info[2]].copyZone == ''
			end,
			func = function(info)
				local t = {}
				local source = profile.general.area[info[2]].copyZone
				local sourceTable = profile.general.area[source]
				for k, v in pairs(sourceTable) do
					t[k] = v
				end
				profile.general.area[info[2]] = t
				profile.general.area[info[2]].copyZone = nil
				WagoAnalytics:IncrementCounter("Copy Settings")
			end,
			confirm = function(info)
				return L["Copy Settings: "] .. addon.ZONES[profile.general.area[info[2]].copyZone].name .. " -> " ..
										addon.ZONES[info[2]].name
			end
		},
		clearAll = {
			name = L["Clear All"],
			order = 3,
			type = "execute",
			func = function(info)
				clearAll(info[2])
			end,
			confirm = true
		},
		restoreDefault = {
			name = L["Restore Defaults"],
			order = 4,
			type = "execute",
			func = function(info)
				restoreDefaultSpells(info[2])
			end,
			confirm = true
		},
		importSelectedSpells = {
			name = L["Import Area"],
			order = 5,
			type = "execute",
			func = function(info)
				if (not popUpSemaphore) then
					popUpSemaphore = true
					local dialog = StaticPopup_Show("VRA_IMPORT")
					if (dialog) then
						dialog.data = info[2]
					else
						print("Import failed, please join the Discord and make us aware this failed")
					end
				end
			end
		},
		exportSelectedSpells = {
			name = L["Export Area"],
			order = 6,
			type = "execute",
			func = function(info)
				if (not popUpSemaphore) then
					popUpSemaphore = true
					local dialog = StaticPopup_Show("VRA_EXPORT")
					if (dialog) then
						local exportString = VRA.EXP:Serialize(profile.general.area[info[2]].spells)
						dialog.editBox:SetText(exportString)
						dialog.editBox:HighlightText()
					else
						print("Export failed, please join the Discord and make us aware this failed")
					end
				end
			end
		},
		interrupts = {
			type = "group",
			name = L["Interrupts"],
			inline = true,
			order = 7,
			args = {
				toggleInterrupts = {
					type = "toggle",
					name = L["Enable"],
					desc = L["Play sound on interrupts"],
					width = 1.05,
					get = function(info)
						return profile.general.area[info[2]].enableInterrupts
					end,
					set = function(info, val)
						profile.general.area[info[2]].enableInterrupts = val
					end
				}
			}
		}
	}
}

for i = 1, MAX_CLASSES do
	local class = CLASS_SORT_ORDER[i]
	local name = LOCALIZED_CLASS_NAMES_MALE[class]
	spells.args[class] = {
		icon = "Interface\\Icons\\ClassIcon_" .. class,
		iconCoords = borderlessCoords,
		name = name,
		type = "group",
		get = function(info)
			return getSpellOption(info)
		end,
		set = function(info, val)
			setSpellOption(info, val)
		end,
		args = createOptionsForClass(class)
	}
end

local additionalSpellCategories = {
	["TRINKET"] = "Trinket",
	["GENERAL"] = "General"
}

for k, v in pairs(additionalSpellCategories) do
	local i = 1
	spells.args[k] = {
		name = L[v],
		order = i,
		type = "group",
		get = function(info)
			return getSpellOption(info)
		end,
		set = function(info, val)
			setSpellOption(info, val)
		end,
		args = createOptionsForClass(k)
	}
	i = i + 1
end

for k, v in pairs(addon.ZONES) do
	mainOptions.args.abilitiesOptions.args[k] = {
		name = v.name,
		type = "group",
		childGroups = "tab",
		order = v.order,
		args = {
			enable = {
				type = "toggle",
				name = L["Enable"],
				order = 1,
				get = function(info)
					return profile.general.area[info[2]].enabled
				end,
				set = function(info, val)
					profile.general.area[info[2]].enabled = val
				end
			},
			spells = spells
		}
	}
end

function addon:RefreshOptions(database)
	profile = database.profile
end

function addon:InitConfigOptions()
	profile = addon.db.profile
	mainOptions.args.profiles = self.ACDBO:GetOptionsTable(self.db)
	addon.LDS:EnhanceOptions(mainOptions.args.profiles, self.db)
	addon.AC:RegisterOptionsTable("VocalRaidAssistantConfig", mainOptions)
	addon.ACD:SetDefaultSize("VocalRaidAssistantConfig", 965, 650)
end

