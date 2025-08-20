require 'busted.runner'()

describe("busted", function()
    local addonName = "VRA_STUB"
    local addon = {
        profile = {
            general = {
                area = {
                    STUB = setmetatable({
                        onlySelf = false
                    }, {
                        __index = function(_, key)
                            return setmetatable({}, {
                                __index = function(_, spellID)
                                    return true -- Always return true for any spellID
                                end
                            })
                        end
                    })
                },
                watchFor = 6 -- COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
            },
            sound = {
                throttle = 0,
                channel = "Master"
            }
        },
		cheatDeathList = {},
		IsRetail = function() return true end,
		L = {},
	}

    local inCombat = true
    local fakeCombatLogEvent = {}
    local fakePlayerGuid = "Player-1234-123"
	local isHarmful = true

    -- Function to simulate CombatLogGetCurrentEventInfo Output using a stored string
    local function loadCombatLogEventFromString(logString)
        local function split(str, delimiter)
            local result = {}
            for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
                table.insert(result, match)
            end
            return result
        end

        local values = split(logString, ", ")
		assert(#values == 14, "Check input string!")
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

        return {timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName,
          destFlags, destFlags2, spellID, spellName, spellScool}
    end

    -- Function to mock log entry dynamically
    local function setMockCombatLogEntry(logString)
        fakeCombatLogEvent = loadCombatLogEventFromString(logString)
    end

    setup("load addon", function()
        -- Stub Blizz functions
        stub(_G, "IsInInstance", function()
            return true, "STUB"
        end)
        stub(_G, "UnitAffectingCombat", function()
            return inCombat
        end)
        stub(_G, "UnitGUID", function()
            return fakePlayerGuid
        end)
        stub(_G, "CombatLogGetCurrentEventInfo", function()
            return table.unpack(fakeCombatLogEvent)
        end)
		stub(_G, "IsHarmfulSpell", function ()
			return isHarmful
		end)
		-- For testing purpose, there is no diff if raid or grp!
		stub(_G, "IsInRaid", function()
			return false
		end)
		stub(_G, "IsInGroup", function()
			return true
		end)
		stub(_G, "GetNumGroupMembers", function()
			return 5
		end)
		stub(_G, "UnitExists", function()
			return true
		end)
		stub(_G, "GetTime", function()
			-- we use 123456.78 for every mocked event string
			return 1234567.89
		end)

		-- Ensure `bit` exists for Lua 5.1
		if not _G.bit then
			_G.bit = require("bit") -- Use the 'bit' library in Lua 5.1
		end

		-- WOW Constants
        _G.COMBATLOG_OBJECT_TYPE_NPC = 0x00000800 		 -- 2024
		_G.COMBATLOG_OBJECT_TYPE_PLAYER = 0x00000400 	 -- 1028
		_G.COMBATLOG_OBJECT_AFFILIATION_MINE = 0x000001  -- 1
		_G.COMBATLOG_OBJECT_AFFILIATION_PARTY = 0x000002 -- 2
		_G.COMBATLOG_OBJECT_AFFILIATION_RAID = 0x000004  -- 4

		_G.RAIDS = "RAIDS"
		_G.DUNGEONS = "DUNGEONS"
		_G.BUG_CATEGORY2 = "None"
		_G.ARENA = "ARENA"
		_G.BATTLEGROUNDS = "BATTLEGROUND"
		_G.SCENARIOS = "SCENARIOS"

        -- Load minimum addon files
        local addonFiles = {"Core.lua", "Constants.lua", "SpellList.lua", "SpellCorrections.lua"}

        for _, luaFileName in ipairs(addonFiles) do
            local path = luaFileName
            local chunk = loadfile(path)
            assert(chunk, "Error loading: " .. luaFileName)
            chunk(addonName, addon)
        end

		-- For running tests, we need to disable throttle
		addon.MINIMUM_THROTTLE = 0
    end)

    describe("Addon name is mocked", function()
        it("Checks if our custom load is working", function()
            local expected = "VRA_STUB"
            assert.are.equals(expected, addonName)
        end)
    end)

    describe("Check CombatLog loading", function()
        it("should parse and return a SPELL_CAST_SUCCESS_EVENT", function()
            local logString =
                            "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"
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

    describe("Check VRA Announce:", function()
		before_each(function()
            -- Reset before each test
            fakeCombatLogEvent = {}
        end)

		local function spy_assert(f, assertion, ...)
			assert.spy(f)[assertion](...)
		end

		local function checkSpellCastEvent(cleu, isHarmfulSpell, onlySelf, expected_result_string, assert_func)
			isHarmful = isHarmfulSpell
			describe("", function()
				it(expected_result_string, function()
					setMockCombatLogEntry(cleu)
					local play = spy.on(addon, "playSpell")

					addon.profile.general.area["STUB"].onlySelf = onlySelf
					addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
					spy_assert(play, assert_func)
					play:revert()
				end)
			end)
		end

		local function checkAuraAppEvent(cleu, onlySelf, expected_result_string, assert_func)
			describe("", function()
				it(expected_result_string, function()
					setMockCombatLogEntry(cleu)
					local play = spy.on(addon, "playSpell")

					addon.profile.general.area["STUB"].onlySelf = onlySelf
					addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
					spy_assert(play, assert_func)
					play:revert()
				end)
			end)
		end

		local function checkBattleResEvent(cleu, enableBattleres, caster_infight, expected_result_string, assert_func)
			describe("", function()
				it(expected_result_string, function()
					setMockCombatLogEntry(cleu)
					inCombat = caster_infight
					local play = spy.on(addon, "playSpell")

					addon.profile.general.area["STUB"].enableBattleres = enableBattleres
					addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
					spy_assert(play, assert_func)
					play:revert()
				end)
			end)
		end

        describe("Partymember casts spell (with aura) on: -> Player <-:", function()
            -- Evoker in our group casts Spatial Paradox on "me"
			-- SPELL_CAST_SUCCESS should never play
			-- SPELL_AURA_APPLIED should only play if "onlySelf" taken
            local logStringEvokerOnMeCast = "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"
			local logStringEvokerOnMeAura = "123456.78, SPELL_AURA_APPLIED, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"

			describe("the spell cast should:", function()
				checkSpellCastEvent(logStringEvokerOnMeCast, false, true, "not play if only self = true", "not_called")
				checkSpellCastEvent(logStringEvokerOnMeCast, false, false, "not play if only self = false", "not_called")
			end)

			describe("the aura application should:", function()
				checkAuraAppEvent(logStringEvokerOnMeAura, false, "play if only self = true", "called")
				checkAuraAppEvent(logStringEvokerOnMeAura, false, "play, if only self = false", "called")
			end)
        end)

        describe("Partymember casts a friendly spell (with aura) on: -> Partymember / Not the Player <-:", function()
            -- Evoker in our group casts Spatial Paradox on "someone"
			-- SPELL_CAST_SUCCESS should play if target = not player
			-- SPELL_AURA_APPLIED should never play

            local logStringEvokerOnThirdCast = "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-444, TargetName, 1298, 0, 406732, Spatial Paradox, 64"
			local logStringEvokerOnThirdAura = "123456.78, SPELL_AURA_APPLIED, false, Player-1234-456, CasterName, 1298, 0, Player-1234-444, TargetName, 1298, 0, 406732, Spatial Paradox, 64"

			describe("the spell cast should:", function()
				checkSpellCastEvent(logStringEvokerOnThirdCast, false, true, "not play if only self = true", "not_called")
				checkSpellCastEvent(logStringEvokerOnThirdCast, false, false, "not play if only self = false", "not_called")
			end)

			describe("the aura application should:", function()
				checkAuraAppEvent(logStringEvokerOnThirdAura, true, "not play if only self = true", "not_called")
				checkAuraAppEvent(logStringEvokerOnThirdAura, false, "play, if only self = false", "called")
			end)
        end)


		describe("Partymember casts a spell (with aura) on: -> NPC Target <-:", function()
		-- Evoker in our group casts Spatial Paradox, but has the boss / create in target
		-- Fallbacks:
		-- --> 1. We get the Aura
		-- --> 2. Another healer gets the Aura

		local logStringEvokerOneEnemyCast = "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-444, CasterName, 1298, 0, Creature-1234-444, TargetName, 2600, 0, 406732, Spatial Paradox, 64"
		local logStringEvokerOnEnemyAura_Me = "123456.78, SPELL_AURA_APPLIED, false, Player-1234-444, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"
		local logStringEvokerOnEnemyAura_Other = "123456.78, SPELL_AURA_APPLIED, false, Player-1234-444, CasterName, 1298, 0, Player-1234-555, TargetName, 1298, 0, 406732, Spatial Paradox, 64"

			describe("the spell cast should:", function()
				describe("play if it is a harmful spell:", function()
					checkSpellCastEvent(logStringEvokerOneEnemyCast, true, false, "only self = false", "called")
					checkSpellCastEvent(logStringEvokerOneEnemyCast, true, true, "only self = true", "called")
				end)
				describe("not play, if it is helpful spell:", function()
					checkSpellCastEvent(logStringEvokerOneEnemyCast, false, true, "only self = true", "not_called")
					checkSpellCastEvent(logStringEvokerOneEnemyCast, false, false, "only self = false", "not_called")
				end)
			end)

			describe("the aura application:", function()
				-- Fallback #1 -> We get the Aura
				describe("is applied to us and it should:", function()
					checkAuraAppEvent(logStringEvokerOnEnemyAura_Me, true, "play if only self = true", "called")
					checkAuraAppEvent(logStringEvokerOnEnemyAura_Me, false, "play, if only self = false", "called")
				end)
				-- Fallback #2 -> Another Heal in Party gets the Aura
				describe("is applied to party member and it should:", function()
					checkAuraAppEvent(logStringEvokerOnEnemyAura_Other, true, "not play, if only self = true", "not_called")
					checkAuraAppEvent(logStringEvokerOnEnemyAura_Other, false, "play, if only self = false", "called")
				end)

			end)
		end)


		describe("The player casts a harmful spell on: -> NPC Target <-:", function()
			local logStringPlayerOnThird = "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-123, CasterName, 1297, 0, Creature-1234-444, TargetName, 68168, 0, 322109, Touch of Death, 1"

			describe("the spellcast should:", function()
				describe("not play: ", function()
					-- COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
					addon.profile.general.watchFor = 6
					checkSpellCastEvent(logStringPlayerOnThird, true, false, "-> Watch for Own Abilities <- NOT taken", "not_called")
				end)

				describe("play:", function()
					-- COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
					addon.profile.general.watchFor = 7
					checkSpellCastEvent(logStringPlayerOnThird, true, false, "-> Watch for Own Abilities <- taken", "called")
				end)
			end)
		end)

		-- Battle Res
		describe("Battleres...", function()
			local battleresString = "123456.78, SPELL_RESURRECT, false, Player-1234-123, CasterName, 1298, 32, Player-1234-555, TargetName , 1297, 0, 391054, Intercession, 2"
			describe("should not announce, if:", function()
				checkBattleResEvent(battleresString, false, true, "battleres option not enabled, caster infight", "not_called")
				checkBattleResEvent(battleresString, false, false, "battleres option not enabled, caster not infight", "not_called")
				checkBattleResEvent(battleresString, true, false,"battleres option enabled, but caster not infight", "not_called")
			end)
			describe("should announce if:", function()
				checkBattleResEvent(battleresString, true, true, "battleres option enabled and caster infight", "called")
			end)
		end)

		-- Throttle
		-- We want to test if our throttling is handled properly.
		-- Mainly we need to deal with one cast that applies an aura to multiple targets, like Bloodlust or Spatial Paradox
		-- These events are logged within a view milliseconds
		-- The inital cast event is already checked in other test cases and expected to be filtered out /
		-- working as expected correctly here

		describe("Inbuilt trottle:", function()

			-- if the diff between both timestamps >= MINIMUM_THROTTLE do announce,
			-- if diff < MINIMUM_THROTTLE, do not announce the seconds event

			-- GetTime = 1234567.89

			local logStringEvokerOnMe     = "1234567.89, SPELL_AURA_APPLIED, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"
			local logStringEvokerOnEvoker = "1234567.89, SPELL_AURA_APPLIED, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"

			describe("should prevent second announce, when MINIMIUM_THROTTLE hit: ", function()
				addon.MINIMUM_THROTTLE = 1
				checkAuraAppEvent(logStringEvokerOnMe, false, "this should be announced", "called")
				checkAuraAppEvent(logStringEvokerOnEvoker, false, "should be trotteled", "not_called")
			end)

			describe("should play second announce, when MINIMUM_THROTTLE not hit: ", function()
				addon.MINIMUM_THROTTLE = 0
				checkAuraAppEvent(logStringEvokerOnMe, false, "this should be announced", "called")
				checkAuraAppEvent(logStringEvokerOnEvoker, false, "this should be announced", "called")
			end)
		end)
    end)
end)
