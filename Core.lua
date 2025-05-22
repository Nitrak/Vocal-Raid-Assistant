local _, addon = ...

local tostring = tostring
local IsInInstance = IsInInstance
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local UnitAffectingCombat = UnitAffectingCombat
local IsSpellHarmful = C_Spell and C_Spell.IsSpellHarmful or IsHarmfulSpell


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

local function checkSpellTarget(spellID, destFlags, destGUID)
	-- Valid Targets are:
	-- No Target: --> AOE
	-- It has to be a harmful spell. Friendly spells usually apply an aura and are handled via auraCheckFunction
	-- The harmful check is also necessary to filters casts, while caster has boss in target. E.g. Spatial Paradox defaulting to nearest healer
	return destGUID == '' or -- AOE Spell
	IsSpellHarmful(spellID)
end

local function checkAuraTarget(destFlags, destGUID, onlySelf)
	-- We are only interested in aura applications to players
	if not bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER then
		return false
	end
	return onlySelf and destGUID == UnitGUID("player") or not onlySelf
end

local spellCheckFunctions = {
	["CAST"] = function(instanceType, spellID, destFlags, destGUID)
		if addon:IsSpellSupported(spellID) and checkSpellTarget(spellID, destFlags, destGUID) then
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
	["AURA_APPLICATION"] = function(instanceType, spellID, destFlags, destGUID)
		-- Cheat death debuffs
		if addon.cheatDeathList[spellID] and addon.profile.general.area[instanceType].enableCheatDeaths then
			addon:playSpell(spellID)
			return
		end

		-- Externals
		local onlySelf = addon.profile.general.area[instanceType].onlySelf
		if addon:IsSpellSupported(spellID) and checkAuraTarget(destFlags, destGUID, onlySelf) then
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
