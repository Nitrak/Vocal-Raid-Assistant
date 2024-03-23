local _, addon = ...

local tostring = tostring
local IsInInstance = IsInInstance
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local UnitAffectingCombat = UnitAffectingCombat


local function allowedZone(instanceType)
	return addon.profile.general.area[instanceType].enabled
end

local function combatPlayCheck(instanceType)
	return addon.profile.general.area[instanceType].combatOnly and not UnitAffectingCombat("player")
end

local function checkEventType(event)
	local allowedSubEvents = {
		["SPELL_CAST_SUCCESS"] = true,
		["SPELL_AURA_APPLIED"] = true,
		["SPELL_INTERRUPT"] = true,
	}
	return allowedSubEvents[event] or false
end

local targetTypePlayer = bit.bor(COMBATLOG_OBJECT_TARGET, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_PLAYER)
local function checkSpellTarget(destFlags, destGUID)
	return destGUID == '' or (bit.band(destFlags, targetTypePlayer) > 0 and destGUID == UnitGUID("player"))
end

local spellCheckFunctions = {
	["CAST"] = function(instanceType, spellID, destFlags, destGUID)
		if not addon.profile.general.area[instanceType].onlySelf or (addon.profile.general.area[instanceType].onlySelf and checkSpellTarget(destFlags, destGUID)) and addon:IsSpellSupported(spellID) then
			addon:playSpell(spellID)
		end
	end,
	["TAUNT"] = function(instanceType)
		if addon.profile.general.area[instanceType].enableTaunts then
			addon:playSpell('taunted')
		end
	end,
	["INTERRUPT"] = function(instanceType)
		if addon.profile.general.area[instanceType].enableInterrupts then
			addon:playSpell('countered')
		end
	end,
	["AURA_APPLICATION"] = function(instanceType, spellID)
		-- We only watch for aura applications of cheat death debuffs
		if addon.cheatDeathList[spellID] and addon.profile.general.area[instanceType].enableCheatDeaths then
			addon:playSpell(spellID)
		end
	end
}

function addon:COMBAT_LOG_EVENT_UNFILTERED(cleu_event)
	local _, instanceType = IsInInstance()
	if (not (cleu_event == "COMBAT_LOG_EVENT_UNFILTERED" and allowedZone(instanceType)) or combatPlayCheck(instanceType)) then
		return
	end

	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags,
	destFlags2, spellID, spellName = CombatLogGetCurrentEventInfo()

	-- Check if we are interested in this event and have configured to watch for own or party member abilities
	if (not (checkEventType(event) and (bit.band(sourceFlags, self.profile.general.watchFor) > 0))) then
		return
	end

	local checkHandler = nil
	if event == 'SPELL_CAST_SUCCESS' then
		-- apply spell correction (e.g. hex and polymorh can have different spellIds when glyphed)
		spellID = addon.spellCorrections[spellID] or spellID
		-- Check if this is a spellcast or taunt
		if addon.profile.general.area[instanceType].spells[tostring(spellID)] then
			checkHandler = spellCheckFunctions["CAST"]
		elseif addon.tauntList[spellID] then
			checkHandler = spellCheckFunctions["TAUNT"]
		end
	elseif event == 'SPELL_AURA_APPLIED' then
		checkHandler = spellCheckFunctions["AURA_APPLICATION"]
	elseif event == 'SPELL_INTERRUPT' then
		checkHandler = spellCheckFunctions["INTERRUPT"]
	end

	if checkHandler then
		checkHandler(instanceType, spellID, destFlags, destGUID)
	end
end
