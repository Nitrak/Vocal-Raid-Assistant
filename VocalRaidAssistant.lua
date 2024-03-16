local addonName, addon = ...
local getAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
addon.version = getAddOnMetadata(addonName, "Version")

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
	local msg = string.format("Missing translations for %s. Can you help? Visit https://tinyurl.com/VRA-LOCAL or ask us on Discord for more info."
		, locales[L])
	C_Timer.After(30, function() addon:prettyPrint(msg) end)
end

local pairs = pairs

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

	for profileKey, profile in pairs(db.profiles) do
		if profile['version'] == nil or profile['version'] ~= addon.DATABASE_VERSION then
			-- Remove invalid keys
			for key, _ in pairs(profile) do
				if addon.DEFAULTS.profile[key] == nil then
					profile[key] = nil
				end
			end
			-- Remove invalid spells
			for zone, _ in pairs(addon.ZONES) do
				if profile.general and profile.general.area[zone] and profile.general.area[zone].spells then
					for spellID, _ in pairs(profile.general.area[zone].spells) do
						if not addon:IsSpellSupported(tonumber(spellID)) then
							profile.general.area[zone].spells[spellID] = nil
							addon:prettyPrint(format("Removed unsupported spell %s from config", spellID))
						end
					end
				end
			end
			profile.version = addon.DATABASE_VERSION
		end
	end
end

function VRA:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("VocalRaidAssistantDB", addon.DEFAULTS)
	self.db.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	self.profile = self.db.profile

	-- Minimap Icon and Broker
	addon.ICON:Register(addonName, addon.LDB:NewDataObject(addonName, addon.ICONCONFIG), self.profile.general.minimap)

	if not pcall(ConfigCleanup, self.db) then
		addon:prettyPrint(VRA.L["Config Cleaning Error Message"])
		self.db:ResetDB("Default")
	end

	if (self:IsRetail()) then
		AddonCompartmentFrame:RegisterAddon({
			text = addonName,
			icon = "Interface\\AddOns\\VocalRaidAssistant\\Media\\icon",
			func = function() VRA:ChatCommand() end,
			registerForAnyClick = true,
			notCheckable = true,
		})
	end

	if (self:IsRetail() or self:IsWrath()) then
		self.LDS = LibStub('LibDualSpec-1.0')
		self.LDS:EnhanceDatabase(self.db, addonName)
	end

	self:InitConfigOptions()
	self:InitializeOptions()
end

function VRA:ChangeProfile()
	self.profile = self.db.profile
end

function VRA:ChatCommand(msg)
	if (msg == "debug") then
		local _, instanceType = IsInInstance()
		for spellID, _ in pairs(self.profile.general.area[instanceType].spells) do
			print(instanceType, spellID, addon:IsSpellSupported(tonumber(spellID)))
		end
	else
		if self.ACD.OpenFrames["VocalRaidAssistantConfig"] then
			self.ACD:Close("VocalRaidAssistantConfig")
		else
			self.ACD:Open("VocalRaidAssistantConfig")
		end
	end
end

function VRA:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	addon:verifySoundPack()
end
