-- Config/PopUps.lua
local addonName, addon = ...
local AceGUI = addon.AG
local IEDialog

local function constructIEDialog()
	local ieContainer = AceGUI:Create("Frame")
	ieContainer:SetLayout("Fill")

	local input = AceGUI:Create("MultiLineEditBox")
	input:SetLabel("")
	input.frame:SetClipsChildren(true)
	ieContainer:AddChild(input)

	-- Ensure the import button always starts disabled
	input.button:SetScript("OnShow", function(self)
		self:Disable()
	end)

	function ieContainer.Open(self, area, text)
		if text then
			-- EXPORT
			self:SetTitle("Export")
			input.button:Hide()
			input:SetText(text)
			input.editBox:HighlightText()
			input:SetFocus()
		else
			-- IMPORT
			self:SetTitle("Import")
			input:SetText("")
			input:SetFocus()
			input.button:Show()
			input.button:SetText("Import")
			--input.button:Disable()

			input.editBox:SetScript("OnTextChanged", function()
				local paste = input:GetText()
				if paste and #paste > 0 then
					input.button:Enable()
					input.button:SetScript("OnClick", function()
						addon:importSpellSelection(tostring(paste), area)
						input.button:Disable()
						ieContainer:Close()
					end)
				else
        			input.button:Disable()
				end
			end)
			input.editBox:SetScript("OnEscapePressed", function()
				 ieContainer:Close()
			end)
		end
		self:Show()
	end

	function ieContainer.Close(self)
		input:ClearFocus()
		input:SetText("")
		self:Hide()
	end

	return ieContainer
end


function addon:showIEDialog(area, text)
	if not IEDialog then
		IEDialog = constructIEDialog()
	end
	IEDialog:Open(area, text)
end
