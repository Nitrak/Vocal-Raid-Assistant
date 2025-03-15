require 'busted.runner'()

describe("busted", function()
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

	local inCombat = true
	local fakeCombatLogEvent = {}

	-- Function to simulate CombatLogGetCurrentEventInfo Output using a stored string
	local function loadCombatLogEventFromString(logString)
		local function split(str, delimiter)
			local result = {}
			for match in (str..delimiter):gmatch("(.-)"..delimiter) do
				table.insert(result, match)
			end
			return result
		end

		local values = split(logString, ", ")

		-- Mapping values to variables
		local timestamp = values[1]
		local subevent = values[2]
		local hideCaster = values[3] == 'true' and true or false
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

		return { timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags,
		destFlags2, spellID, spellName, spellScool }
	end

	-- Function to mock log entry dynamically
	local function setMockCombatLogEntry(logString)
    	fakeCombatLogEvent = loadCombatLogEventFromString(logString)
	end

	setup("load addon", function()
		-- Stub Blizz functions
		stub(_G, "IsInInstance", function() return true, "STUB" end)
		stub(_G, "UnitAffectingCombat", function() return inCombat end)
		stub(_G, "CombatLogGetCurrentEventInfo", function()
			return table.unpack(fakeCombatLogEvent)
		end)

		-- Ensure `bit` exists
		if not _G.bit then
			_G.bit = {}
		end

		-- Stub bitwise functions
		stub(_G.bit, "band", function(a, b) return a & b end)
		stub(_G.bit, "bor", function(a, b) return a | b end)
		stub(_G.bit, "bxor", function(a, b) return a ~ b end)
		stub(_G.bit, "lshift", function(a, b) return a << b end)
		stub(_G.bit, "rshift", function(a, b) return a >> b end)

		-- Load minimum addon files
		local addonFiles = {
			"Core.lua",
			"SpellList.lua",
			"SpellCorrections.lua"
		}

		for _, luaFileName in ipairs(addonFiles) do
			local path = "../../" .. luaFileName
			local chunk = loadfile(path)
			assert(chunk,  "Error loading: " .. luaFileName)
			chunk(addonName, addon)
		end
	end)


	describe("Addon name is mocked", function()
		it("Checks if our custom load is working", function()
		  local expected = "VRA_STUB"
		  assert.are.equals(expected, addonName)
		end)
	end)


	describe("Check CombatLog loading", function()
		it("should parse and return a SPELL_CAST_SUCCESS_EVENT", function()
			local logString = "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"
			setMockCombatLogEntry(logString)

			-- Call the stubbed function
			local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags,
			destFlags2, spellID, spellName, spellSchool = CombatLogGetCurrentEventInfo()

			 -- Assertions
			 assert.equals(timestamp, "123456.78")
			 assert.equals(event, "SPELL_CAST_SUCCESS")
			 assert.is_false(hideCaster)
			 assert.equals(sourceGUID, "Player-1234-456")
			 assert.equals(sourceName, "CasterName")
			 assert.equals(sourceFlags, 1298)
			 assert.equals(destGUID, "Player-1234-123")
			 assert.equals(destName, "TargetName")
			 assert.equals(destFlags, 1297)
			 assert.equals(spellID, 406732)
			 assert.equals(spellName, "Spatial Paradox")
			 assert.equals(spellSchool, 64)
		end)
	end)


	describe("Bitwise Operations", function()
		it("should correctly perform bitwise AND", function()
			assert.equals(bit.band(5, 3), 5 & 3)  -- 101 & 011 = 001 (1)
		end)

		it("should correctly perform bitwise OR", function()
			assert.equals(bit.bor(5, 3), 5 | 3)  -- 101 | 011 = 111 (7)
		end)

		it("should correctly perform bitwise XOR", function()
			assert.equals(bit.bxor(5, 3), 5 ~ 3)  -- 101 ^ 011 = 110 (6)
		end)

		it("should correctly perform left shift", function()
			assert.equals(bit.lshift(1, 2), 1 << 2)  -- 0001 << 2 = 0100 (4)
		end)

		it("should correctly perform right shift", function()
			assert.equals(bit.rshift(8, 2), 8 >> 2)  -- 1000 >> 2 = 0010 (2)
		end)
	end)


	describe("Check VRA Announce", function()
		before_each(function()
			-- Reset before each test
			fakeCombatLogEvent = {}
		end)

		describe("")
		it("Partymember casts spell on me", function()
			local logString = "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"
			setMockCombatLogEntry(logString)
			addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
		end)
	end)
end)
