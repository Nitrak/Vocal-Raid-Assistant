local addonName, addon = ...
addon.version = GetAddOnMetadata(addonName, "Version")

VRA = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceConsole-3.0", "AceEvent-3.0")
VRA.L = LibStub("AceLocale-3.0"):GetLocale(addonName)
VRA.AC = LibStub("AceConfig-3.0")
VRA.ACD = LibStub("AceConfigDialog-3.0")
VRA.ACR = LibStub("AceConfigRegistry-3.0")
VRA.ACDBO = LibStub("AceDBOptions-3.0")
VRA.EXP = LibStub("AceSerializer-3.0")
VRA.LDS = nil
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
	local msg = string.format("Missing translations for %s. Can you help? Visit https://t.ly/VRA-LOCAL or ask us on Discord for more info.", locales[L])
	C_Timer.After(30, function() addon:prettyPrint(msg) end)
end

local tostring = tostring
local pairs = pairs
local GetTime = GetTime

local profile = {}
local registeredSoundpacks = {}
local throttleTime = {
	['sound'] = GetTime(),
	['msg'] = GetTime()
}

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

function VRA:RegisterSoundpack(name, player)
	if registeredSoundpacks[name] then
		error('Soundpack already exist!')
	elseif type(player) ~= "function" then
		error('Check soundpacks callback!')
	end
	registeredSoundpacks[name] = player
end

function VRA:GetRegisteredSoundpacks()
	local t = {}
	for k,_ in pairs(registeredSoundpacks) do
		t[k] = k
	end
	return t
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
			if addon:IsSpellSupported(spellID) == nil then
				db.profiles.general.area[zone].spells[tostring(spellID)] = nil
				addon:prettyPrint(format("Removed unsupported spell %s from config", spellID))
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
		addon:prettyPrint(VRA.L["Config Cleaning Error Message"])
		self.db:ResetDB("Default")
	end

	if(self:IsRetail()) then
		self.LDS = LibStub('LibDualSpec-1.0')
		self.LDS:EnhanceDatabase(self.db, addonName)
	end

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

local function isThrottled(type)
	local now = GetTime()
	if now > throttleTime[type] then
		throttleTime[type] = now + ((type == 'sound') and profile.sound.throttle or addon.MSG_DELAY_SECONDS)
		return false
	end
	return true
end


local function playSpell(spellID)
	local channel = profile.sound.channel
	local player = registeredSoundpacks[profile.sound.soundpack]
	if player then
		local success = player(spellID, channel)
		if not success then
			local cvarName ='Sound_Enable'..(channel == "Sound" and 'SFX' or channel)
			local errorMsg = nil
			if GetCVar("Sound_EnableAllSound") == "0" then
				errorMsg = format('Can not play sounds, your gamesound (Master channel) is disabled')
			elseif GetCVar(cvarName) == "0" then
				errorMsg = format("Can not play sounds, you configured VRA to play sounds via channel \"%s\", but %s channel is disabled.", channel, channel)
			else
				errorMsg = format("Missing soundfile for configured spell: %s, Voice Pack: %s", GetSpellInfo(spellID), profile.sound.soundpack)
			end
			if errorMsg and not isThrottled('msg') then
				addon:prettyPrint(errorMsg)
			end
		end
	end
end

function VRA:playSpell(spellID)
	playSpell(spellID)
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
				(not profile.general.onlySelf or (profile.general.onlySelf and checkSpellTarget(destFlags, destGUID))) and
				not isThrottled('sound') and addon:IsSpellSupported(spellID)) then
				playSpell(spellID)
		elseif (event == 'SPELL_INTERRUPT' and profile.general.area[instanceType].enableInterrupts) then
				playSpell('countered')
		end
	end
end

