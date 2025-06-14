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
	return ({
		["SPELL_CAST_SUCCESS"] = true,
		["SPELL_AURA_APPLIED"] = true,
		["SPELL_INTERRUPT"] = true,
	})[event] or false
end

local function checkSpellTarget(spellID, destGUID)
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
	["CAST"] = function(_, spellID, _, destGUID)
		if addon:IsSpellSupported(spellID) and checkSpellTarget(spellID, destGUID) then
			addon:playSpell(spellID)
		end
	end,
	["TAUNT"] = function(instanceType)
		if addon.profile.general.area[instanceType].enableTaunts then
			addon:playSpell("taunted")
		end
	end,
	["INTERRUPT"] = function(instanceType)
		if addon.profile.general.area[instanceType].enableInterrupts then
			addon:playSpell("countered")
		end
	end,
	["AURA_APPLICATION"] = function(instanceType, spellID, destFlags, destGUID)
		local areaConfig = addon.profile.general.area[instanceType]
		-- Resurrecting Buff
		if spellID == "160029" and areaConfig.enableBattleres then
			addon:playSpell("battleress")
		end
		-- Cheat death debuffs
		if addon.cheatDeathList[spellID] and areaConfig.enableCheatDeaths then
			addon:playSpell(spellID)
			return
		end

		-- Externals
		if addon:IsSpellSupported(spellID) and checkAuraTarget(destFlags, destGUID, areaConfig.onlySelf) then
			addon:playSpell(spellID)
		end
	end
}

function addon:COMBAT_LOG_EVENT_UNFILTERED(cleu_event)
	local _, instanceType = IsInInstance()
	if not (cleu_event == "COMBAT_LOG_EVENT_UNFILTERED" and allowedZone(instanceType)) or combatPlayCheck(instanceType) then
		return
	end

	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags,
	destFlags2, spellID, spellName = CombatLogGetCurrentEventInfo()

	-- Ensure the event is relevant and the source is being watched
	if not (checkEventType(event) and (bit.band(sourceFlags, self.profile.general.watchFor) > 0)) then
		return
	end

	-- Correct spellID if necessary
	spellID = addon.spellCorrections[spellID] or spellID
	local spellStr = tostring(spellID)
	local areaSpells = addon.profile.general.area[instanceType].spells

	local checkHandler = ({
		SPELL_CAST_SUCCESS = areaSpells[spellStr] and spellCheckFunctions["CAST"]
		                     or addon.tauntList[spellID] and spellCheckFunctions["TAUNT"],
		SPELL_AURA_APPLIED = areaSpells[spellStr] and spellCheckFunctions["AURA_APPLICATION"],
		SPELL_INTERRUPT    = spellCheckFunctions["INTERRUPT"],
	})[event]

	if checkHandler then
		checkHandler(instanceType, spellID, destFlags, destGUID)
	end
end
