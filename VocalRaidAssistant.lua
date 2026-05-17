local addonName, addon = ...
local getAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
addon.version = getAddOnMetadata(addonName, "Version")

VRA = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceConsole-3.0", "AceEvent-3.0")
VRA.L = LibStub("AceLocale-3.0"):GetLocale(addonName)
VRA.AC = LibStub("AceConfig-3.0")
VRA.ACD = LibStub("AceConfigDialog-3.0")
--VRA.AG = LibStub("AceGUI-3.0")
VRA.ACR = LibStub("AceConfigRegistry-3.0")
VRA.ACDBO = LibStub("AceDBOptions-3.0")
VRA.ICON = LibStub("LibDBIcon-1.0")
VRA.LDB = LibStub:GetLibrary("LibDataBroker-1.1")


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

	if InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(optionsFrame)
	else
		local category, layout = Settings.RegisterCanvasLayoutCategory(optionsFrame, optionsFrame.name);
		Settings.RegisterAddOnCategory(category);
	end
	self.optionsFrame = optionsFrame

	self.InitializeOptions = nil
end

local function ConfigCleanup(db)
	for profileKey, profile in pairs(db.profiles) do
		local version = profile['version']
		if version == nil or version < addon.DATABASE_VERSION then
            if (version or 0) < 8 then
                -- Hard reset: wipe and re-apply defaults for this profile
                for k in pairs(profile) do
                    profile[k] = nil
                end
                for k, v in pairs(addon.DEFAULTS.profile) do
                    profile[k] = v
                end
            end
            -- Always stamp the version after migration
            profile['version'] = addon.DATABASE_VERSION
        end
	end
end

function VRA:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("VocalRaidAssistantDB", addon.DEFAULTS)
	self.db.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ChangeProfile")

	if not pcall(ConfigCleanup, self.db) then
		addon:prettyPrint(VRA.L["Config Cleaning Error Message"])
		self.db:ResetDB()
	end

	self.profile = self.db.profile

	-- Minimap Icon and Broker
	addon.ICON:Register(addonName, addon.LDB:NewDataObject(addonName, addon.ICONCONFIG), self.profile.general.minimap)



	AddonCompartmentFrame:RegisterAddon({
		text = addonName,
		icon = "Interface\\AddOns\\VocalRaidAssistant\\Media\\icon",
		func = function() VRA:ChatCommand() end,
		registerForAnyClick = true,
		notCheckable = true,
	})

	self.LDS = LibStub('LibDualSpec-1.0')
	self.LDS:EnhanceDatabase(self.db, addonName)
	self:InitConfigOptions()
	self:InitializeOptions()
end

function VRA:ChangeProfile()
	self.profile = self.db.profile
end

function VRA:ChatCommand(msg)
	if self.ACD.OpenFrames["VocalRaidAssistantConfig"] then
		self.ACD:Close("VocalRaidAssistantConfig")
	else
		self.ACD:Open("VocalRaidAssistantConfig")
	end
end

function VRA:OnEnable()
	addon:verifySoundPack()
end
