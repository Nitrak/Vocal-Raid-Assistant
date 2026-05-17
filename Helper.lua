local _, addon = ...
local L = addon.L

function addon:prettyPrint(msg, msgType)
    local colors = {
        reset   = "|r",          -- reset color
        success = "|cff00ff00",  -- green
        info    = "|cffffffff",  -- white
        warn    = "|cffffff00",  -- yellow
        error   = "|cffff0000",  -- red
    }

    msgType = msgType or "error"
    local color = colors[msgType] or colors.info

    print(
        color .. "Vocal Raid Assistant:" .. colors.reset, tostring(msg)
    )
end

function addon:determinePlayerError(spellID, channel, isTest)
	local cvarName = "Sound_Enable" .. (channel == "Sound" and "SFX" or channel)

	if GetCVar("Sound_EnableAllSound") == "0" then
		if isTest then
			return "Cannot play sounds: Master channel is disabled."
		end
	elseif GetCVar(cvarName) == "0" then
		if isTest then
			return format("Cannot play sounds: VRA is set to use the \"%s\" channel, but it is disabled.", channel)
		end
	else
		return format("Missing sound file for spell %d (Voice Pack: %s).", spellID, addon.profile.sound.soundpack)
	end

	return ""
end
