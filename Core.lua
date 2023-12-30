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
	["CAST"] = function(_, spellID, destFlags, destGUID)
		if not addon.profile.general.onlySelf or (addon.profile.general.onlySelf and checkSpellTarget(destFlags, destGUID)) and addon:IsSpellSupported(spellID) then
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
	end
}

function addon:COMBAT_LOG_EVENT_UNFILTERED(event)
	local _, instanceType = IsInInstance()
	if (not (event == "COMBAT_LOG_EVENT_UNFILTERED" and allowedZone(instanceType)) or combatPlayCheck(instanceType)) then
		return
	end

	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags,
	destFlags2, spellID, spellName = CombatLogGetCurrentEventInfo()

	-- Check if we are interested in this event and have configered to watch for own or party member abilities
	if (not (checkEventType(event) and (bit.band(sourceFlags, self.profile.general.watchFor) > 0))) then
		return
	end

	local spellType = nil
	if event == 'SPELL_CAST_SUCCESS' or (event == 'SPELL_AURA_APPLIED' and sourceGUID == destGUID ) then
		-- apply spell correction (e.g. hex and polymorh can have different spellIds when glyphed)
		spellID = addon.spellCorrections[spellID] or spellID
		-- Check if this is a spellcast or taunt
		if addon.profile.general.area[instanceType].spells[tostring(spellID)] then
			spellType = "CAST"
		elseif addon.tauntList[spellID] then
			spellType = "TAUNT"
		end
	elseif event == 'SPELL_INTERRUPT' then
		spellType = "INTERRUPT"
	end

	local checkHandler = spellCheckFunctions[spellType]
	if checkHandler then
		checkHandler(instanceType, spellID, destFlags, destGUID)
	end
end
