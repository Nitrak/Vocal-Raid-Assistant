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
VRA.ICON = LibStub("LibDBIcon-1.0")
VRA.LDB = LibStub:GetLibrary("LibDataBroker-1.1")
VRA.WAGO = LibStub("WagoAnalytics"):Register("kRNLr8Ko")

local L = GetLocale()
local locales = {
	--ruRU = "Russian (ruRU)",
	--itIT = "Italian (itIT)",
	koKR = "Korean (koKR)",
	esES = "Spanish (esES)",
	esMX = "Spanish (esMX)",
	--deDE = "German (deDE)",
	ptBR = "Portuguese (ptBR)",
	frFR = "French (frFR)",
	--zhCN = "Chinese (zhCN)",
	--zhTW = "Chinese (zhTW)",
}
if locales[L] then
	print(string.format("Vocal Raid Assistant is missing translations for %s. Can you help? Visit https://t.ly/VRA-LOCAL or ask us on Discord for more info.",locales[L]))
end

local tostring = tostring
local profile = {}
local throttleTime

function VRA:InitializeOptions()
	self:RegisterChatCommand("vra", "ChatCommand")
	self:RegisterChatCommand("vocalraidassistant", "ChatCommand")
	local optionsFrame = CreateFrame("Frame", "VRAOptionsFrame", UIParent)
	optionsFrame.name = "VocalRaidAssistant"

	local title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("Vocal Raid Assistant")

	local context = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	context:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	context:SetText(VRA.L["Type /vra open the option panel"])

	local button = CreateFrame("BUTTON", nil, optionsFrame, "UIPanelButtonTemplate")
	button:SetText("Options")
	button:SetSize(177, 24)
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

local function ConfigCleanup(db)
	if (db.profiles.version == addon.DATABASE_VERSION) then
		return
	end
	for k, v in pairs(db.profiles) do
		if v['version'] == nil or v['version'] ~= addon.DATABASE_VERSION then
			for key, _ in pairs(v) do
				if addon.DEFAULTS.profile[key] == nil then
					v[key] = nil
				end
			end
			v.version = addon.DATABASE_VERSION
		end
	end
	for zone, _ in pairs(addon.ZONES) do
		for spellID, _ in pairs(addon.GetAllSpellIds()) do
			-- remove invalid spells in config
			if addon.IsSpellSupported(spellID) == nil then
				db.profiles.general.area[zone].spells[tostring(spellID)] = nil
				print(format("VRA - removed unsupported spell %s from config", spellID))
			end
		end
	end
end

--- Function to aggregate analytics for boolean settings
-- Instead of monitoring every change made, once a client loads in or
-- a reload has occurred the settings will be logged if the player
-- has opted into the Wago Analytics in the WagoApp.
local function VRAAnalytics(addon, profile)
	--Soundpack
	for k,v in pairs(addon.SOUND_PACKS) do
		VRA.WAGO:Switch("SP: "..v,k == profile.sound.soundpack)
	end

	--Sound channel
	local soundChannels = {
		["Master"] = "Master",
		["SFX"] = "Sound",
		["Ambience"] = "Ambience",
		["Music"] = "Music",
		["Dialog"] = "Dialog"
	}
	for k,v in pairs(soundChannels) do
		VRA.WAGO:Switch("SC: "..v,k == profile.sound.channel)
	end

	--Settings
	VRA.WAGO:Switch("Hear own abilities",profile.general.watchFor == 1)
	VRA.WAGO:Switch("Minimap Button", not profile.general.minimap.hide)
	VRA.WAGO:Switch("Only self", profile.general.onlySelf)
end

function VRA:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("VocalRaidAssistantDB", addon.DEFAULTS)
	self.db.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	profile = self.db.profile

	-- Minimap Icon and Broker
	addon.ICON:Register(addonName, addon.LDB:NewDataObject(addonName, addon.ICONCONFIG), profile.general.minimap)
	if not pcall(ConfigCleanup, self.db) then
		print(VRA.L["Config Cleaning Error Message"])
		self.db:ResetDB("Default")
	end

	self.LDS:EnhanceDatabase(self.db, addonName)
	self:InitConfigOptions()
	self:InitializeOptions()

	VRAAnalytics(addon,profile)
end

function VRA:ChangeProfile()
	profile = self.db.profile
	self:RefreshOptions(self.db)
end

function VRA:ChatCommand()
	if self.ACD.OpenFrames["VocalRaidAssistantConfig"] then
		self.ACD:Close("VocalRaidAssistantConfig")
	else
		self.ACD:Open("VocalRaidAssistantConfig")
	end
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
	local soundFile = "Interface\\AddOns\\VocalRaidAssistant\\Sounds\\" .. profile.sound.soundpack .. "\\" .. spellID ..
									".ogg"
	if soundFile then
		local success = PlaySoundFile(soundFile, addon.SOUND_CHANNEL[profile.sound.channel])
		if not success and GetCVar("Sound_EnableAllSound") ~= "0" and spellID ~= 'countered' then
			print(format("VRA - Missing soundfile for configured spell: %s, Voice Pack: %s", GetSpellInfo(spellID),profile.sound.soundpack))
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

	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags,
					destFlags2, spellID, spellName = CombatLogGetCurrentEventInfo()

	-- apply spell correction (e.g. hex and polymorh change the spellID)
	spellID = addon.spellCorrections[spellID] or spellID

	if ((allowedSubEvent(event)) and (bit.band(sourceFlags, profile.general.watchFor) > 0)) then
		local _, instanceType = IsInInstance()
		if (event == 'SPELL_CAST_SUCCESS' and profile.general.area[instanceType].spells[tostring(spellID)] and
			not isTrottled() and
			(not profile.general.onlySelf or (profile.general.onlySelf and checkSpellTarget(destFlags, destGUID))) and
			addon.IsSpellSupported(spellID)) then
				self:playSpell(spellID)
		elseif (event == 'SPELL_INTERRUPT' and profile.general.area[instanceType].enableInterrupts) then
			self:playSpell('countered')
		end
	end
end

