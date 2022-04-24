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

function addon:verifySoundPack()
	local nSP = next(registeredSoundpacks)
	--NO SOUND PACKS INSTALLED
	if nSP == nil then
		addon.profile.sound.soundpack = nil
		local noPackErrorMsg = "WARNING - No Sound Packs installed/active!\nPlease check /VRA for more info!"
		addon:prettyPrint(noPackErrorMsg)
		C_Timer.After(30, function() addon:prettyPrint(noPackErrorMsg) end)
		return
	end
	
	--Check if registered sound pack is valid
	local foundPack = false
	for k,_ in pairs(registeredSoundpacks) do
		if k == addon.profile.sound.soundpack then
			foundPack = true
		end
	end
	--If config sound pack is not found or is nil select a valid (first valid)
	if not foundPack or addon.profile.sound.soundpack == nil then
		addon.profile.sound.soundpack = select(1,nSP)
	end
end