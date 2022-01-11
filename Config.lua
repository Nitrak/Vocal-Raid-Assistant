local _, addon = ...
local L = VRA.L
local profile = {}

local filterValues = {
    ["player"] = COMBATLOG_OBJECT_AFFILIATION_MINE,
    ["grouporraid"] = bit.bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID)
}

local soundpacks = {
    ["en-US-AnaNeural"] = "Ana",
    ["en-US-ElizabethNeural"] = "Elizabeth",
    ["legacy-en-Julie"] = "Julie (Legacy)",
    ["en-US-SaraNeural"] = "Sara",
    ["en-US-EricNeural"] = "Eric",
    ["en-US-GuyNeural"] = "Guy"
}

local zones = {
    ["arena"] = ARENA,
    ["pvp"] = BATTLEGROUNDS,
    ["party"] = DUNGEONS,
    ["raid"] = RAIDS,
    ["scenario"] = SCENARIOS,
    ["none"] = BUG_CATEGORY2
}

local borderlessCoords = {0.07, 0.93, 0.07, 0.93}
local function spellOption(spellID)
    local spellname, _, icon = GetSpellInfo(spellID)
    local description = GetSpellDescription(spellID)
    if (spellname ~= nil) then
        return {
            type = 'toggle',
            image = icon,
            imageCoords = borderlessCoords,
            name = spellname,
            desc = description
        }
    else
        return {
            type = 'toggle',
            name = "unknown spell, id:" .. spellID
        }
    end
end

local function createOptionsForClass(class)
    local spellList = addon:GetSpellIdsByClass(class)
    local args = {}
    if (spellList ~= nil) then
        for spellID, _ in pairs(spellList) do
            args[tostring(spellID)] = spellOption(spellID)
        end
    end
    return args
end

local function setFilterValue(info, val)
    local filter = filterValues[info]
    if (filter ~= nil) then
        if (val) then
            profile.general.watchFor = bit.bor(profile.general.watchFor, filter)
        else
            profile.general.watchFor = bit.band(profile.general.watchFor, bit.bnot(filter))
        end
    end
end

local function getFilterValue(info)
    local filter = filterValues[info]
    if (filter ~= nil) then
        return (bit.band(profile.general.watchFor, filter) == filter)
    end
end

local function getSpellOption(info)
    return profile.general.area[info[2]].spells[info[#info]]
end

local function setSpellOption(info, val)
    profile.general.area[info[2]].spells[info[#info]] = val
    if (val == true) then
        addon:playSpell(info[#info])
    end
end

local function restoreDefaultSpells(area)
    profile.general.area[area].spells = {}
    for k, v in pairs(addon.defaultSpells) do
        profile.general.area[area].spells[k] = v
    end
end

local function clearAllSpells(area)
    restoreDefaultSpells(area)
    for k, _ in pairs(profile.general.area[area].spells) do
        profile.general.area[area].spells[k] = false
    end
end

local mainOptions = {
    name = "Vocal Raid Assistant",
    type = "group",
    args = {
        generalOptions = {
            name = "Vocal Raid Assistant",
            type = "group",
            order = 1,
            args = {
                title = {
                    name = "|cffffd200" .. "Vocal Raid Assistant",
                    order = 0,
                    type = "description",
                    fontSize = "large",
                },
                about = {
                    order = 1,
                    type = "description",
                    name = L["Credits"]
                },
                version = {
                    order = 2,
                    type = "description",
                    name = "Version: " .. addon.version
                },
                discord = {
                    order = 3,
                    type = "input",
                    name = L["Discord"],
                    get = function()
                        return "https://discord.gg/UZMzqap"
                    end
                }
            }
        },
        abilitiesOptions = {
            name = L["Abilities"],
            type = "group",
            order = 2,
            args = {
                watchFor = {
                    type = 'group',
                    inline = true,
                    name = L["Alert for"],
                    desc = L["VRA should alert you for"],
                    get = function(info)
                        return getFilterValue(info[#info])
                    end,
                    set = function(info, val)
                        setFilterValue(info[#info], val)
                    end,
                    order = 1,
                    args = {
                        player = {
                            type = 'toggle',
                            name = L["My own abilities"],
                            order = 1
                        },
                        grouporraid = {
                            type = 'toggle',
                            name = L["Party member abilities"],
                            order = 2
                        }
                    }
                },
                voice = {
                    type = 'group',
                    inline = true,
                    name = L["Voice"],
                    get = function(info)
                        return profile.sound[info[#info]]
                    end,
                    set = function(info, val)
                        profile.sound[info[#info]] = val
                    end,
                    order = 2,
                    args = {
                        soundpack = {
                            type = 'select',
                            name = L["Soundpack"],
                            values = soundpacks,
                            order = 1
                        },
                        playButton = {
                            type = 'execute',
                            name = L["Test"],
                            func = function()
                                addon:playSpell("98008")
                            end,
                            order = 2
                        },
                        throttle = {
                            type = 'range',
                            max = 60,
                            min = 0,
                            step = 0.5,
                            name = L["Throttle"],
                            desc = L["The minimum interval between two alerts in seconds"],
                            order = 3
                        }
                    }
                }
            }
        },
    }
}

local spells = {
    name = L["Abilities"],
    type = "group",
    disabled = function(info)
        return not profile.general.area[info[2]].enabled
    end,
    args = {
        clearAll = {
            name = L["Clear All"],
            order = 1,
            type = "execute",
            func = function(info)
                clearAllSpells(info[2])
            end,
            confirm = true
        },
        restoreDefault = {
            name = L["Restore Defaults"],
            order = 2,
            type = "execute",
            func = function(info)
                restoreDefaultSpells(info[2])
            end,
            confirm = true
        },
        interrupts = {
            type = "group",
            name = L["Interrupts"],
            inline = true,
            order = 3,
            args = {
                toggleInterrupts = {
                    type = "toggle",
                    name = L["Enable"],
                    desc = L["Play sound on interrupts"],
                    width = 1.05,
                    get = function(info)
                        return profile.general.area[info[2]].enableInterrupts
                    end,
                    set = function(info, val)
                        profile.general.area[info[2]].enableInterrupts = val
                    end
                }
            }
        }
    }
}

for i = 1, MAX_CLASSES do
    local class = CLASS_SORT_ORDER[i]
    local name = LOCALIZED_CLASS_NAMES_MALE[class]
    spells.args[class] = {
        icon = "Interface\\Icons\\ClassIcon_" .. class,
        iconCoords = borderlessCoords,
        name = name,
        type = "group",
        get = function(info)
            return getSpellOption(info)
        end,
        set = function(info, val)
            setSpellOption(info, val)
        end,
        args = createOptionsForClass(class)
    }
end

spells.args.general = {
    name = L["General"],
    desc = L["General Spells"],
    type = "group",
    order = 1,
    get = function(info)
        return getSpellOption(info)
    end,
    set = function(info, val)
        setSpellOption(info, val)
    end,
    args = createOptionsForClass("general")
}

for k, v in pairs(zones) do
    mainOptions.args.abilitiesOptions.args[k] = {
        name = v,
        type = "group",
        childGroups = "tab",
        args = {
            title = {
                name = v,
                order = 0,
                type = "description",
                fontSize = "large"
            },
            enable = {
                type = "toggle",
                name = L["Enable"],
                order = 1,
                get = function(info)
                    return profile.general.area[info[2]].enabled
                end,
                set = function(info, val)
                    profile.general.area[info[2]].enabled = val
                end
            },
            spells = spells
        }
    }
end

function addon:RefreshOptions(database)
    profile = database.profile
end

function addon:InitConfigOptions()
    profile = addon.db.profile
    mainOptions.args.profiles = self.ACDBO:GetOptionsTable(self.db)
    addon.AC:RegisterOptionsTable("VocalRaidAssistantConfig", mainOptions)
    addon.ACD:SetDefaultSize("VocalRaidAssistantConfig", 965, 650)
end

