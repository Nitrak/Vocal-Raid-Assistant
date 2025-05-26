-- Config/FilterUtils.lua
local addonName, addon = ...

function addon:indexOf(array, value)
	for i, v in ipairs(array) do
		if v == value then return i end
	end
	return nil
end

function addon:setFilterValue(info, val)
	local filter = addon.FILTER_VALUES[info]
	if filter then
		if val then
			addon.profile.general.watchFor = bit.bor(addon.profile.general.watchFor, filter)
		else
			addon.profile.general.watchFor = bit.band(addon.profile.general.watchFor, bit.bnot(filter))
		end
	end
end

function addon:getFilterValue(info)
	local filter = addon.FILTER_VALUES[info]
	return filter and (bit.band(addon.profile.general.watchFor, filter) == filter)
end

function addon:getSpellOption(info)
	return addon.profile.general.area[info[2]].spells[info[#info]]
end

function addon:setSpellOption(info, val)
	addon.profile.general.area[info[2]].spells[info[#info]] = val
	if val then
		local spellID = addon.spellCorrections[tonumber(info[#info])] or info[#info]
		addon:playSpell(spellID, true)
	end
end
