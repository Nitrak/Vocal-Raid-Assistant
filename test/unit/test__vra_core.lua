-- Some basic testing for the VRA Core
-- Should use some testing framework like busted...

local addonName = "VRA_STUB"
local addon = {
	profile = {
		general = {
			area = {
				STUB = {
					enabled = true
				}
			}
		}
	}
}

-- Stub Functions
IsInInstance = function() return true, "STUB" end
CombatLogGetCurrentEventInfo = functiony
-- Function to load and run Core.lua with mock parameters, aka emulate the blizz addon environment
-- Use loadfile instead to have more control over the environment
local chunk = loadfile("../../Core.lua")
if chunk then
	-- Manually pass the parameters as a table (simulating '...')
	chunk(addonName, addon)
else
	print("Error loading Core.lua")
end



addon:stubPrint()
addon:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED")


local log_entry = "1617986084.18, SWING_DAMAGE, false, Player-1096-06DF65C1, Xiaohuli, 1297, 0, Creature-0-4253-0-160-94-000070569B, Cutpurse, 68168, 0, 3, -1, 1, nil, nil, nil, true, false, false, false"

-- Function to split the string by a delimiter
local function split(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Split the string into a table
local values = split(log_entry, ", ")

-- Mapping values to variables
local timestamp = values[1]
local subevent = values[2]
local hideCaster = values[3]
local sourceGUID = values[4]
local sourceName = values[5]
local sourceFlags = values[6]
local sourceRaidFlags = values[7]
local destGUID = values[8]
local destName = values[9]
local destFlags = values[10]
local destRaidFlags = values[11]

-- Print the mapped values (for debugging)
print("Timestamp:", timestamp)
print("Subevent:", subevent)
print("HideCaster:", hideCaster)
print("Source GUID:", sourceGUID)
print("Source Name:", sourceName)
print("Source Flags:", sourceFlags)
print("Source Raid Flags:", sourceRaidFlags)
print("Dest GUID:", destGUID)
print("Dest Name:", destName)
print("Dest Flags:", destFlags)
print("Dest Raid Flags:", destRaidFlags)

