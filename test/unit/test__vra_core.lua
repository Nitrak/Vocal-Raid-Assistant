-- Some basic testing for the VRA Core
-- Should use some testing framework like busted...

-- Stub Addon Env
local addonName = "VRA_STUB"
local addon = {
	profile = {
		general = {
			area = {
				STUB = setmetatable({ onlySelf = true }, {
                    __index = function(_, key)
                        return setmetatable({}, {
                            __index = function(_, spellID)
                                return true  -- Always return true for any spellID
                            end
                        })
                    end
                })
			},
			watchFor = 6, -- COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
		},
		sound = {
			throttle = 0,
			channel = "Master"
		},
	}
}

-- Default mock log entry (string format)
-- Aug In Grp Casting Spatial Paradox on me
local logEntry = "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"

-- Default "In Combat"
local inCombat = true

-- Default "PlayerGUID"
local unitGuidPlayer = "Player-1234-123"

-- Function to split the string by a delimiter
local function split(str, delimiter)
	local result = {}
	for match in (str..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end

-- Stub function to simulate CombatLogGetCurrentEventInfo using a stored string
local function stubCombatLogGetCurrentEventInfo()
	local values = split(logEntry, ", ")

	-- Mapping values to variables
	local timestamp = values[1]
	local subevent = values[2]
	local hideCaster = values[3]
	local sourceGUID = values[4]
	local sourceName = values[5]
	local sourceFlags = tonumber(values[6])
	local sourceFlags2 = tonumber(values[7])
	local destGUID = values[8]
	local destName = values[9]
	local destFlags = tonumber(values[10])
	local destFlags2 = tonumber(values[11])
	local spellID = tonumber(values[12])
	local spellName = values[13]
	local spellScool = tonumber(values[14])

	return timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags,
	destFlags2, spellID, spellName, spellScool
end

-- Function to update the mock log entry dynamically
local function setMockCombatLogEntry(newEntry)
    logEntry = newEntry
end

-- Example usage
-- SetMockCombatLogEntry("123456.78, SPELL_HEAL, nil, Player-5678, Healer, 0x511, nil, Player-1234, TestPlayer, 0x10a48, nil, 67890, Holy Light")


-- Functions
IsInInstance = function() return true, "STUB" end
UnitAffectingCombat = function() return inCombat end
CombatLogGetCurrentEventInfo = stubCombatLogGetCurrentEventInfo
UnitGUID = function() return unitGuidPlayer end

-- Constants
COMBATLOG_OBJECT_TYPE_NPC = 0x00000800


-- WoW uses Lua 5.1, but for testing we use latest 5.4. With 5.2 bit library was moved to bit32 and removed with Lua 5.3
if not bit then
    bit = {}
    function bit.band(a, b)
        return a & b  -- Lua 5.3+ native bitwise AND
    end
    function bit.bor(a, b)
        return a | b  -- Bitwise OR
    end
    function bit.bxor(a, b)
        return a ~ b  -- Bitwise XOR
    end
    function bit.lshift(a, b)
        return a << b  -- Left shift
    end
    function bit.rshift(a, b)
        return a >> b  -- Right shift
    end
end

addon.playSpell = function(self, spellID)
    print("would play: " .. spellID)
	return true
end

--- #### Start Testing stuff...

-- Function to load and run Core.lua with mock parameters, aka emulate the blizz addon environment
-- Use loadfile to have more control over the environment
local addonFiles = {
	"Core.lua",
	"SpellList.lua",
	"SpellCorrections.lua"
}

for i, luaFileName in ipairs(addonFiles) do
	local path = "../../" .. luaFileName
	local chunk = loadfile(path)
	if chunk then
		-- Manually pass the parameters as a table (simulating '...')
		chunk(addonName, addon)
	else
		print("Error loading: " .. luaFileName)
	end
end



-- ### TestCases
--addon:MockCombatLogGetCurrentEventInfo(stubCombatLogGetCurrentEventInfo)

local function test__EvokerCastOnMe()
	local log = "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"
	setMockCombatLogEntry(log)
	addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
end

test__EvokerCastOnMe()





