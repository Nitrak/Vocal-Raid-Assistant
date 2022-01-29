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

local tostring = tostring
local profile = {}
local throttleTime
local interruptList = {}
local filter = 0


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
	self.db = LibStub("AceDB-3.0"):New("VocalRaidAssistantDB", addon.DEFAULTS, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	profile = self.db.profile
	
	--Minimap Icon and Broker
	local MyLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(addonName, {
	type = "launcher",
	icon = "Interface\\COMMON\\VoiceChat-Speaker",
	OnClick = function(clickedframe, button)
		self:ChatCommand()
	end,
	OnTooltipShow = function(tooltip)
          tooltip:SetText(VRA.L["VRANAME"])
          tooltip:Show()
     end,
	})
	VRA.ICON:Register(addonName, MyLDB, profile.general.minimap)

	self.LDS:EnhanceDatabase(self.db, addonName)
	self:InitConfigOptions()
	self:InitializeOptions()
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
	local soundFile = "Interface\\AddOns\\VocalRaidAssistant\\Sounds\\" .. profile.sound.soundpack .. "\\" .. spellID .. ".ogg"
	if soundFile then
		local success = PlaySoundFile(soundFile, addon.SOUND_CHANNEL[profile.sound.channel])
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

	-- apply spell correction (e.g. hex and polymorh change the spellID)
	spellID = addon.spellCorrections[spellID] or spellID

	if ((allowedSubEvent(event)) and (bit.band(sourceFlags, profile.general.watchFor) > 0)) then
	local _, instanceType = IsInInstance()
	if ((event == 'SPELL_CAST_SUCCESS' and profile.general.area[instanceType].spells[tostring(spellID)] and not isTrottled()
	and ((not profile.general.onlySelf) or (profile.general.onlySelf and checkSpellTarget(destFlags, destGUID)))) or
	(event == 'SPELL_INTERRUPT' and profile.general.area[instanceType].enableInterrupts and addon.interruptList[spellID])) then
		self:playSpell(spellID)
		end
	end
end

