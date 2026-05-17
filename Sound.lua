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
	for k, _ in pairs(registeredSoundpacks) do
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
	local soundPlayer = registeredSoundpacks[addon.profile.sound.soundpack]

	if not soundPlayer then
		addon:prettyPrint(L["No Voicepack"])
		return
	end

	if isThrottled("sound") then return end

	local errorMsg = not soundPlayer(spellID, channel) and addon:determinePlayerError(spellID, channel, isTest)
	if errorMsg and not isThrottled("msg") then
		addon:prettyPrint(errorMsg)
	end
end

function addon:playSpell(spellID, isTest)
	playSpell(spellID, isTest)
end

function addon:verifySoundPack()
	if not next(registeredSoundpacks) then
		addon.profile.sound.soundpack = nil
		local msg = L["No Voicepack Warning"]
		addon:prettyPrint(msg)
		C_Timer.After(20, function() addon:prettyPrint(msg) end)
		return
	end

	if not registeredSoundpacks[addon.profile.sound.soundpack] then
		addon.profile.sound.soundpack = next(registeredSoundpacks)
	end
end
