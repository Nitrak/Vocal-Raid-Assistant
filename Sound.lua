local addonName, addon = ...

local registeredSoundpacks = {}
local GetTime = GetTime
local throttleTime = {
	['sound'] = GetTime(),
	['msg'] = GetTime()
}

function addon:RegisterSoundpack(name, player)
	if registeredSoundpacks[name] then
		error('Soundpack already exist!')
	elseif type(player) ~= "function" then
		error('Check soundpacks callback!')
	end
	registeredSoundpacks[name] = player
end

function addon:GetRegisteredSoundpacks()
	local t = {}
	for k,_ in pairs(registeredSoundpacks) do
		t[k] = k
	end
	return t
end

local function isThrottled(type)
	local now = GetTime()
	if now > throttleTime[type] then
		throttleTime[type] = now + ((type == 'sound') and addon.profile.sound.throttle or addon.MSG_DELAY_SECONDS)
		return false
	end
	return true
end

local function playSpell(spellID, isTest)
	local channel = addon.profile.sound.channel
	local player = registeredSoundpacks[addon.profile.sound.soundpack]
	local errorMsg = nil
	if player then
		if isThrottled('sound') then
			return
		end
		local success = player(spellID, channel)
		if not success then
			local cvarName ='Sound_Enable'..(channel == "Sound" and 'SFX' or channel)
			if GetCVar("Sound_EnableAllSound") == "0" then
				if isTest then
					errorMsg = format('Can not play sounds, your gamesound (Master channel) is disabled')
				end
			elseif GetCVar(cvarName) == "0" then
				if isTest then
					errorMsg = format("Can not play sounds, you configured VRA to play sounds via channel \"%s\", but %s channel is disabled.", channel, channel)
				end
			else
				errorMsg = format("Missing soundfile for configured spell: %s, Voice Pack: %s", GetSpellInfo(spellID) or spellID, addon.profile.sound.soundpack)
			end
		end
	else
		errorMsg = "Can not play sounds - No voicepack is installed or configured!"
	end
	if errorMsg and not isThrottled('msg') then
		addon:prettyPrint(errorMsg)
	end
end

function addon:playSpell(spellID, isTest)
	playSpell(spellID, isTest)
end
