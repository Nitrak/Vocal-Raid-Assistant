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
		cheatDeathList = {}
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

		-- Ensure `bit` exists for Lua 5.1
		if not _G.bit then
			_G.bit = require("bit") -- Use the 'bit' library in Lua 5.1
		end

        _G.COMBATLOG_OBJECT_TYPE_NPC = 2048
		_G.COMBATLOG_OBJECT_TYPE_PLAYER = 1024

        -- Load minimum addon files
        local addonFiles = {"Core.lua", "SpellList.lua", "SpellCorrections.lua"}

        for _, luaFileName in ipairs(addonFiles) do
            local path = luaFileName
            local chunk = loadfile(path)
            assert(chunk, "Error loading: " .. luaFileName)
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
				describe("always play if it is a harmful spell:", function()
					checkSpellCastEvent(logStringEvokerOneEnemyCast, true, false, "only self = false", "called")
					checkSpellCastEvent(logStringEvokerOneEnemyCast, true, true, "only self = true", "called")
				end)
				describe("never play, if it is helpful spell:", function()
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
    end)
end)
