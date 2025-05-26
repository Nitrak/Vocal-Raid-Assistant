-- Config/GeneralOptions.lua
local addonName, addon = ...
local L = addon.L

addon.ConfigGeneralOptions = {
	name = L["General"],
	type = "group",
	order = 1,
	args = {
		logo = {
			order = 1,
			type = "description",
			name = " ",
			image = "Interface\\AddOns\\VocalRaidAssistant\\Media\\logo",
			imageWidth = 384,
			imageHeight = 192,
			width = 1.5
		},
		about = {
			order = 1.2,
			type = "description",
			name = function() return "\n\n\n\n\n" .. L["Credits"] .. "\n" .. L["Version: "] .. addon.version end,
			width = 1.5
		},
		linebreak1 = {
			order = 2,
			type = 'description',
			name = '\n',
		},
		discord = {
			order = 3,
			type = "input",
			name = L["Discord"],
			get = function() return "https://discord.gg/UZMzqap" end
		},
		linebreak2 = {
			order = 4,
			type = 'description',
			name = '\n\n'
		},
		minimapIcon = {
			order = 5,
			type = "toggle",
			name = L["Minimap Icon"],
			get = function() return not addon.profile.general.minimap.hide end,
			set = function(_, val)
				addon.profile.general.minimap.hide = not val
				if addon.profile.general.minimap.hide then
					VRA.ICON:Hide(addonName)
				else
					VRA.ICON:Show(addonName)
				end
			end
		},
		watchFor = {
			type = 'group',
			inline = true,
			name = L["Alert for"],
			desc = L["VRA should alert you for"],
			get = function(info) return addon:getFilterValue(info[#info]) end,
			set = function(info, val) addon:setFilterValue(info[#info], val) end,
			order = 6,
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
				}
			}
		},
		voice = addon.ConfigVoiceOptions,
		soundPacksConfig = addon.ConfigSoundPackOptions
	}
}
