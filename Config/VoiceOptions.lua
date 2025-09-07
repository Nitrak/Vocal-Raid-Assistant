-- Config/VoiceOptions.lua
local addonName, addon = ...
local L = addon.L

addon.ConfigVoiceOptions = {
	type = 'group',
	inline = true,
	name = L["Voice"],
	get = function(info)
		return addon.profile.sound[info[#info]]
	end,
	set = function(info, val)
		addon.profile.sound[info[#info]] = val
	end,
	order = 7,
	args = {
		soundpack = {
			type = 'select',
			width = 1.3,
			name = L["Sound pack"],
			values = function()
				return VRA:GetRegisteredSoundpacks()
			end,
			order = 1
		},
		playButton = {
			type = 'execute',
			name = L["Test"],
			func = function()
				addon:playSpell("740", true)
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
		void = {
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
				local cvar = addon.profile.sound.channel == "Master" and "Sound_EnableAllSound" or "Sound_Enable" .. addon.profile.sound.channel
				SetCVar(cvar, value and 1 or 0)
			end,
			get = function()
				local cvar = addon.profile.sound.channel == "Master" and "Sound_EnableAllSound" or "Sound_Enable" .. addon.profile.sound.channel
				return tonumber(GetCVar(cvar)) == 1
			end,
			order = 7
		}
	}
}

addon.ConfigSoundPackOptions = {
	type = 'group',
	inline = true,
	name = L["Officially supported sound packs not yet installed/active"],
	order = 8,
	width = "half",
	args = {}
}

local officialSoundPacks = {
	["Ana"] = {
		displayName = "Vocal Raid Assistant - Ana",
		name = "VRA_EN_Ana",
		demoFileName = "Ana",
		link = "https://www.curseforge.com/wow/addons/vocal-raid-assistant-ana-sound-pack"
	},
	["Elizabeth"] = {
		displayName = "Vocal Raid Assistant - Elizabeth",
		name = "VRA_EN_Elizabeth",
		demoFileName = "Elizabeth",
		link = "https://www.curseforge.com/wow/addons/vocal-raid-assistant-elizabeth-sound-pack"
	},
	["Eric"] = {
		displayName = "Vocal Raid Assistant - Eric",
		name = "VRA_EN_Eric",
		demoFileName = "Eric",
		link = "https://www.curseforge.com/wow/addons/vocal-raid-assistant-eric-sound-pack"
	},
	["Guy"] = {
		displayName = "Vocal Raid Assistant - Guy",
		name = "VRA_EN_Guy",
		demoFileName = "Guy",
		link = "https://www.curseforge.com/wow/addons/vocal-raid-assistant-sara-sound-pack"
	},
	["Sara"] = {
		displayName = "Vocal Raid Assistant - Sara",
		name = "VRA_EN_Sara",
		demoFileName = "Sara",
		link = "https://www.curseforge.com/wow/addons/vocal-raid-assistant-sara-sound-pack"
	}
}

local order = 1
for key, pack in pairs(officialSoundPacks) do
	local isHidden = select(4, C_AddOns and C_AddOns.GetAddOnInfo(pack.name) or GetAddOnInfo(pack.name))

	addon.ConfigSoundPackOptions.args[key .. "_link"] = {
		type = "input",
		name = pack.displayName,
		get = function() return pack.link end,
		hidden = isHidden,
		width = 1.5,
		order = order
	}

	addon.ConfigSoundPackOptions.args[key .. "_demo"] = {
		type = 'execute',
		name = L["Demo"],
		func = function()
			if not PlaySoundFile(format("Interface\\AddOns\\VocalRaidAssistant\\Media\\%s.ogg", pack.demoFileName), addon.profile.sound.channel) then
				addon:prettyPrint(addon:determinePlayerError("", addon.profile.sound.channel, true))
			end
		end,
		width = "half",
		hidden = isHidden,
		order = order + 1
	}

	addon.ConfigSoundPackOptions.args[key .. "_break"] = {
		type = 'description',
		name = '',
		hidden = isHidden,
		order = order + 2
	}

	order = order + 3
end

addon.ConfigSoundPackOptions.args["addition"] = {
	type = "description",
	name = L["Additional Voicepacks"],
	order = order
}
