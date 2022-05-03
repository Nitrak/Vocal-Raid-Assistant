local addonName, addon = ...
local format = format

local path = "Interface\\AddOns\\" .. addonName .. "\\sounds\\%s.ogg"

local function handler(spellID, channel)
	return PlaySoundFile(format(path, spellID), channel)
end

VRA.RegisterSoundpack(self, addonName, handler)
