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
        }
    }

    local inCombat = true
    local fakeCombatLogEvent = {}
    local fakePlayerGuid = "Player-1234-123"

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

		-- Ensure `bit` exists for Lua 5.1
		if not _G.bit then
			_G.bit = require("bit") -- Use the 'bit' library in Lua 5.1
		end

        _G.COMBATLOG_OBJECT_TYPE_NPC = 2048

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

    describe("Check VRA Announce", function()
        before_each(function()
            -- Reset before each test
            fakeCombatLogEvent = {}
        end)

        describe("Partymember casts spell on me:", function()
            -- Evoker in our group casts Spatial Paradox on "me"
            local logStringEvokerOnMe =
                            "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-123, TargetName, 1297, 0, 406732, Spatial Paradox, 64"

            it("Should play sound if: Externals only on me enabled", function()
                setMockCombatLogEntry(logStringEvokerOnMe)
                local play = spy.on(addon, "playSpell")

                addon.profile.general.area["STUB"].onlySelf = true
                addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
                assert.spy(play).was.called()
            end)

            it("Should play sound if: Externals only on me disabled", function()
            setMockCombatLogEntry(logStringEvokerOnMe)
                local play = spy.on(addon, "playSpell")

                addon.profile.general.area["STUB"].onlySelf = false
                addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
                assert.spy(play).was.called()
            end)
        end)

        describe("Partymember casts a spell on someone else", function()
            -- Evoker in our group casts Spatial Paradox on "someone"
            local logStringEvokerOnThird =
                            "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-456, CasterName, 1298, 0, Player-1234-444, TargetName, 1298, 0, 406732, Spatial Paradox, 64"

            it("Should not play sound if: Externals only on me enabled", function()
                setMockCombatLogEntry(logStringEvokerOnThird)
                local play = spy.on(addon, "playSpell")

                addon.profile.general.area["STUB"].onlySelf = true
                addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
                assert.spy(play).was.not_called()
            end)

            it("Should play sound if: Externals only on me disabled", function()
                setMockCombatLogEntry(logStringEvokerOnThird)
                local play = spy.on(addon, "playSpell")

                addon.profile.general.area["STUB"].onlySelf = false
                addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
                assert.spy(play).was.called()
            end)
        end)

        describe("Player casts a spell on someone else", function()
            -- Player Evoker casts Spatial Paradox on "someone"
            local logStringPlayerEvokerOnThird =
                            "123456.78, SPELL_CAST_SUCCESS, false, Player-1234-123, CasterName, 1297, 0, Player-1234-444, TargetName, 66834, 0, 406732, Spatial Paradox, 64"

            it("should not play sound if: Watch for Own Abilities not taken", function()
                setMockCombatLogEntry(logStringPlayerEvokerOnThird)
                local play = spy.on(addon, "playSpell")

                addon.profile.general.watchFor = 6 -- COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
                addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
                assert.spy(play).was.not_called()
            end)

            it("should play sound if: Watch for Own Abilities taken", function()
                setMockCombatLogEntry(logStringPlayerEvokerOnThird)
                local play = spy.on(addon, "playSpell")

                addon.profile.general.watchFor = 7 -- COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
                addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")
                assert.spy(play).was.called()
            end)
        end)
    end)
end)
