local addonName, addon = ...
local L = addon.L

local registeredSoundpacks = {}
local GetTime = GetTime
local throttleTime = {
	['sound'] = GetTime(),
	['msg'] = GetTime()
}

function addon:RegisterSoundpack(name, player)
	if registeredSoundpacks[name] then
		error('Sound pack already exist!')
	elseif type(player) ~= "function" then
		error('Check sound packs callback!')
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
		if not player(spellID, channel) then
			errorMsg = addon:determinePlayerError(spellID, channel, isTest)
		end
	else
		errorMsg = L["No Voicepack"]
	end
	if errorMsg and not isThrottled('msg') then
		addon:prettyPrint(errorMsg)
	end
end

function addon:playSpell(spellID, isTest)
	playSpell(spellID, isTest)
end

function addon:verifySoundPack()
	local countInstalledSoundPacks = 0
	for k, v in pairs(registeredSoundpacks) do
		countInstalledSoundPacks = countInstalledSoundPacks + 1
	end

	if countInstalledSoundPacks == 0 then --NO SOUND PACKS INSTALLED
		addon.profile.sound.soundpack = nil
		local noPackErrorMsg = L["No Voicepack Warning"]
		addon:prettyPrint(noPackErrorMsg)
		C_Timer.After(20, function() addon:prettyPrint(noPackErrorMsg) end)
		return
	elseif countInstalledSoundPacks == 1 then --ONE SOUND PACKS INSTALLED
		C_Timer.After(30, function() addon:prettyPrint(L["Additional Voicepacks"]) end)
	end

	--If config sound pack is not found or is nil select a valid (first valid)
	if not addon.profile.sound.soundpack or registeredSoundpacks[addon.profile.sound.soundpack] == nil then
		addon.profile.sound.soundpack = select(1,next(registeredSoundpacks))
	end
end
