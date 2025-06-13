-- Config/Popups.lua
local addonName, addon = ...
local L = addon.L

StaticPopupDialogs["VRA_IMPORT"] = {
	text = L["Insert import string"],
	button1 = L["Import"],
	button2 = L["Cancel"],
	timeout = 0,
	OnAccept = function(self, data)
		VRA.importSpellSelection(self.editBox:GetText(), data)
		addon.popUpSemaphore = false
	end,
	OnCancel = function()
		addon.popUpSemaphore = false
	end,
	hasEditBox = true,
	whileDead = true,
	preferredIndex = 3
}

StaticPopupDialogs["VRA_EXPORT"] = {
	text = L["Export string (Ctrl-C)"],
	button1 = L["Close"],
	timeout = 0,
	OnAccept = function()
		addon.popUpSemaphore = false
	end,
	hasEditBox = true,
	whileDead = true,
	preferredIndex = 3
}
