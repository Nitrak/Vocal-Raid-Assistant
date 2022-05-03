local addonName, addon = ...
local L = VRA.L
local WagoAnalytics = VRA.WAGO

local tostring = tostring
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

local function createOptionsForCategory(category)
	local args = {}
	if category == "All Active" then
		local spellList = addon:GetFullSpellListNoCategories()
		if (spellList ~= nil) then
			for category, x in pairs(spellList) do
				for spellID, v in pairs(x) do
					args[v] = args[v] or {
						name = addon.CATEGORY[v],
						type = 'group',
						order = indexOf(addon.CATEGORY_SORT_ORDER,v),
						inline = true,
						args = {}
					}
					args[v].args[tostring(spellID)] = spellOption(spellID)
				end
			end
		end
	else
		local spellEntries = addon:GetSpellEntries(category)
		if (spellEntries ~= nil) then
			for spellID, v in pairs(spellEntries) do
				args[v.type] = args[v.type] or {
					name = addon.CATEGORY[v.type],
					type = 'group',
					order = indexOf(addon.CATEGORY_SORT_ORDER,v.type),
					inline = true,
					args = {}
				}
				args[v.type].args[tostring(spellID)] = spellOption(spellID)
			end
		end
	end
	return args
end

local function setFilterValue(info, val)
	local filter = addon.FILTER_VALUES[info]
	if (filter ~= nil) then
		if (val) then
			addon.profile.general.watchFor = bit.bor(addon.profile.general.watchFor, filter)
		else
			addon.profile.general.watchFor = bit.band(addon.profile.general.watchFor, bit.bnot(filter))
		end
	end
end

local function getFilterValue(info)
	local filter = addon.FILTER_VALUES[info]
	if (filter ~= nil) then
		return (bit.band(addon.profile.general.watchFor, filter) == filter)
	end
end

local function getSpellOption(info)
	return addon.profile.general.area[info[2]].spells[info[#info]]
end

local function setSpellOption(info, val)
	addon.profile.general.area[info[2]].spells[info[#info]] = val
	if (val == true) then
		addon:playSpell(info[#info], true)
	end
end

local function restoreDefaultSpells(area)
	addon.profile.general.area[area].spells = {}
	for k, v in pairs(addon.DEFAULT_SPELLS) do
		addon.profile.general.area[area].spells[k] = v
	end
	addon.profile.general.area[area].enableInterrupts = true
end

local function clearAll(area)
	restoreDefaultSpells(area)
	for k, _ in pairs(addon.profile.general.area[area].spells) do
		addon.profile.general.area[area].spells[k] = false
	end
	addon.profile.general.area[area].enableInterrupts = false
end

local function createSpellCategory(category, name, icon, order)
	return {
		icon = nil or icon,
		iconCoords = (icon ~= nil) and borderlessCoords or nil,
		name = name,
		order = nil or order,
		type = "group",
		get = function(info)
			return getSpellOption(info)
		end,
		set = function(info, val)
			setSpellOption(info, val)
		end,
		hidden = function(info)
			return category == "All Active" and tonumber(info[#info]) ~= nil and not getSpellOption(info)
		end,
		args = createOptionsForCategory(category)
	}
end

function importSpellSelection(importString, area)
	local success, importDeserialized = addon.EXP:Deserialize(importString)
	if (success) then
		for k, v in pairs(importDeserialized) do
			addon.profile.general.area[area].spells[k] = v
		end
		addon.ACR:NotifyChange("VocalRaidAssistantConfig")
	else
		addon:prettyPrint("Vocal Raid Assistant: Invalid import string.")
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
					type = 'description',
					name = '',
					order = 5
				},
				minimapIcon = {
					order = 6,
					type = "toggle",
					name = L["Minimap Icon"],
					get = function()
						return not addon.profile.general.minimap.hide
					end,
					set = function(info, val)
						addon.profile.general.minimap.hide = not val
						if addon.profile.general.minimap.hide then
							VRA.ICON:Hide(addonName)
						else
							VRA.ICON:Show(addonName)
						end
					end

				},
				linebreak2 = {
					type = 'description',
					name = '\n\n',
					order = 7
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
								return addon.profile.general.onlySelf
							end,
							set = function(info, val)
								addon.profile.general.onlySelf = val
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
						return addon.profile.sound[info[#info]]
					end,
					set = function(info, val)
						addon.profile.sound[info[#info]] = val
					end,
					order = 9,
					args = {
						soundpack = {
							type = 'select',
							width = 1.3,
							name = L["Sound pack"],
							values = function() return VRA:GetRegisteredSoundpacks() end,
							width = "normal",
							order = 1
						},
						playButton = {
							type = 'execute',
							name = L["Test"],
							func = function()
								addon:playSpell("740",true)
							end,
							width = "half",
							order = 2
						},
						throttle = {
							type = 'range',
							max = 2,
							min = 0,
							step = 0.1,
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
								SetCVar("Sound_" .. addon.profile.sound.channel .. "Volume", tostring(value))
							end,
							get = function()
								return tonumber(GetCVar("Sound_" .. addon.profile.sound.channel .. "Volume"))
							end,
							order = 6
						},
						channelEnabled = {
							type = 'toggle',
							name = function()
								return addon.profile.sound.channel .. " channel"
							end,
							width = "double",
							desc = L["Enables or disables channel"],
							set = function(info, value)
								if (addon.profile.sound.channel == "Master") then
									SetCVar("Sound_EnableAllSound", (value and 1 or 0))
								else
									SetCVar("Sound_Enable" .. addon.profile.sound.channel, (value and 1 or 0))
								end
							end,
							get = function()
								if (addon.profile.sound.channel == "Master") then
									return tonumber(GetCVar("Sound_EnableAllSound")) == 1 and true or false
								else
									return tonumber(GetCVar("Sound_Enable" .. addon.profile.sound.channel)) == 1 and true or false
								end
							end,
							order = 7
						},
					}
				},
				soundPacksConfig = {
					type = 'group',
					inline = true,
					name = "Officially supported sound packs not yet installed/active",
					order = 10,
					args = {
						VPAna = {
							type = "input",
							name = "Vocal Raid Assistant - Ana",
							get = function()
								return "https://www.curseforge.com/wow/addons/vocal-raid-assistant-ana-sound-pack"
							end,
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Ana")
							end,
							order = 1
						},
						playButtonAna = {
							type = 'execute',
							name = L["Demo"],
							func = function()
								addon:PlayTestSoundFile("Ana")
							end,
							width = "half",
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Ana")
							end,
							order = 2
						},
						linebreak3 = {
							type = 'description',
							name = '',
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Ana")
							end,
							order = 3
						},
						VPElizabeth = {
							type = "input",
							name = "Vocal Raid Assistant - Elizabeth",
							get = function()
								return "https://www.curseforge.com/wow/addons/vocal-raid-assistant-elizabeth-sound-pack"
							end,
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Elizabeth")
							end,
							order = 4
						},
						playButtonElizabeth= {
							type = 'execute',
							name = L["Demo"],
							func = function()
								addon:PlayTestSoundFile("Elizabeth")
							end,
							width = "half",
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Elizabeth")
							end,
							order = 5
						},
						linebreak4 = {
							type = 'description',
							name = '',
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Elizabeth")
							end,
							order = 6
						},
						VPEric = {
							type = "input",
							name = "Vocal Raid Assistant - Eric",
							get = function()
								return "https://www.curseforge.com/wow/addons/vocal-raid-assistant-eric-sound-pack"
							end,
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Eric")
							end,
							order = 7
						},
						playButtonEric= {
							type = 'execute',
							name = L["Demo"],
							func = function()
								addon:PlayTestSoundFile("Eric")
							end,
							width = "half",
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Eric")
							end,
							order = 8
						},
						linebreak5 = {
							type = 'description',
							name = '',
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Eric")
							end,
							order = 9
						},
						VPGuy = {
							type = "input",
							name = "Vocal Raid Assistant - Guy",
							get = function()
								return "https://www.curseforge.com/wow/addons/vocal-raid-assistant-guy-sound-pack"
							end,
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Guy")
							end,
							order = 10
						},
						playButtonGuy= {
							type = 'execute',
							name = L["Demo"],
							func = function()
								addon:PlayTestSoundFile("Guy")
							end,
							width = "half",
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Guy")
							end,
							order = 11
						},
						linebreak6 = {
							type = 'description',
							name = '',
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Guy")
							end,
							order = 12
						},
						VPSara = {
							type = "input",
							name = "Vocal Raid Assistant - Sara",
							get = function()
								return "https://www.curseforge.com/wow/addons/vocal-raid-assistant-sara-sound-pack"
							end,
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Sara")
							end,
							order = 13
						},
						playButtonSara= {
							type = 'execute',
							name = L["Demo"],
							func = function()
								addon:PlayTestSoundFile("Sara")
							end,
							width = "half",
							hidden = function()
								return addon:CheckSoundPackExist("VRA_EN_Sara")
							end,
							order = 14
						},
						additionalVoicePacks = {
							type = "description",
							name = "Additional sound packs may be available on your favorite addon client - Try searching for \"Vocal Raid Assistant\".\nMake sure at least one sound pack is enabled.",
							order = 15
						},
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
		return not addon.profile.general.area[info[2]].enabled
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
				local t = {}
				local source = addon.profile.general.area[info[2]].copyZone
				local sourceTable = addon.profile.general.area[source]
				for k, v in pairs(sourceTable) do
					t[k] = v
				end
				addon.profile.general.area[info[2]] = t
				addon.profile.general.area[info[2]].copyZone = nil
				WagoAnalytics:IncrementCounter("Copy Settings")
			end,
			confirm = function(info)
				return L["Copy Settings: "] .. addon.ZONES[addon.profile.general.area[info[2]].copyZone].name .. " -> " ..
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
				if (not popUpSemaphore) then
					popUpSemaphore = true
					local dialog = StaticPopup_Show("VRA_EXPORT")
					if (dialog) then
						local exportString = VRA.EXP:Serialize(addon.profile.general.area[info[2]].spells)
						dialog.editBox:SetText(exportString)
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
					width = 1.05,
					get = function(info)
						return addon.profile.general.area[info[2]].enableInterrupts
					end,
					set = function(info, val)
						addon.profile.general.area[info[2]].enableInterrupts = val
						if val then
							addon:playSpell("countered")
						end
					end
				},
				toggleTaunts = {
					type = "toggle",
					name = L["Taunts"],
					desc = L["Play sound on taunts"],
					width = 1.05,
					get = function(info)
						return addon.profile.general.area[info[2]].enableTaunts
					end,
					set = function(info, val)
						addon.profile.general.area[info[2]].enableTaunts = val
						if val then
							addon:playSpell("taunted")
						end
					end
				}
			}
		}
	}
}


local additionalSpellCategories = {
	["All Active"] = "All Active",
	["TRINKET"] = INVTYPE_TRINKET,
	["GENERAL"] = L["General Spells"],
}

for k, v in pairs(additionalSpellCategories) do
	spells.args[k] = createSpellCategory(k, v, nil, 0)
end

for i = 1, MAX_CLASSES do
	local class = CLASS_SORT_ORDER[i]
	local name = LOCALIZED_CLASS_NAMES_MALE[class]
	local icon = "Interface\\Icons\\ClassIcon_" .. class
	spells.args[class] = createSpellCategory(class, name, icon, i)
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
					return addon.profile.general.area[info[2]].enabled
				end,
				set = function(info, val)
					addon.profile.general.area[info[2]].enabled = val
				end
			},
			spells = spells
		}
	}
end

function addon:InitConfigOptions()
	mainOptions.args.profiles = self.ACDBO:GetOptionsTable(self.db)
	if(not self:IsClassic() and not self:IsBCC()) then
		addon.LDS:EnhanceOptions(mainOptions.args.profiles, self.db)
	end
	addon.AC:RegisterOptionsTable("VocalRaidAssistantConfig", mainOptions)
	addon.ACD:SetDefaultSize("VocalRaidAssistantConfig", 965, 650)
end

