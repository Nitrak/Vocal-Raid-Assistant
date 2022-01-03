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
    ["en-US-SaraNeural"] = "Sara",
    ["en-US-EricNeural"] = "Eric",
    ["en-US-GuyNeural"] = "Guy",
}

local borderlessCoords = {0.07, 0.93, 0.07, 0.93}
local function spellOption(spellID)
    local spellname, _, icon = GetSpellInfo(spellID)
    local desc = GetSpellDescription(spellID)
    if (spellname ~= nil) then
        return {
            type = 'toggle',
            image = icon,
            imageCoords = borderlessCoords,
            name = spellname,
            desc = desc,
        }
    else
        return {
            type = 'toggle',
            name = "unknown spell, id:" .. spellID,
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

local function createClassSpellOptions()
    local args = {}
    for i = 1, MAX_CLASSES do
        local class = CLASS_SORT_ORDER[i]
        local className = format("|T%s:18|t %s", "Interface\\Icons\\ClassIcon_" .. class,
            LOCALIZED_CLASS_NAMES_MALE[class])
        args[class] = {
            type = 'group',
            inline = true,
            name = className,
            order = i,
            args = createOptionsForClass(class)
        }
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

local function GetMainOptions()
    return {
        name = "Vocal Raid Assistant",
        desc = L["PVE Voice Alert"],
        type = 'group',
        inline = true,
        args = {
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
                get = function() return "https://discord.gg/UZMzqap" end,
            }
        }
    }
end

local function GetGeneralOptions()
    return {
        type = 'group',
        name = L["General"],
        desc = L["General options"],
        order = 1,
        get = function(info)
            return profile.general[info[#info]]
        end,
        set = function(info, val)
            profile.general[info[#info]] = val
        end,
        args = {
            enableArea = {
                type = 'group',
                inline = true,
                name = L["Enable area"],
                get = function(info)
                    return profile.general.enabledArea[info[#info]]
                end,
                set = function(info, val)
                    profile.general.enabledArea[info[#info]] = val
                end,
                order = 1,
                args = {
                    all = {
                        type = 'toggle',
                        name = L["Anywhere"],
                        order = 1
                    },
                    field = {
                        type = 'toggle',
                        name = L["World"],
                        disabled = function()
                            return profile.general.enabledArea.all
                        end,
                        order = 2
                    },
                    battleground = {
                        type = 'toggle',
                        name = L["Battleground"],
                        disabled = function()
                            return profile.general.enabledArea.all
                        end,
                        order = 3
                    },
                    arena = {
                        type = 'toggle',
                        name = L["Arena"],
                        disabled = function()
                            return profile.general.enabledArea.all
                        end,
                        order = 4
                    },
                    instance = {
                        type = 'toggle',
                        name = L["Instance / M+"],
                        disabled = function()
                            return profile.general.enabledArea.all
                        end,
                        order = 5
                    },
                    raidinstance = {
                        type = 'toggle',
                        name = L["Raid"],
                        disabled = function()
                            return profile.general.enabledArea.all
                        end,
                        order = 6
                    },
                    scenario = {
                        type = 'toggle',
                        name = L["Scenario"],
                        disabled = function()
                            return profile.general.enabledArea.all
                        end,
                        order = 7
                    }
                }
            },
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
                order = 2,
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
                desc = L["Voice Options"],
                get = function(info)
                    return profile.sound[info[#info]]
                end,
                set = function(info, val)
                    profile.sound[info[#info]] = val
                end,
                order = 3,
                args = {
                    soundpack = {
                        type = 'select',
                        name = L["Soundpack"],
                        desc = L["Soundpack Options"],
                        values = soundpacks,
                        order = 1
                    },
                    playButton = {
                        type = 'execute',
                        name = L["Test"],
                        func = function() addon:playSpell("98008") end,
                        order = 2,
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
    }
end

local function GetAbilitiesOption()
    local instanceTypes = {
        ["none"] = { display = L["World"], value = "field", order = 1 },
        ["party"] = { display = L["Instance / M+"], value = "instance", order = 2 },
        ["raid"] = { display = L["Raid"], value = "raidinstance", order = 3 },
        ["pvp"] = { display = L["Battleground"], value = "battleground", order = 4 },
        ["arena"] = { display = L["Arena"], value = "arena", order = 5 },
        ["scenario"] = { display = L["Scenario"], value = "scenario", order = 6 }
    }

    local abilityOptions = {
        type = "group",
        name = L["Abilities"],
        childGroups = "tab",
        args = {}
    }

    for k, v in pairs(instanceTypes) do
        abilityOptions.args[k] = {
            type = "group",
            name = v.display,
            order = v.order,
            get = function(info)
                return profile.zoneConfig[k].enabledSpells[info[#info]]
            end,
            set = function(info, val)
                profile.zoneConfig[k].enabledSpells[info[#info]] = val
                if (val == true) then
                    addon:playSpell(info[#info])
                end
            end,
            disabled = function()
                if profile.general.enabledArea.all == true then
                    return false
                end
                return profile.general.enabledArea[v.value] ~= true
            end,
            args = {
                interrupts = {
                    type = "group",
                    name = L["Interrupts"],
                    inline = true,
                    order = 1,
                    get = function()
                        return profile.zoneConfig[k].enableInterrupts
                    end,
                    set = function(info, val)
                        profile.zoneConfig[k].enableInterrupts = val
                    end,
                    args = {
                        toggleInterrupts = {
                            type = "toggle",
                            name = L["Interrupts"],
                            desc = L["Play sound on interrupts"]
                        }
                    }
                },
                classAbilities = {
                    type = "group",
                    name = "",
                    inline = true,
                    order = 2,
                    args = createClassSpellOptions()
                },
                general = {
                    type = "group",
                    name = L["General Spells"],
                    inline = true,
                    order = 3,
                    args = {
                        generalOptions = {
                            type = 'group',
                            inline = true,
                            name = L["General"],
                            args = createOptionsForClass("general")
                        }
                    }
                }
            }
        }
    end
    return abilityOptions
end

local function getSpellOption(info)
    local name = info[#info]
    return addon.db.profile.spells[name]
end

local function setSpellOption(info, value)
    local name = info[#info]
    addon.db.profile.spells[name] = value
    if value then
        PlaySoundFile("Interface\\Addons\\" .. vradb.path .. "\\" .. name .. ".ogg", "Master");
    end
end

function addon:RefreshOptions(database)
    profile = database.profile
end

function addon:InitOptions()
    profile = addon.db.profile

    self.AC:RegisterOptionsTable("VocalRaidAssistant", GetMainOptions)
    self.AC:RegisterOptionsTable("Vocal Raid Assistant - General", GetGeneralOptions)
    self.AC:RegisterOptionsTable("Vocal Raid Assistant - Abilities", GetAbilitiesOption)
    self.AC:RegisterOptionsTable("Vocal Raid Assistant - Profiles", self.ACDBO:GetOptionsTable(self.db))

    self.ACD:AddToBlizOptions("VocalRaidAssistant", "VocalRaidAssistant")
    self.ACD:AddToBlizOptions("Vocal Raid Assistant - General", "General", "VocalRaidAssistant")
    self.ACD:AddToBlizOptions("Vocal Raid Assistant - Abilities", "Abilities", "VocalRaidAssistant")
    self.ACD:AddToBlizOptions("Vocal Raid Assistant - Profiles", "Profiles", "VocalRaidAssistant")
end

