local _, addon = ...
local L = addon.L

addon.DATABASE_VERSION = 8

addon.DEFAULTS = {
	profile = {
		general = {
			minimap = { hide = false }
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
