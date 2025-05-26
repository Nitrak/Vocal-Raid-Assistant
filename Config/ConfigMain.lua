-- Config/ConfigMain.lua
local _, addon = ...

local mainOptions = {
	name = "Vocal Raid Assistant",
	type = "group",
	args = {
		generalOptions = addon.ConfigGeneralOptions,
		abilitiesOptions = addon.ConfigAbilitiesOptions
	}
}

function addon:InitConfigOptions()
	mainOptions.args.profiles = self.ACDBO:GetOptionsTable(self.db)
	if not self:IsClassic() then
		addon.LDS:EnhanceOptions(mainOptions.args.profiles, self.db)
	end
	addon.AC:RegisterOptionsTable("VocalRaidAssistantConfig", mainOptions)
	addon.ACD:SetDefaultSize("VocalRaidAssistantConfig", 965, 650)
end
