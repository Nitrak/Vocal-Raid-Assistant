-- Config/ConfigMain.lua
local _, addon = ...

local mainOptions = {
	name = "Vocal Raid Assistant",
	type = "group",
	args = {
		generalOptions = addon.ConfigGeneralOptions
	}
}

local CONFIG_NAME = "VocalRaidAssistantConfig"
function addon:InitConfigOptions()
	mainOptions.args.profiles = self.ACDBO:GetOptionsTable(self.db)
	self.LDS:EnhanceOptions(mainOptions.args.profiles, self.db)
	self.AC:RegisterOptionsTable(CONFIG_NAME, mainOptions)
	self.ACD:SetDefaultSize(CONFIG_NAME, 965, 650)
end
