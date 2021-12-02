local addonName, addon = ...
addon.version = GetAddOnMetadata(addonName, "Version")

VRA = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceConsole-3.0", "AceEvent-3.0")
VRA.L = LibStub("AceLocale-3.0"):GetLocale(addonName)
VRA.AC = LibStub("AceConfig-3.0")
VRA.ACD = LibStub("AceConfigDialog-3.0")
VRA.ACDBO = LibStub("AceDBOptions-3.0")

local tostring = tostring
local profile = {}
local throttleTime
local interruptList = {}
local filter = 0

local defaults = {
    profile = {
        general = {
            enabledArea = {
                instance = true,
                raidinstance = true
            },
            watchFor = 6,
        },
        sound = {
            soundpack = "en-US-SaraNeural",
            throttle = 2
        },
        enabledSpells = {
                ["633"] = true,
				["2825"] = true,
				["740"] = true,
				["322109"] = true,
				["116849"] = true,
				["328231"] = true,
				["51052"] = true,
				["324386"] = true,
				["106898"] = true,
				["51514"] = true,
				["6940"] = true,
				["192077"] = true,
				["192081"] = true,
				["62618"] = true,
				["31821"] = true,
				["97462"] = true,
				["114052"] = true,
				["217832"] = true,
				["853"] = true,
				["323673"] = true,
				["12042"] = true,
				["111771"] = true,
				["102342"] = true,
				["196718"] = true,
				["29166"] = true,
				["118"] = true,
				["109964"] = true,
				["871"] = true,
				["47536"] = true,
				["10060"] = true,
				["49576"] = true,
				["98008"] = true,
				["12975"] = true,
				["47788"] = true,
				["310454"] = true,
				["1160"] = true,
				["12472"] = true,
				["246287"] = true,
				["48707"] = true,
				["187827"] = true,
				["5246"] = true,
				["321507"] = true,
				["86949"] = true,
				["61336"] = true,
				["13750"] = true,
				["2094"] = true,
				["323764"] = true,
				["32182"] = true,
				["16191"] = true,
				["23920"] = true,
				["22812"] = true,
				["33206"] = true,
				["323546"] = true,
				["320674"] = true,
				["642"] = true,
				["108280"] = true,
				["206491"] = true,
				["190456"] = true,
				["325013"] = true,
				["122278"] = true,
				["316958"] = true,
        },
        enableInterrupts = true
    }
}




function VRA:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("VocalRaidAssistantDB", defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
    self.db.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
    self.db.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
    profile = self.db.profile
    self:RegisterChatCommand("vra", "ChatCommand")
    self:InitOptions()

    ---
    interruptList = self.GetInterruptSpellIds()
end

function VRA:ChangeProfile()
    profile = self.db.profile
    self:RefreshOptions(self.db)
end

function VRA:ChatCommand()
    InterfaceOptionsFrame_OpenToCategory("VocalRaidAssistant")
    -- Call this a second time to fix a BlizzardUI Bug
    InterfaceOptionsFrame_OpenToCategory("VocalRaidAssistant")
end

function VRA:OnEnable()
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- ### Core 
local function allowedZone()
    local _, currentZoneType = IsInInstance()
    return (((currentZoneType == "none" and profile.general.enabledArea.all) or
               (currentZoneType == "pvp" and profile.general.enabledArea.battleground) or
               (currentZoneType == "arena" and profile.general.enabledArea.arena) or
               (currentZoneType == "party" and profile.general.enabledArea.instance) or
               (currentZoneType == "raid" and profile.general.enabledArea.raidinstance) or
               profile.general.enabledArea.all))
end

local function allowedSubEvent(event)
    return (event == "SPELL_CAST_SUCCESS" or (event == "SPELL_INTERRUPT" and profile.enableInterrupts))
end

local function getFilterFromConfig()
    if (profile.general.watchFor.player) then
        filter = bit.bor(filter, COMBATLOG_FILTER_ME)
    end
    if (profile.general.watchFor.group) then
        filter = bit.bor(filter, COMBATLOG_OBJECT_AFFILIATION_PARTY)
    end
    if (profile.general.watchFor.raid) then
        filter = bit.bor(filter, COMBATLOG_OBJECT_AFFILIATION_RAID)
    end
end

local function isTrottled(spellID)
    local throttleTime = throttledSpells[spellID]
    if (throttleTime == nil or GetTime() > throttleTime) then
        throttledSpells[spellID] = GetTime() + profile.sound.throttle
        return false
    else
        return true
    end
end

function VRA:playSpell(spellId)
    local soundFile = "Interface\\AddOns\\VocalRaidAssistant\\Sounds\\" .. profile.sound.soundpack .. "\\" .. spellId .. ".ogg"
    if soundFile then
        PlaySoundFile(soundFile, "Master")
    end
end

function VRA:COMBAT_LOG_EVENT_UNFILTERED(event)
    if (not (event == "COMBAT_LOG_EVENT_UNFILTERED" and allowedZone())) then
        return
    end

    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName,
        destFlags, destFlags2, spellID, spellName = CombatLogGetCurrentEventInfo()

    if ((allowedSubEvent(event)) and (bit.band(sourceFlags, profile.general.watchFor) > 0)) then
        if ((event == 'SPELL_CAST_SUCCESS' and profile.enabledSpells[tostring(spellID)] and not isTrottled(spellID)) or 
            (event == 'SPELL_INTERRUPT' and interruptList[spellID])) then
                self:playSpell(spellID)
        end
    end
end

