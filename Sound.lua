local addonName, addon = ...

local registeredSoundpacks = {}
local GetTime = GetTime
local throttleTime = {
	['sound'] = GetTime(),
	['msg'] = GetTime()
}
local numberOfRegisteredSoundPacks = 0

function addon:RegisterSoundpack(name, player)
	numberOfRegisteredSoundPacks = numberOfRegisteredSoundPacks + 1
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

function addon:CheckSoundPackExist(name)
	for k,_ in pairs(registeredSoundpacks) do
		if k == name then
			return true
		end
	end
	return false
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
			errorMsg = addon:ErrorPlayer(spellID, channel, isTest)
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
	if numberOfRegisteredSoundPacks == 0 then --NO SOUND PACKS INSTALLED
		addon.profile.sound.soundpack = nil
		local noPackErrorMsg = "WARNING - No sound packs installed/active!\nPlease check /VRA for more info!"
		addon:prettyPrint(noPackErrorMsg)
		C_Timer.After(20, function() addon:prettyPrint(noPackErrorMsg) end)
		return
	elseif numberOfRegisteredSoundPacks == 1 then --ONE SOUND PACKS INSTALLED
		C_Timer.After(30, function() addon:prettyPrint("Additional sound packs available on your favorite addon client - Just search for \"Vocal Raid Assistant\"") end)
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

function addon:PlayTestSoundFile(name)
	if not PlaySoundFile(format("Interface\\AddOns\\" .. addonName .. "\\TestSounds\\%s.ogg", name), addon.profile.sound.channel) then
		addon:prettyPrint(addon:ErrorPlayer("", addon.profile.sound.channel, true))
	end
end