local addonName, addon = ...
addon.version = GetAddOnMetadata(addonName, "Version")

VRA = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceConsole-3.0", "AceEvent-3.0")
VRA.L = LibStub("AceLocale-3.0"):GetLocale(addonName)
VRA.AC = LibStub("AceConfig-3.0")
VRA.ACD = LibStub("AceConfigDialog-3.0")
VRA.ACR = LibStub("AceConfigRegistry-3.0")
VRA.ACDBO = LibStub("AceDBOptions-3.0")
VRA.EXP = LibStub("AceSerializer-3.0")
VRA.LDS = LibStub('LibDualSpec-1.0')

local tostring = tostring
local profile = {}
local throttleTime
local interruptList = {}
local filter = 0

local VRA_CHANNEL = {
	["Master"] = "Master",
	["SFX"] = "Sound",
	["Ambience"] = "Ambience",
	["Music"] = "Music",
	["Dialog"] = "Dialog"
}

local defaultSpells = {
	["217832"] = true,
	["2825"] = true,
	["323673"] = true,
	["111771"] = true,
	["32182"] = true,
	["16191"] = true,
	["1022"] = true,
	["322109"] = true,
	["116849"] = true,
	["326860"] = true,
	["109964"] = true,
	["871"] = true,
	["12975"] = true,
	["64843"] = true,
	["115310"] = true,
	["49576"] = true,
	["98008"] = true,
	["178207"] = true,
	["2094"] = true,
	["324386"] = true,
	["310454"] = true,
	["106898"] = true,
	["246287"] = false,
	["48707"] = true,
	["196718"] = true,
	["328231"] = true,
	["193530"] = true,
	["118"] = true,
	["320674"] = true,
	["61336"] = true,
	["325013"] = true,
	["190319"] = true,
	["86949"] = true,
	["62618"] = true,
	["31821"] = true,
	["13750"] = true,
	["23920"] = true,
	["102342"] = true,
	["33206"] = true,
	["323764"] = true,
	["740"] = true,
	["108280"] = true,
	["642"] = true,
	["114052"] = true,
	["64901"] = true,
	["30283"] = false,
	["115078"] = true,
	["51052"] = true,
	["316958"] = true,
}

VRA.defaultSpells = defaultSpells

local defaults = {
	profile = {
		general = {
			area = {
				arena = { spells = defaultSpells },
				none = { spells = defaultSpells },
				party = { enabled = true, enableInterrupts = true, spells = defaultSpells },
				raid = { enabled = true, enableInterrupts = true, spells = defaultSpells },
				pvp = { spells = defaultSpells },
				scenario = { spells = defaultSpells }
			},
			watchFor = 6 -- COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID,
		},
		sound = {
			soundpack = "en-US-SaraNeural",
			throttle = 0.5,
			channel = "Master"
		},
	}
}

function VRA:InitializeOptions()
	self:RegisterChatCommand("vra", "ChatCommand")
	self:RegisterChatCommand("vocalraidassistant", "ChatCommand")
	local optionsFrame = CreateFrame("Frame", nil, UIParent)
	optionsFrame.name = "VocalRaidAssistant"

	local title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("Vocal Raid Assistant")

	local context = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	context:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	context:SetText(VRA.L["Type /vra open the option panel"])

	local button = CreateFrame("BUTTON", nil, optionsFrame, "UIPanelButtonTemplate")
	button:SetText("Options")
	button:SetSize(177,24)
	button:SetPoint('TOPLEFT', optionsFrame, 'TOPLEFT', 20, -55)
	button:SetScript("OnClick", function(self)
		HideUIPanel(InterfaceOptionsFrame)
		HideUIPanel(GameMenuFrame)
		VRA:ChatCommand()
	end)

	InterfaceOptions_AddCategory(optionsFrame)
	self.optionsFrame = optionsFrame

	self.InitializeOptions = nil
end

function VRA:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("VocalRaidAssistantDB", defaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	profile = self.db.profile

	self.LDS:EnhanceDatabase(self.db, addonName)
	self:InitConfigOptions()
	self:InitializeOptions()

	---
	interruptList = self.GetInterruptSpellIds()
end

function VRA:ChangeProfile()
	profile = self.db.profile
	self:RefreshOptions(self.db)
end

function VRA:ChatCommand()
	self.ACD:Open("VocalRaidAssistantConfig")
end

function VRA:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- ### Core
local function allowedZone()
	local _, currentZoneType = IsInInstance()
	return profile.general.area[currentZoneType].enabled
end

local function allowedSubEvent(event)
	return (event == "SPELL_CAST_SUCCESS" or event == "SPELL_INTERRUPT")
end


local function isTrottled()
	if (throttleTime == nil or GetTime() > throttleTime) then
		throttleTime = GetTime() + profile.sound.throttle
		return false
	else
		return true
	end
end

function VRA:playSpell(spellID)
	local soundFile = "Interface\\AddOns\\VocalRaidAssistant\\Sounds\\" .. profile.sound.soundpack .. "\\" .. spellID .. ".ogg"
	if soundFile then
		local success = PlaySoundFile(soundFile, VRA_CHANNEL[profile.sound.channel])
		if not success then
			print(format("VRA - Missing soundfile for configured spell: %s", GetSpellInfo(spellID)))
		end
	end
end

local targetTypePlayer = bit.bor(COMBATLOG_OBJECT_TARGET, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_PLAYER)
local function checkSpellTarget(destFlags, destGUID)
    return destGUID == '' or (bit.band(destFlags, targetTypePlayer) > 0 and destGUID == UnitGUID("player"))
end

function VRA:COMBAT_LOG_EVENT_UNFILTERED(event)
	if (not (event == "COMBAT_LOG_EVENT_UNFILTERED" and allowedZone())) then
    return
  end

  local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName,
        destFlags, destFlags2, spellID, spellName = CombatLogGetCurrentEventInfo()
  
  if ((allowedSubEvent(event)) and (bit.band(sourceFlags, profile.general.watchFor) > 0)) then
    local _, instanceType = IsInInstance()
    if ((event == 'SPELL_CAST_SUCCESS' and profile.general.area[instanceType].spells[tostring(spellID)] and not isTrottled()
    and ((not profile.general.onlySelf) or (profile.general.onlySelf and checkSpellTarget(destFlags, destGUID)))) or 
    (event == 'SPELL_INTERRUPT' and profile.general.area[instanceType].enableInterrupts and interruptList[spellID])) then
      self:playSpell(spellID)
      end
  end
end

