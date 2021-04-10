local VRA = VocalRaidAssistant
local TIMER = timers
local vradb
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("VocalRaidAssistant")
local LSM = LibStub("LibSharedMedia-3.0")
local rosterInfoArray = {}
local rosterStatusArray = {}
local rosterStatusOldArray = {}
local rosterNameArray = {}
local rosterClassArray = {}
local testnull = 0
local testingactive = false
local first = true
local raidMaxSize = 40
local activeBarsArray = {}
local activeBars = 0
local activeMove = 0
local playerSpell = {}
local locked = false
local activeOBarsArray = {}
local activeOBars = 0
local activeOMove = 0
local playerOSpell = {}
local lockedO = false
local activeBBarsArray = {}
local activeBBars = 0
local activeBMove = 0
local playerBSpell = {}
local lockedB = false


local function newSpellTable(data)
	local t = {}
	if type(data) == "table" then 
		for k, v in pairs(data) do
			t[k] = v
		end
	else
		t.type = "custom"
	end
	t.enable = true
	return t
end

function VRA:InitDB()
	vradb = self.db1.profile
	local data = self:GetBarData()
	if type(data) == "table" then 
		for k, v in pairs(data) do
			k = tostring(k)
			vradb.spells[k] = newSpellTable(v)
			self:AddDataOption(k)
		end
	end
	
	for k, v in pairs(vradb.spells) do
		self:AddDataOption(k)
	end		
	for k, v in pairs(vradb.spells) do
		if v.type ~= "custom" then
			--vradb.spells[k] = nil
		end
	end
	
	local data = self:GetBarDataO()
	if type(data) == "table" then 
		for k, v in pairs(data) do
			k = tostring(k)
			vradb.spellsO[k] = newSpellTable(v)
			self:AddDataOOption(k)
		end
	end
	
	
	for k, v in pairs(vradb.spellsO) do
		self:AddDataOOption(k)
	end		
	for k, v in pairs(vradb.spellsO) do
		if v.type ~= "custom" then
			--vradb.spellsO[k] = nil
		end
	end
	
	local data = self:GetBarDataB()
	if type(data) == "table" then 
		for k, v in pairs(data) do
			k = tostring(k)
			vradb.spellsB[k] = newSpellTable(v)
			self:AddDataBOption(k)
			
			
		end
	end
	
	
	for k, v in pairs(vradb.spellsB) do
		self:AddDataBOption(k)
	end		
	for k, v in pairs(vradb.spellsB) do
		if v.type ~= "custom" then
			--vradb.spellsB[k] = nil
		end
	end
	
	

end

function VRA:class(name)
	local nameL,classL

	for i=1,raidMaxSize do
		if GetRaidRosterInfo(i) ~= nil then
			nameL, _, _, _, classL, _, _, _, _, _, _ = GetRaidRosterInfo(i) 
			if name == nameL then
				return classL
			end
		end
	end
end

function VRA:classColor(class)
	if(class=="Death Knight") then return "|cffC41F3B"
	elseif(class=="Demon Hunter") then return "|cffA330C9"
	elseif(class=="Druid") then return "|cffFF7D0A"
	elseif(class=="Hunter") then return "|cffABD473"
	elseif(class=="Mage") then return "|cff69CCF0"
	elseif(class=="Monk") then return "|cFF558A84"
	elseif(class=="Paladin") then return "|cffF58CBA"
	elseif(class=="Priest") then return "|cffFFFFFF"
	elseif(class=="Rogue") then return "|cffFFF569"
	elseif(class=="Shaman") then return "|cff0070da"
	elseif(class=="Warlock") then return "|cff9482C9"
	elseif(class=="Warrior") then return "|cffC79C6E"
	else return "" end
end

local function RGBClass(name)
	local class = VRA:class(name)
	
	if(class==nil) then
		class = UnitClass(name)
	end
	
	if(class=="Death Knight") then return "0.77,0.12,0.23"
	elseif(class=="Demon Hunter") then return "0.64,0.19,0.79"
	elseif(class=="Druid") then return "1.00,0.49,0.04"
	elseif(class=="Hunter") then return "0.67,0.83,0.45"
	elseif(class=="Mage") then return "0.41,0.80,0.94"
	elseif(class=="Monk") then return "0.33,0.54,0.52"
	elseif(class=="Paladin") then return "0.96,0.55,0.73"
	elseif(class=="Priest") then return "1.00,1.00,1.00"
	elseif(class=="Rogue") then return "1.00,0.96,0.41"
	elseif(class=="Shaman") then return "0.00,0.44,0.87"
	elseif(class=="Warlock") then return "0.58,0.51,0.79"
	elseif(class=="Warrior") then return "0.78,0.61,0.43"
	else return "" end

end

local function RGBClassTEST(class)
		
	if(class=="Death Knight") then return "0.77,0.12,0.23"
	elseif(class=="Demon Hunter") then return "0.64,0.19,0.79"
	elseif(class=="Druid") then return "1.00,0.49,0.04"
	elseif(class=="Hunter") then return "0.67,0.83,0.45"
	elseif(class=="Mage") then return "0.41,0.80,0.94"
	elseif(class=="Monk") then return "0.33,0.54,0.52"
	elseif(class=="Paladin") then return "0.96,0.55,0.73"
	elseif(class=="Priest") then return "1.00,1.00,1.00"
	elseif(class=="Rogue") then return "1.00,0.96,0.41"
	elseif(class=="Shaman") then return "0.00,0.44,0.87"
	elseif(class=="Warlock") then return "0.58,0.51,0.79"
	elseif(class=="Warrior") then return "0.78,0.61,0.43"
	else return "" end

end


function VRA:getBarX()
   return vradb.barX
end

function VRA:setBarX(newValue)
    vradb.barX = newValue
end

function VRA:getBarY()
   return vradb.barY
end

function VRA:setBarY(newValue)
    vradb.barY = newValue
end

function VRA:getHeightX()
   return vradb.heightX
end

function VRA:setHeightX(newValue)
    vradb.heightX = newValue
end

function VRA:getBarWidth()
   return vradb.barWidth
end

function VRA:getBarHeight()
	return vradb.barHeight
end

function VRA:getFontSize()
	return vradb.fontSize
end

function VRA:getFontType()
	return vradb.fontType
end

function VRA:getPulseStart()
	return vradb.pulseStart
end

function VRA:getPulseIntensity()
	return vradb.pulseIntensity
end

function VRA:getBarTexture()
	return vradb.barTexture
end

function VRA:SetFont(font)
	
	return LSM:Fetch("font", font, true)
    
end

function VRA:SetTexture(texture)
	
	return LSM:Fetch("statusbar", texture, true)
    
end


function VRA:getOBarX()
   return vradb.obarX
end

function VRA:setOBarX(newValue)
    vradb.obarX = newValue
end

function VRA:getOBarY()
   return vradb.obarY
end

function VRA:setOBarY(newValue)
    vradb.obarY = newValue
end

function VRA:getOHeightX()
   return vradb.oheightX
end

function VRA:setOHeightX(newValue)
    vradb.oheightX = newValue
end

function VRA:getOBarWidth()
   return vradb.obarWidth
end

function VRA:getOBarHeight()
	return vradb.obarHeight
end

function VRA:getOFontSize()
	return vradb.ofontSize
end

function VRA:getOFontType()
	return vradb.ofontType
end

function VRA:getOBarTexture()
	return vradb.obarTexture
end


function VRA:getBBarX()
   return vradb.bbarX
end

function VRA:setBBarX(newValue)
    vradb.bbarX = newValue
end

function VRA:getBBarY()
   return vradb.bbarY
end

function VRA:setBBarY(newValue)
    vradb.bbarY = newValue
end

function VRA:getBHeightX()
   return vradb.bheightX
end

function VRA:setBHeightX(newValue)
    vradb.bheightX = newValue
end

function VRA:getBBarWidth()
   return vradb.bbarWidth
end

function VRA:getBBarHeight()
	return vradb.bbarHeight
end

function VRA:getBFontSize()
	return vradb.bfontSize
end

function VRA:getBFontType()
	return vradb.bfontType
end

function VRA:getBBarTexture()
	return vradb.bbarTexture
end



function VRA:SetFont(font)
	
	return LSM:Fetch("font", font, true)
    
end

function VRA:SetTexture(texture)
	
	return LSM:Fetch("statusbar", texture, true)
    
end

local function convertTime(t)
	
	local minute = math.floor(t/60)
	local seconds = math.floor((t/60-minute)*60)
	
	if(seconds<10) then
		return minute..":0"..seconds
	else
		return minute..":"..seconds
	end
end



local function ArraySize(array)

	local Count = 0
	for Index, Value in pairs( array ) do
		Count = Count + 1
	end
	
	return Count

end

function VRA:modifyBars()
	
	if(vradb.growthDirection) then
		for i=1,activeBars do
			activeBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBarX(),i*VRA:getBarHeight()+VRA:getBarY())
		end
	else
		for i=1,activeBars do
			activeBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBarX(),-i*VRA:getBarHeight()+VRA:getBarY())
		end
	end

end

function VRA:modifyOBars()
	
	if(vradb.ogrowthDirection) then
		for i=1,activeOBars do
			activeOBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),i*VRA:getOBarHeight()+VRA:getOBarY())
		end
	else
		for i=1,activeOBars do
			activeOBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),-i*VRA:getOBarHeight()+VRA:getOBarY())
		end
	end

end

function VRA:modifyBBars()
	
	if(vradb.bgrowthDirection) then
		for i=1,activeBBars do
			activeBBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),i*VRA:getBBarHeight()+VRA:getBBarY())
		end
	else
		for i=1,activeBBars do
			activeBBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),-i*VRA:getBBarHeight()+VRA:getBBarY())
		end
	end

end








function VRA:MoveBBar(name,duration)
	if(activeBMove == 0) then
		lockedB = true
		activeBMove = 1
		
		--Clearing cooldowns
		for i,j in pairs(playerBSpell) do
			playerBSpell[i]=""
		end
		
		for i=1,activeBBars do
			activeBBarsArray[i]:Hide()
		end
		
		activeBBars = 0
		
		activeBBars = activeBBars+1
		activeBBarsArray[activeBBars] = CreateFrame("StatusBar", nil, UIParent)
		
		local text = activeBBarsArray[activeBBars]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		text:SetPoint("CENTER",activeBBarsArray[activeBBars],"CENTER")
		text:SetText(name)
		text:SetFont(VRA:SetFont(VRA:getBFontType()), VRA:getBFontSize(), "OUTLINE")
		
		activeBBarsArray[activeBBars]:SetStatusBarTexture(VRA:SetTexture(VRA:getBBarTexture()))
		activeBBarsArray[activeBBars]:GetStatusBarTexture():SetHorizTile(false)
		activeBBarsArray[activeBBars]:SetMinMaxValues(0, duration)
		activeBBarsArray[activeBBars]:SetValue(100)
		activeBBarsArray[activeBBars]:SetWidth(VRA:getBBarWidth())
		activeBBarsArray[activeBBars]:SetHeight(VRA:getBBarHeight())
		if(vradb.growthDirection) then
			activeBBarsArray[activeBBars]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),activeBBars*VRA:getBBarHeight()+VRA:getBBarY())
		else
			activeBBarsArray[activeBBars]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),-activeBBars*VRA:getBBarHeight()+VRA:getBBarY())
		end
		activeBBarsArray[activeBBars]:SetStatusBarColor(0,1,0)
		
		activeBBarsArray[activeBBars].bg = activeBBarsArray[activeBBars]:CreateTexture(nil, "BACKGROUND")
		activeBBarsArray[activeBBars].bg:SetTexture("Interface\TargetingFrame\UI-StatusBar")
		activeBBarsArray[activeBBars].bg:SetAllPoints(true)
		activeBBarsArray[activeBBars].bg:SetVertexColor(0, 0, 0)
		
		activeBBarsArray[activeBBars]:SetMovable(true)
		activeBBarsArray[activeBBars]:EnableMouse(true)
		activeBBarsArray[activeBBars]:RegisterForDrag("LeftButton")
		activeBBarsArray[activeBBars]:SetScript("OnDragStart", activeBBarsArray[activeBBars].StartMoving)
		activeBBarsArray[activeBBars]:SetScript("OnDragStop", activeBBarsArray[activeBBars].StopMovingOrSizing)
		
		local t = duration
		local HALF_POINT = duration / 2
		activeBBarsArray[activeBBars]:SetScript("OnUpdate", function(bar, elapsed)
			t = t - elapsed
			bar:SetValue(t)
			if t > HALF_POINT then
				bar:SetStatusBarColor(1, t / duration, 0)
			else
				bar:SetStatusBarColor(1 - (t / duration), 1, 0)
			end
			bar:SetWidth(VRA:getBBarWidth())
			bar:SetHeight(VRA:getBBarHeight())
			text:SetFont(VRA:SetFont(VRA:getBFontType()), VRA:getBFontSize(), "OUTLINE")
			activeBBarsArray[activeBBars]:SetStatusBarTexture(VRA:SetTexture(VRA:getBBarTexture()))
			if t < 0.001 then
				activeBBars = activeBBars-1
				for i=1,activeBBars do
					activeBBarsArray[i] = activeBBarsArray[i+1]
				end
				VRA:setBBarX(bar:GetLeft())
				VRA:setBBarY(bar:GetBottom()-VRA:getBBarHeight())
				text:SetText("")
				VRA:modifyBBars()
				bar:Hide()
				activeBMove = 0
				lockedB = false
			end
		end)
	end
end

function VRA:AddDataBOption(spellId)
	
	if not spellId then 
		return
	end
	local name, _, icon = GetSpellInfo(spellId)
	local dbKey = tostring(spellId)
	local db = vradb.spellsB[dbKey]
	if not name then 
		--mod:log(L["spell not exists, id:"] .. spellId)
		vradb.spellsB[dbKey] = nil
		return 
	end	
	local isOriginal = not(( db.type == "custom" or db.type == "premade self" ))
	local op = self.options.args.BuffBar.args
	
	op[dbKey] = {
		type = "group",
		name = function() local s = name if db.type == "custom" then s = "|T" .. icon .. ":18:18:0:0|t " .. " * " .. name end if not db.enable then s = "|T" .. icon .. ":18:18:0:0|t ".."|cffDD1133" .. s .. "|r" end return "|T" .. icon .. ":18:18:0:0|t "..s end,
		icon = nil,
		disabled = function() if(vradb.enableBCooldownBar) then return false else return true end end,
		args = {
			enableb = {
				type = "toggle",
				desc = function() GameTooltip:SetHyperlink(GetSpellLink(spellId)) end,
				descStyle = "custom",
				name = function() if not db.desc or db.desc == "" then return "|T" .. icon .. ":18:18:0:0|t " .. name else return  "|T" .. icon .. ":18:18:0:0|t " .. name ..  " (" .. (db.desc).. ")"  end end,
				set = function(info, value) db.enable = value end,
				get = function() return db.enable end,
				order = 1,
			},
			selfOnlyb = {
				type = "toggle",
				desc = "Only when applied to self",
				name = "Applied to self only",
				disabled = isOriginal,
				set = function(info, value) db.selfOnly = value end,
				get = function() return db.selfOnly end,
				order = 2,
			},
			headerb = {
				type = "header",
				name = "",
				order = 3,
			},
			-- cdo = {
				-- name = "CD",
				-- type = "input",
				-- desc = "In seconds",
				-- get = function() return tostring(db.cd or 0) end,
				-- set = function(info, value) db.cd = tonumber(value) end,
				-- pattern = "^%d+$",
			-- },
			durationb = {
				name = "Duration",
				type = "input",
				desc = "In seconds",
				disabled = db.type ~= "custom",
				get = function() return tostring(db.duration or 0) end,
				set = function(info, value) db.duration = tonumber(value) end,
				pattern = "^%d+$",
			},
			spellIdb = {
				name = "Spell ID",
				type = "input",
				disabled = true,
				get = function() return dbKey end,
				pattern = "^%d+$",
			},
			deleteb = {
				name = "DELETE",
				type = "execute",
				disabled = db.type ~= "custom",
				confirm = true,
				confirmText = "Are you sure to delete the data?",
				func = function()
					local op = self.options.args.BuffBar.args
					local data = self:GetBarDataB()
					local db = vradb.spellsB
					db[dbKey] = nil
					op[dbKey] = nil
				end,
				order = -1,
			},
		},
	}
	if(db.type == "premade self") then
		op[dbKey].args.selfOnlyb.set(_,true)
	end
	
end


local function spellBCooldowns(spellName)
	if(spellName~=nil) then
		local data = VRA:GetBarDataB()

		if type(data) == "table" then 
			for k, v in pairs(data) do
				if(tonumber(spellName)==k) then
					return v.duration
				end
			end
		end
		if(vradb.spellsB[tostring(spellName)]~=nil and not vradb.spellsB[tostring(spellName)].selfOnly) then
			return vradb.spellsB[tostring(spellName)].duration
		end
		return -1
	else
		return -1
	end

	
end


function VRA:spellPBCooldowns(spellName)

	if(spellName~=nil) then
	
		 if(vradb.spellsB[tostring(spellName)]~=nil and vradb.spellsB[tostring(spellName)].selfOnly) then
			 return vradb.spellsB[tostring(spellName)].duration
		 end
	 else
		 return -1
	 end

	
end



function VRA:CreateBBar(player,spell,...)
	if(vradb.spellsB[tostring(spell)]~=nil) then
	if(vradb.spellsB[tostring(spell)].enable) then
	if(not lockedB) then
		local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spell)
		local per = ...
		local PROPOSAL_DURATION = spellBCooldowns(spell)
		
		if(per~="personal" and vradb.spellsB[tostring(spell)].selfOnly) then
		
		else
			if(PROPOSAL_DURATION == -1 and per=="personal") then
				PROPOSAL_DURATION = VRA:spellPBCooldowns(spell)
			end

			local accept = true
			for i,j in pairs(playerBSpell) do
				if(i == player) then
					if(playerBSpell[i]==name) then
						if(not testingactive) then
							accept = false
						end
					end
				end
			end
	
			if(PROPOSAL_DURATION ~= nil and PROPOSAL_DURATION>0 and accept==true and player~=nil) then
			
				activeBBars = activeBBars+1
				activeBBarsArray[activeBBars] = CreateFrame("StatusBar", nil, UIParent)
			
				local text = activeBBarsArray[activeBBars]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
				text:SetPoint("CENTER",activeBBarsArray[activeBBars],"CENTER")
				text:SetFont(VRA:SetFont(VRA:getBFontType()), VRA:getBFontSize(), "OUTLINE")
			
				activeBBarsArray[activeBBars]:SetStatusBarTexture(VRA:SetTexture(VRA:getBBarTexture()))
				activeBBarsArray[activeBBars]:GetStatusBarTexture():SetHorizTile(false)
				activeBBarsArray[activeBBars]:SetMinMaxValues(0, PROPOSAL_DURATION)
				activeBBarsArray[activeBBars]:SetValue(100)
				activeBBarsArray[activeBBars]:SetWidth(VRA:getBBarWidth())
				activeBBarsArray[activeBBars]:SetHeight(VRA:getBBarHeight())
				if(vradb.growthDirection) then
					activeBBarsArray[activeBBars]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),activeBBars*VRA:getBBarHeight()+VRA:getBBarY())
				else
					activeBBarsArray[activeBBars]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),-activeBBars*VRA:getBBarHeight()+VRA:getBBarY())
				end
				
				local classColor
				classColor = RGBClassTEST(player)
				
				
				if(classColor == "") then
					classColor = RGBClass(player)
				end
				
				activeBBarsArray[activeBBars]:SetStatusBarColor(strsub(classColor,1,4),strsub(classColor,6,9),strsub(classColor,11,14))
			
				
				activeBBarsArray[activeBBars].bg = activeBBarsArray[activeBBars]:CreateTexture(nil, "BACKGROUND")
				activeBBarsArray[activeBBars].bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
				activeBBarsArray[activeBBars].bg:SetAllPoints(true)
				activeBBarsArray[activeBBars].bg:SetVertexColor(0, 0, 0)
		
			
				if(player ~= nil) then
					playerBSpell[player] = name
				end

				local dashPos = strfind(player,"-")
				if(dashPos~=nil) then
					player = strsub(player,1,dashPos-1)
				end
					
				local t = PROPOSAL_DURATION
				local HALF_POINT = PROPOSAL_DURATION / 2
				activeBBarsArray[activeBBars]:SetScript("OnUpdate", function(bar, elapsed)
					t = t - elapsed
					bar:SetValue(t)
					bar:SetWidth(VRA:getBBarWidth())
					bar:SetHeight(VRA:getBBarHeight())
					text:SetFont(VRA:SetFont(VRA:getBFontType()), VRA:getBFontSize(), "OUTLINE")
					
					text:SetText(player.." - "..name.."("..convertTime(t)..")")
					activeBBarsArray[activeBBars]:SetStatusBarTexture(VRA:SetTexture(VRA:getBBarTexture()))
					
					VRA:modifyBBars()
					for i=1,activeBBars do
						if(i>1) then
							local min1,max1 = activeBBarsArray[i]:GetMinMaxValues()
							local min2,max2 = activeBBarsArray[i-1]:GetMinMaxValues()
							if((activeBBarsArray[i]:GetValue()/max1)<(activeBBarsArray[i-1]:GetValue()/max2)) then
								if(vradb.growthDirection) then
									activeBBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),(i-1)*VRA:getBBarHeight()+VRA:getBBarY())
									activeBBarsArray[i-1]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),(i)*VRA:getBBarHeight()+VRA:getBBarY())
								else
									activeBBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),-(i-1)*VRA:getBBarHeight()+VRA:getBBarY())
									activeBBarsArray[i-1]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getBBarX(),-(i)*VRA:getBBarHeight()+VRA:getBBarY())
								end
								local temp = activeBBarsArray[i]
								activeBBarsArray[i] = activeBBarsArray[i-1]
								activeBBarsArray[i-1] = temp
							end
						end
					end
					if t < 0.001 then
						activeBBars = activeBBars-1
						for i=1,activeBBars do
							activeBBarsArray[i] = activeBBarsArray[i+1]
						end
						
						playerBSpell[player] = ""
						text:SetText("")
						VRA:modifyBBars()
						bar:Hide()
						
					end
				end)
			end
		end
	end
	end
	end
end























function VRA:MoveOBar(name,duration)
	
	if(activeOMove == 0) then
		lockedO = true
		activeOMove = 1
		
		--Clearing cooldowns
		for i,j in pairs(playerOSpell) do
			playerOSpell[i]=""
		end
		
		for i=1,activeOBars do
			activeOBarsArray[i]:Hide()
		end
		
		activeOBars = 0
		
		activeOBars = activeOBars+1
		activeOBarsArray[activeOBars] = CreateFrame("StatusBar", nil, UIParent)
		
		local text = activeOBarsArray[activeOBars]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		text:SetPoint("CENTER",activeOBarsArray[activeOBars],"CENTER")
		text:SetText(name)
		text:SetFont(VRA:SetFont(VRA:getOFontType()), VRA:getOFontSize(), "OUTLINE")
		
		activeOBarsArray[activeOBars]:SetStatusBarTexture(VRA:SetTexture(VRA:getOBarTexture()))
		activeOBarsArray[activeOBars]:GetStatusBarTexture():SetHorizTile(false)
		activeOBarsArray[activeOBars]:SetMinMaxValues(0, duration)
		activeOBarsArray[activeOBars]:SetValue(100)
		activeOBarsArray[activeOBars]:SetWidth(VRA:getOBarWidth())
		activeOBarsArray[activeOBars]:SetHeight(VRA:getOBarHeight())
		if(vradb.growthDirection) then
			activeOBarsArray[activeOBars]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),activeOBars*VRA:getOBarHeight()+VRA:getOBarY())
		else
			activeOBarsArray[activeOBars]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),-activeOBars*VRA:getOBarHeight()+VRA:getOBarY())
		end
		activeOBarsArray[activeOBars]:SetStatusBarColor(0,1,0)
		
		activeOBarsArray[activeOBars].bg = activeOBarsArray[activeOBars]:CreateTexture(nil, "BACKGROUND")
		activeOBarsArray[activeOBars].bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		activeOBarsArray[activeOBars].bg:SetAllPoints(true)
		activeOBarsArray[activeOBars].bg:SetVertexColor(0, 0, 0)
		
		activeOBarsArray[activeOBars]:SetMovable(true)
		activeOBarsArray[activeOBars]:EnableMouse(true)
		activeOBarsArray[activeOBars]:RegisterForDrag("LeftButton")
		activeOBarsArray[activeOBars]:SetScript("OnDragStart", activeOBarsArray[activeOBars].StartMoving)
		activeOBarsArray[activeOBars]:SetScript("OnDragStop", activeOBarsArray[activeOBars].StopMovingOrSizing)
		
		
		
		local t = duration
		local HALF_POINT = duration / 2
		activeOBarsArray[activeOBars]:SetScript("OnUpdate", function(bar, elapsed)
			t = t - elapsed
			bar:SetValue(t)
			if t > HALF_POINT then
				bar:SetStatusBarColor(1, t / duration, 0)
			else
				bar:SetStatusBarColor(1 - (t / duration), 1, 0)
			end
			bar:SetWidth(VRA:getOBarWidth())
			bar:SetHeight(VRA:getOBarHeight())
			text:SetFont(VRA:SetFont(VRA:getOFontType()), VRA:getOFontSize(), "OUTLINE")
			activeOBarsArray[activeOBars]:SetStatusBarTexture(VRA:SetTexture(VRA:getOBarTexture()))
			if t < 0.001 then
				activeOBars = activeOBars-1
				for i=1,activeOBars do
					activeOBarsArray[i] = activeOBarsArray[i+1]
				end
				VRA:setOBarX(bar:GetLeft())
				VRA:setOBarY(bar:GetBottom()-VRA:getOBarHeight())
				
				text:SetText("")
				VRA:modifyOBars()
				bar:Hide()
				activeOMove = 0
				lockedO = false
			end
		end)
	end
end

function VRA:AddDataOOption(spellId)
	
	if not spellId then 
		return
	end
	local name, _, icon = GetSpellInfo(spellId)
	local dbKey = tostring(spellId)
	local db = vradb.spellsO[dbKey]
	if not name then 
		--mod:log(L["spell not exists, id:"] .. spellId)
		vradb.spellsO[dbKey] = nil
		return 
	end	
	local isOriginal = ( db.type ~= "custom" ) and true or false
	local op = self.options.args.OffensiveCooldownBar.args
	op[dbKey] = {
		type = "group",
		name = function() local s = name if db.type == "custom" then s = "|T" .. icon .. ":18:18:0:0|t " .. " * " .. name end if not db.enable then s = "|T" .. icon .. ":18:18:0:0|t ".."|cffDD1133" .. s .. "|r" end return "|T" .. icon .. ":18:18:0:0|t "..s end,
		icon = nil,
		disabled = function() if(vradb.enableOCooldownBar) then return false else return true end end,
		args = {
			enableo = {
				type = "toggle",
				desc = function() GameTooltip:SetHyperlink(GetSpellLink(spellId)) end,
				descStyle = "custom",
				name = function() if not db.desc or db.desc == "" then return "|T" .. icon .. ":18:18:0:0|t " .. name else return  "|T" .. icon .. ":18:18:0:0|t " .. name ..  " (" .. (db.desc).. ")"  end end,
				set = function(info, value) db.enable = value end,
				get = function() return db.enable end,
				order = 1,
			},
			selfOnlyo = {
				type = "toggle",
				desc = "Only when applied to self",
				name = "Applied to self only",
				disabled = isOriginal,
				set = function(info, value) db.selfOnly = value end,
				get = function() return db.selfOnly end,
				order = 2,
			},
			headero = {
				type = "header",
				name = "",
				order = 3,
			},
			-- cdo = {
				-- name = "CD",
				-- type = "input",
				-- desc = "In seconds",
				-- get = function() return tostring(db.cd or 0) end,
				-- set = function(info, value) db.cd = tonumber(value) end,
				-- pattern = "^%d+$",
			-- },
			durationo = {
				name = "Duration",
				type = "input",
				desc = "In seconds",
				disabled = isOriginal,
				get = function() return tostring(db.duration or 0) end,
				set = function(info, value) db.duration = tonumber(value) end,
				pattern = "^%d+$",
			},
			spellIdo = {
				name = "Spell ID",
				type = "input",
				disabled = true,
				get = function() return dbKey end,
				pattern = "^%d+$",
			},
			deleteo = {
				name = "DELETE",
				type = "execute",
				disabled = isOriginal,
				confirm = true,
				confirmText = "Are you sure to delete the data?",
				func = function() 
				local op = self.options.args.OffensiveCooldownBar.args
				local data = self:GetBarDataO()
				local db = vradb.spellsO
				db[dbKey] = nil
				op[dbKey] = nil
				end,
				order = -1,
			},
		},
	}
end


local function spellOCooldowns(spellName)
	if(spellName~=nil) then
		local data = VRA:GetBarDataO()
		

		if type(data) == "table" then 
			for k, v in pairs(data) do
				if(tonumber(spellName)==k) then
					return v.duration
				end
			end
		end
		if(vradb.spellsO[tostring(spellName)]~=nil and not vradb.spellsO[tostring(spellName)].selfOnly) then
			return vradb.spellsO[tostring(spellName)].duration
		end
		return -1
	else
		return -1
	end

	
end


function VRA:spellPOCooldowns(spellName)

	if(spellName~=nil) then
	
		 if(vradb.spellsO[tostring(spellName)]~=nil and vradb.spellsO[tostring(spellName)].selfOnly) then
			 return vradb.spellsO[tostring(spellName)].duration
		 end
	 else
		 return -1
	 end


	
end


function VRA:CreateOBar(player,spell,...)
	if(vradb.spellsO[tostring(spell)]~=nil) then
	if(vradb.spellsO[tostring(spell)].enable) then
	if(not lockedO) then
		local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spell)
	
		local PROPOSAL_DURATION = spellOCooldowns(spell)
		
		if(per~="personal" and vradb.spellsO[tostring(spell)].selfOnly) then
		
		else
		
		if(PROPOSAL_DURATION == -1 and ...=="personal") then
			PROPOSAL_DURATION = VRA:spellPOCooldowns(spell)
		end
		
		local accept = true
		for i,j in pairs(playerOSpell) do
			if(i == player) then
				if(playerOSpell[i]==name) then
					if(not testingactive) then
						accept = false
					end
				end
			end
		end
	
		if(PROPOSAL_DURATION ~= nil and PROPOSAL_DURATION>0 and accept==true) then
		
			activeOBars = activeOBars+1
			activeOBarsArray[activeOBars] = CreateFrame("StatusBar", nil, UIParent)
		
			local text = activeOBarsArray[activeOBars]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
			text:SetPoint("CENTER",activeOBarsArray[activeOBars],"CENTER")
			text:SetFont(VRA:SetFont(VRA:getOFontType()), VRA:getOFontSize(), "OUTLINE")
		
			activeOBarsArray[activeOBars]:SetStatusBarTexture(VRA:SetTexture(VRA:getOBarTexture()))
			activeOBarsArray[activeOBars]:GetStatusBarTexture():SetHorizTile(false)
			activeOBarsArray[activeOBars]:SetMinMaxValues(0, PROPOSAL_DURATION)
			activeOBarsArray[activeOBars]:SetValue(100)
			activeOBarsArray[activeOBars]:SetWidth(VRA:getOBarWidth())
			activeOBarsArray[activeOBars]:SetHeight(VRA:getOBarHeight())
			if(vradb.growthDirection) then
				activeOBarsArray[activeOBars]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),activeOBars*VRA:getOBarHeight()+VRA:getOBarY())
			else
				activeOBarsArray[activeOBars]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),-activeOBars*VRA:getOBarHeight()+VRA:getOBarY())
			end
			
			local classColor
			classColor = RGBClassTEST(player)
			
			if(classColor == "") then
				classColor = RGBClass(player)
			end
			activeOBarsArray[activeOBars]:SetStatusBarColor(strsub(classColor,1,4),strsub(classColor,6,9),strsub(classColor,11,14))
		
			activeOBarsArray[activeOBars].bg = activeOBarsArray[activeOBars]:CreateTexture(nil, "BACKGROUND")
			activeOBarsArray[activeOBars].bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			activeOBarsArray[activeOBars].bg:SetAllPoints(true)
			activeOBarsArray[activeOBars].bg:SetVertexColor(0, 0, 0)
	
		
			if(player ~= nil) then
				playerOSpell[player] = name
			end

			local dashPos = strfind(player,"-")
			if(dashPos~=nil) then
				player = strsub(player,1,dashPos-1)
			end
			local t = PROPOSAL_DURATION
			local HALF_POINT = PROPOSAL_DURATION / 2
			local k = (5-1)/10
			activeOBarsArray[activeOBars]:SetScript("OnUpdate", function(bar, elapsed)
				t = t - elapsed
				bar:SetValue(t)
				bar:SetWidth(VRA:getOBarWidth())
				bar:SetHeight(VRA:getOBarHeight())
				text:SetFont(VRA:SetFont(VRA:getOFontType()), VRA:getOFontSize(), "OUTLINE")
				
				text:SetText(player.." - "..name.."("..convertTime(t)..")")
				activeOBarsArray[activeOBars]:SetStatusBarTexture(VRA:SetTexture(VRA:getOBarTexture()))
				
				VRA:modifyOBars()
				for i=1,activeOBars do
					if(i>1) then
						local min1,max1 = activeOBarsArray[i]:GetMinMaxValues()
						local min2,max2 = activeOBarsArray[i-1]:GetMinMaxValues()
						if((activeOBarsArray[i]:GetValue()/max1)<(activeOBarsArray[i-1]:GetValue()/max2)) then
							if(vradb.growthDirection) then
								activeOBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),(i-1)*VRA:getOBarHeight()+VRA:getOBarY())
								activeOBarsArray[i-1]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),(i)*VRA:getOBarHeight()+VRA:getOBarY())
							else
								activeOBarsArray[i]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),-(i-1)*VRA:getOBarHeight()+VRA:getOBarY())
								activeOBarsArray[i-1]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0+VRA:getOBarX(),-(i)*VRA:getOBarHeight()+VRA:getOBarY())
							end
							local temp = activeOBarsArray[i]
							activeOBarsArray[i] = activeOBarsArray[i-1]
							activeOBarsArray[i-1] = temp
						end
					end
				end
				if t < 0.001 then
					activeOBars = activeOBars-1
					for i=1,activeOBars do
						activeOBarsArray[i] = activeOBarsArray[i+1]
					end
					playerOSpell[player] = ""
					text:SetText("")
					VRA:modifyOBars()
					bar:Hide()
					
				end
			end)
		end
		end
	end
	end
	end
end



function VRA:AddDataOption(spellId)

	if not spellId then 
		return
	end
	local name, _, icon = GetSpellInfo(spellId)
	local dbKey = tostring(spellId)
	local db = vradb.spells[dbKey]
	if not name then 
		--mod:log(L["spell not exists, id:"] .. spellId)
		vradb.spells[dbKey] = nil
		return 
	end	
	local isOriginal = ( db.type ~= "custom" ) and true or false
	local op = self.options.args.CooldownBar.args
	op[dbKey] = {
		type = "group",
		name = function() local s = name if db.type == "custom" then s = "|T" .. icon .. ":18:18:0:0|t " .. " * " .. name end if not db.enable then s = "|T" .. icon .. ":18:18:0:0|t ".."|cffDD1133" .. s .. "|r" end return "|T" .. icon .. ":18:18:0:0|t "..s end,
		icon = nil,
		disabled = function() if(vradb.enableCooldownBar) then return false else return true end end,
		args = {
			enable = {
				type = "toggle",
				desc = function() GameTooltip:SetHyperlink(GetSpellLink(spellId)) end,
				descStyle = "custom",
				name = function() if not db.desc or db.desc == "" then return "|T" .. icon .. ":18:18:0:0|t " .. name else return  "|T" .. icon .. ":18:18:0:0|t " .. name ..  " (" .. (db.desc).. ")"  end end,
				set = function(info, value) db.enable = value end,
				get = function() return db.enable end,
				width = "full",
				order = 1,
			},
			header = {
				type = "header",
				name = "",
				order = 2,
			},
			cd = {
				name = "CD",
				type = "input",
				desc = "In seconds",
				disabled = isOriginal,
				get = function() return tostring(db.cd or 0) end,
				set = function(info, value) db.cd = tonumber(value) end,
				pattern = "^%d+$",
			},
			--duration = {
			--	name = "Duration",
			--	type = "input",
				
				--get = function() return tostring(db.duration or 0) end,
				--set = function(info, value) db.duration = tonumber(value) self:ResetAllIcons() end,
			--	pattern = "^%d+$",
			--},
			spellId = {
				name = "Spell ID",
				type = "input",
				disabled = true,
				get = function() return dbKey end,
				pattern = "^%d+$",
			},
			delete = {
				name = "DELETE",
				type = "execute",
				disabled = isOriginal,
				confirm = true,
				confirmText = "Are you sure to delete the data?",
				func = function() 
				local op = self.options.args.CooldownBar.args
				local data = self:GetBarData()
				local db = vradb.spells
				db[dbKey] = nil
				op[dbKey] = nil
				end,
				order = -1,
			},
		},
	}
end

local function spellCooldowns(spellName,player)
	
	 if(spellName~=nil) then
		local data = VRA:GetBarData()
		if type(data) == "table" then 
			for k, v in pairs(data) do
				if(tonumber(spellName)==k) then
					if(k==740 and UnitGroupRolesAssigned(player)=="HEALER") then
						return 3*60
					else
						return v.cd
					end
				end
			end
		end
		 if(vradb.spells[tostring(spellName)]~=nil) then
			 return vradb.spells[tostring(spellName)].cd
		 end
	 else
		 return -1
	 end
	
end


function VRA:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(GetAddOnMetadata("VocalRaidAssistant", "Title"))
	InterfaceOptionsFrame_OpenToCategory(GetAddOnMetadata("VocalRaidAssistant", "Title"))
end

function VRA:ChangeProfile()
	if(activeBMove==1) then
		for i=1,activeBBars do
			activeBBarsArray[i]:Hide()
		end
		activeBMove = 0
	end
	if(activeOMove==1) then
		for i=1,activeOBars do
			activeOBarsArray[i]:Hide()
		end
		activeOMove = 0
	end
	if(activeMove==1) then
		for i=1,activeBars do
			activeBarsArray[i]:Hide()
		end
		activeMove = 0
	end
	vradb = self.db1.profile

	for k,v in VocalRaidAssistant:IterateModules() do
		if type(v.ChangeProfile) == 'function' then
			v:ChangeProfile()
		end
	end
	if not vradb.custom then vradb.custom = {} end
	ReloadUI()
end

function VRA:AddOption(name, keyName)
	
	return AceConfigDialog:AddToBlizOptions("VocalRaidAssistant", name, "VocalRaidAssistant", keyName)
end


function VRA:UpdateRoster()
	rosterStatusOldArray[1] = vradb.raid1
	rosterStatusOldArray[2] = vradb.raid2
	rosterStatusOldArray[3] = vradb.raid3
	rosterStatusOldArray[4] = vradb.raid4
	rosterStatusOldArray[5] = vradb.raid5
	rosterStatusOldArray[6] = vradb.raid6
	rosterStatusOldArray[7] = vradb.raid7
	rosterStatusOldArray[8] = vradb.raid8
	rosterStatusOldArray[9] = vradb.raid9
	rosterStatusOldArray[10] = vradb.raid10
	rosterStatusOldArray[11] = vradb.raid11
	rosterStatusOldArray[12] = vradb.raid12
	rosterStatusOldArray[13] = vradb.raid13
	rosterStatusOldArray[14] = vradb.raid14
	rosterStatusOldArray[15] = vradb.raid15
	rosterStatusOldArray[16] = vradb.raid16
	rosterStatusOldArray[17] = vradb.raid17
	rosterStatusOldArray[18] = vradb.raid18
	rosterStatusOldArray[19] = vradb.raid19
	rosterStatusOldArray[20] = vradb.raid20
	rosterStatusOldArray[21] = vradb.raid21
	rosterStatusOldArray[22] = vradb.raid22
	rosterStatusOldArray[23] = vradb.raid23
	rosterStatusOldArray[24] = vradb.raid24
	rosterStatusOldArray[25] = vradb.raid25
	rosterStatusOldArray[26] = vradb.raid26
	rosterStatusOldArray[27] = vradb.raid27
	rosterStatusOldArray[28] = vradb.raid28
	rosterStatusOldArray[29] = vradb.raid29
	rosterStatusOldArray[30] = vradb.raid30
	rosterStatusOldArray[31] = vradb.raid31
	rosterStatusOldArray[32] = vradb.raid32
	rosterStatusOldArray[33] = vradb.raid33
	rosterStatusOldArray[34] = vradb.raid34
	rosterStatusOldArray[35] = vradb.raid35
	rosterStatusOldArray[36] = vradb.raid36
	rosterStatusOldArray[37] = vradb.raid37
	rosterStatusOldArray[38] = vradb.raid38
	rosterStatusOldArray[39] = vradb.raid39
	rosterStatusOldArray[40] = vradb.raid40
	
	for i=1,raidMaxSize do
		if GetRaidRosterInfo(i) ~= nil then
			-- = GetRaidRosterInfo(i)
			rosterNameArray[i], _, _, _, rosterClassArray[i], _, _, _, _, _, _ = GetRaidRosterInfo(i) 
		else
			rosterNameArray[i] = ""
			rosterClassArray[i] = ""
		end
		
	end
	
	for i=1,raidMaxSize do
		local found = false
		for j=1,raidMaxSize do
			if(rosterInfoArray[i] ~= nil) then
				if(rosterInfoArray[i] ~= strsub(rosterInfoArray[i],11).."") then
					if(rosterNameArray[i] == strsub(rosterInfoArray[j],11)) then
					found = true
						if(rosterStatusOldArray[j] ~= nil) then
							rosterStatusArray[i] = rosterStatusOldArray[j]
						end
					end
				end
			end
		end
		
		if(not found and not first) then
			rosterStatusArray[i] = false
		end
		if(first) then
			rosterStatusArray[i] = rosterStatusOldArray[i]
		end
		
	end
	
	first = false
	
	for i=1,raidMaxSize do
		rosterInfoArray[i] = VRA:classColor(rosterClassArray[i]) .. rosterNameArray[i]
		--rosterStatusOldArray[i] = rosterStatusArray[i]
	end
	
	vradb.raid1 = rosterStatusArray[1]
	vradb.raid2 = rosterStatusArray[2]
	vradb.raid3 = rosterStatusArray[3]
	vradb.raid4 = rosterStatusArray[4]
	vradb.raid5 = rosterStatusArray[5]
	vradb.raid6 = rosterStatusArray[6]
	vradb.raid7 = rosterStatusArray[7]
	vradb.raid8 = rosterStatusArray[8]
	vradb.raid9 = rosterStatusArray[9]
	vradb.raid10 = rosterStatusArray[10]
	vradb.raid11 = rosterStatusArray[11]
	vradb.raid12 = rosterStatusArray[12]
	vradb.raid13 = rosterStatusArray[13]
	vradb.raid14 = rosterStatusArray[14]
	vradb.raid15 = rosterStatusArray[15]
	vradb.raid16 = rosterStatusArray[16]
	vradb.raid17 = rosterStatusArray[17]
	vradb.raid18 = rosterStatusArray[18]
	vradb.raid19 = rosterStatusArray[19]
	vradb.raid20 = rosterStatusArray[20]
	vradb.raid21 = rosterStatusArray[21]
	vradb.raid22 = rosterStatusArray[22]
	vradb.raid23 = rosterStatusArray[23]
	vradb.raid24 = rosterStatusArray[24]
	vradb.raid25 = rosterStatusArray[25]
	vradb.raid26 = rosterStatusArray[26]
	vradb.raid27 = rosterStatusArray[27]
	vradb.raid28 = rosterStatusArray[28]
	vradb.raid29 = rosterStatusArray[29]
	vradb.raid30 = rosterStatusArray[30]
	vradb.raid31 = rosterStatusArray[31]
	vradb.raid32 = rosterStatusArray[32]
	vradb.raid33 = rosterStatusArray[33]
	vradb.raid34 = rosterStatusArray[34]
	vradb.raid35 = rosterStatusArray[35]
	vradb.raid36 = rosterStatusArray[36]
	vradb.raid37 = rosterStatusArray[37]
	vradb.raid38 = rosterStatusArray[38]
	vradb.raid39 = rosterStatusArray[39]
	vradb.raid40 = rosterStatusArray[40]
	
	
	if(testnull == 1) then
	LibStub("AceConfigRegistry-3.0"):NotifyChange("VocalRaidAssistant")
	else 
	testnull = 1
	end
	
end

function VRA:IsSelected(name)
	
	rosterStatusOldArray[1] = vradb.raid1
	rosterStatusOldArray[2] = vradb.raid2
	rosterStatusOldArray[3] = vradb.raid3
	rosterStatusOldArray[4] = vradb.raid4
	rosterStatusOldArray[5] = vradb.raid5
	rosterStatusOldArray[6] = vradb.raid6
	rosterStatusOldArray[7] = vradb.raid7
	rosterStatusOldArray[8] = vradb.raid8
	rosterStatusOldArray[9] = vradb.raid9
	rosterStatusOldArray[10] = vradb.raid10
	rosterStatusOldArray[11] = vradb.raid11
	rosterStatusOldArray[12] = vradb.raid12
	rosterStatusOldArray[13] = vradb.raid13
	rosterStatusOldArray[14] = vradb.raid14
	rosterStatusOldArray[15] = vradb.raid15
	rosterStatusOldArray[16] = vradb.raid16
	rosterStatusOldArray[17] = vradb.raid17
	rosterStatusOldArray[18] = vradb.raid18
	rosterStatusOldArray[19] = vradb.raid19
	rosterStatusOldArray[20] = vradb.raid20
	rosterStatusOldArray[21] = vradb.raid21
	rosterStatusOldArray[22] = vradb.raid22
	rosterStatusOldArray[23] = vradb.raid23
	rosterStatusOldArray[24] = vradb.raid24
	rosterStatusOldArray[25] = vradb.raid25
	rosterStatusOldArray[26] = vradb.raid26
	rosterStatusOldArray[27] = vradb.raid27
	rosterStatusOldArray[28] = vradb.raid28
	rosterStatusOldArray[29] = vradb.raid29
	rosterStatusOldArray[30] = vradb.raid30
	rosterStatusOldArray[31] = vradb.raid31
	rosterStatusOldArray[32] = vradb.raid32
	rosterStatusOldArray[33] = vradb.raid33
	rosterStatusOldArray[34] = vradb.raid34
	rosterStatusOldArray[35] = vradb.raid35
	rosterStatusOldArray[36] = vradb.raid36
	rosterStatusOldArray[37] = vradb.raid37
	rosterStatusOldArray[38] = vradb.raid38
	rosterStatusOldArray[39] = vradb.raid39
	rosterStatusOldArray[40] = vradb.raid40
	
	for i=1,raidMaxSize do
		if(rosterNameArray[i]==name) then
			if(rosterStatusOldArray[i]==true) then
				return true
			end
		end
	end
	return false
end


local function setOption(info, value)
	local name = info[#info]
	vradb[name] = value
	if value then 
		PlaySoundFile("Interface\\Addons\\"..vradb.path.."\\"..name..".ogg", VRA.VRA_CHANNEL[vradb.channel]);
	end
end
local function getOption(info)
	local name = info[#info]
	return vradb[name]
end
local function spellOption(order, spellID, ...)
	local spellname, _, icon = GetSpellInfo(spellID)	
	if (spellname ~= nil) then
		return {
			type = 'toggle',
			name = "\124T" .. icon .. ":24\124t" .. spellname,							
			desc = function () 
				GameTooltip:SetHyperlink(GetSpellLink(spellID));
				--GameTooltip:Show();
			end,
			descStyle = "custom",
					order = order,
		}
	else
		VRA.log("spell id: " .. spellID .. " is invalid")
		return {
			type = 'toggle',
			name = "unknown spell, id:" .. spellID,	
			order = order,
		}
	end
end

local function listOption(spellList, listType, ...)
	local args = {}
	for k, v in pairs(spellList) do
		if VRA.spellList[listType][v] then
			rawset (args, VRA.spellList[listType][v] ,spellOption(k, v))
		else 
		--[[debug
			print (v)
		]]
		end
	end
	return args
end

function VRA:MakeCustomOption(key)
	local options = self.options.args.custom.args
	local db = vradb.custom
	options[key] = {
		type = 'group',
		name = function() return db[key].name end,
		set = function(info, value) local name = info[#info] db[key][name] = value end,
		get = function(info) local name = info[#info] return db[key][name] end,
		order = db[key].order,
		args = {
			name = {
				name = L["name"],
				type = 'input',
				set = function(info, value)
					if db[value] then VRA.log(L["same name already exists"]) return end
					db[value] = db[key]
					db[value].name = value
					db[value].order = #db + 1
					db[value].soundfilepath = "Sound\Creature\AlgalonTheObserver\UR_Algalon_BHole01.ogg"
					db[key] = nil
					--makeoption(value)
					options[value] = options[key]
					options[key] = nil
					key = value
				end,
				order = 10,
			},
			spellid = {
				name = L["spellid"],
				type = 'input',
				order = 20,
				pattern = "%d+$",
			},
			remove = {
				type = 'execute',
				order = 25,
				name = L["Remove"],
				confirm = true,
				confirmText = L["Are you sure?"],
				func = function() 
					db[key] = nil
					options[key] = nil
				end,
			},
			test = {
				type = 'execute',
				order = 28,
				name = L["Test"],
				func = function() PlaySoundFile(db[key].soundfilepath, self.VRA_CHANNEL[vradb.channel]) end,
			},
			existingsound = {
				name = L["Use existing sound"],
				type = 'toggle',
				disabled = true,
				order = 30,
			},
			existinglist = {
				name = L["choose a sound"],
				type = 'select',
				dialogControl = 'LSM30_Sound',
				values =  AceGUIWidgetLSMlists.sound,
				
				disabled = function() return not db[key].existingsound end,
				order = 40,
			},
			NewLine3 = {
				type= 'description',
				order = 45,
				name= '',
			},
			soundfilepath = {
				name = L["file path"],
				type = 'input',
				width = 'double',
				order = 27,
				disabled = function() return db[key].existingsound end,
			},
			eventtype = {
				type = 'multiselect',
				order = 50,
				name = L["event type"],
				values = self.VRA_EVENT,
				get = function(info, k) return db[key].eventtype[k] end,
				set = function(info, k, v) db[key].eventtype[k] = v end,
			},
			sourceuidfilter = {
				type = 'select',
				order = 61,
				name = L["Source unit"],
				values = self.VRA_UNIT,
			},
			sourcetypefilter = {
				type = 'select',
				order = 59,
				name = L["Source type"],
				values = self.VRA_TYPE,
			},
			sourcecustomname = {
				type= 'input',
				order = 62,
				name= L["Custom unit name"],
				disabled = function() return not (db[key].sourceuidfilter == "custom") end,
			},
			destuidfilter = {
				type = 'select',
				order = 65,
				name = L["Dest unit"],
				values = self.VRA_UNIT,
			},
			desttypefilter = {
				type = 'select',
				order = 60,
				name = L["Dest type"],
				values = self.VRA_TYPE,
			},
			destcustomname = {
				type= 'input',
				order = 68,
				name = L["Custom unit name"],
				disabled = function() return not (db[key].destuidfilter == "custom") end,
			},
			--[[NewLine5 = {
				type = 'header',
				order = 69,
				name = "",
			},]]
		}
	}
end


function VRA:OnOptionCreate()
	local newSpellId
	vradb = self.db1.profile
	self:UpdateRoster()
	self.options = {
		type = "group",
		name = "Vocal Raid Assistant",
		args = {
			general = {
				type = 'group',
				name = L["General"],
				desc = L["General options"],
				set = setOption,
				get = getOption,
				order = 1,
				args = {
					enableArea = {
						type = 'group',
						inline = true,
						name = L["Enable area"],
						order = 1,
						args = {
							all = {
								type = 'toggle',
								name = L["Anywhere"],
								desc = L["Anywhere Option Description"],
								order = 1,
							},
							field = {
								type = 'toggle',
								name = L["World"],
								desc = L["World Option Description"],
								disabled = function() return vradb.all end,
								order = 2,
							},
							battleground = {
								type = 'toggle',
								name = L["Battleground"],
								desc = L["Battleground Option Description"],
								disabled = function() return vradb.all end,
								order = 3,
							},
							arena = {
								type = 'toggle',
								name = L["Arena"],
								desc = L["Arena Option Description"],
								disabled = function() return vradb.all end,
								order = 4,
							},
							instance = {
								type = 'toggle',
								name = L["Instance"],
								desc = L["Instance Option Description"],
								disabled = function() return vradb.all end,
								order = 5,
							},
							raid = {
								type = 'toggle',
								name = L["Raid"],
								desc = L["Raid Option Description"],
								disabled = function() return vradb.all end,
								order = 6,
							},
							scenario = {
								type = 'toggle',
								name = L["Scenario"],
								desc = L["Scenario Option Description"],
								disabled = function() return vradb.all end,
								order = 7,
							},
						},
					},
					voice = {
						type = 'group',
						inline = true,
						name = L["Voice config"],
						order = 2,
						args = {
							path = {
								type = 'select',
								name = L["Voice language"],
								desc = L["Select language of the alert"],
								values = self.VRA_LANGUAGE,
								order = 1,
							},
							volumn = {
								type = 'range',
								max = 1,
								min = 0,
								step = 0.1,
								name = L["Volume"],
								desc = L["adjusting the voice volume(the same as adjusting the system master sound volume)"],
								set = function (info, value) SetCVar ("Sound_"..vradb.channel.."Volume",tostring (value)) end,
								get = function () return tonumber (GetCVar ("Sound_"..vradb.channel.."Volume")) end,
								order = 2,
							},
							void = {
								type = 'description',
								name = "",
								desc = "",
								order = 3,
							},
							channel = {
								type = 'select',
								name = L["Output channel"],
								desc = L["Output channel desc"],
								values = self.VRA_CHANNEL,
								order = 4,
							},
							enabled = {
								type = 'toggle',
								name = function() return vradb.channel.." channel" end,
								width = "double",
								desc = "Enables or disables "..self.VRA_CHANNEL[vradb.channel].." sound channel",
								set = 	function(info,value)
											if(vradb.channel=="Master") then
												SetCVar ("Sound_EnableAllSound", (value and 1 or 0))
											else
												SetCVar ("Sound_Enable"..vradb.channel, (value and 1 or 0))
											end
										end,
								get = 	function()
											if(vradb.channel=="Master") then
												return tonumber(GetCVar("Sound_EnableAllSound"))==1 and true or false
											else
												return tonumber(GetCVar("Sound_Enable"..vradb.channel))==1 and true or false
											end
										end,
								order = 5,
							},
						},
					},
					advance = {
						type = 'group',
						inline = true,
						name = L["Advance options"],
						order = 3,
						args = {
							smartDisable = {
								type = 'toggle',
								name = L["Smart disable"],
								desc = L["Disable addon for a moment while too many alerts comes"],
								order = 1,
							},
							throttle = {
								type = 'range',
								max = 5,
								min = 0,
								step = 0.1,
								name = L["Throttle"],
								desc = L["The minimum interval of each alert"],
								order = 2,
							},
						},
					},
				},
			},
			spells = {
				type = 'group',
				name = L["Abilities"],
				desc = L["Abilities options"],
				set = setOption,
				get = getOption,
				childGroups = "tab",
				order = 2,
				args = {
					spellSpec = {
						type = 'group',
						name = "Target specific",
						desc = "Buffs on Specialization",
						inline = true,
						order = -2,
						args = {
							onlySelf = {
								type = 'toggle',
								name = "Player Only",
								desc = "Check this will only alert for buff applied to player",
								order = 1,
							},
							buffAppliedSpecific = {
								type = 'toggle',
								name = "Individual Buff",
								desc = "Check this will only alert for buff applied to specific players",
								order = 2,
								disabled = function() return vradb.onlySelf end,
							},
							onlyRaidGroup = {
								type = 'toggle',
								name = "Only Check Raid Group",
								desc = "Check this will only alert for buff/casts from/to raid group",
								order = 3,
								disabled = function() return vradb.buffAppliedSpecific or vradb.onlySelf end,
							},
							buffAppliedTank = {
								type = 'toggle',
								name = "Only Buffs On Tank",
								desc = "Check this will only alert for buff applied to friendly tanks",
								order = 4,
								disabled = function() return vradb.buffAppliedSpecific or vradb.onlySelf end,
							},
							
						},
					},
					spellGeneral = {
						type = 'group',
						name = L["Disable options"],
						desc = L["Disable abilities by type"],
						inline = true,
						order = -1,
						args = {
							aruaApplied = {
								type = 'toggle',
								name = L["Disable Buff Applied"],
								desc = L["Check this will disable alert for buff applied to friendly targets"],
								order = 1,
							},
							castSuccess = {
								type = 'toggle',
								name = L["Disable special abilities"],
								desc = L["Check this will disable alert for instant-cast important abilities"],
								order = 4,
							},
							interrupt = {
								type = 'toggle',
								name = L["Disable friendly interrupt"],
								desc = L["Check this will disable alert for successfully-landed friendly interrupting abilities"],
								order = 5,
							}
						},
					},
					spellAuraApplied = {
						type = 'group',
						--inline = true,
						name = L["Buff Applied"],
						disabled = function() return vradb.aruaApplied end,
						order = 1,
						args = {
							general = {
								type = 'group',
								inline = true,
								name = L["General Abilities"],
								order = 4,
								args = listOption({20594,58984},"auraApplied"),
							},
							dk	= {
								type = 'group',
								inline = true,
								name = L["|cffC41F3BDeath Knight|r"],
								order = 5,
								args = listOption({48792,49028,55233,48707,194844,194679,219809},"auraApplied"),
							},
							dh	= {
								type = 'group',
								inline = true,
								name = L["|cffA330C9Demon Hunter|r"],
								order = 6,
								args = listOption({198589,204021,187827},"auraApplied"),
							},
							druid = {
								type = 'group',
								inline = true,
								name = L["|cffFF7D0ADruid|r"],
								order = 7,
								args = listOption({102342,22812,61336,33891,192081,29166},"auraApplied"),	
							},
							hunter = {
								type = 'group',
								inline = true,
								name = L["|cffABD473Hunter|r"],
								order = 8,
								args = listOption({34477,53480},"auraApplied"),
							},
							mage = {
								type = 'group',
								inline = true,
								name = L["|cff69CCF0Mage|r"],
								order = 9,
								args = listOption({},"auraApplied"),
							},
							monk = {
								type = 'group',
								inline = true,
								name = L["|cFF558A84Monk|r"],
								order = 10,
								args = listOption({116849,115203,122278,122783,115176,325197},"auraApplied"),
							},
							paladin = {
								type = 'group',
								inline = true,
								name = L["|cffF58CBAPaladin|r"],
								order = 11,
								args = listOption({6940,1022,86659,31850,642,216331,31884,105809,204018},"auraApplied"),
							},
							preist	= {
								type = 'group',
								inline = true,
								name = L["|cffFFFFFFPriest|r"],
								order = 12,
								args = listOption({33206,47788},"auraApplied"),
							},
							rogue = {
								type = 'group',
								inline = true,
								name = L["|cffFFF569Rogue|r"],
								order = 13,
								args = listOption({57934},"auraApplied"),
							},
							shaman	= {
								type = 'group',
								inline = true,
								name = L["|cff0070daShaman|r"],
								order = 14,
								args = listOption({114052,79206},"auraApplied"),
							},
							warlock = {
								type = 'group',
								inline = true,
								name = L["|cff9482C9Warlock|r"],
								order = 15,
								args = listOption({},"auraApplied"),
							},
							warrior	= {
								type = 'group',
								inline = true,
								name = L["|cffC79C6EWarrior|r"],
								order = 16,
								args = listOption({871,12975,118038,190456,2565,23920},"auraApplied"),	
							},
						},
					},
				
					spellCastSuccess = {
						type = 'group',
						--inline = true,
						name = L["Special Abilities"],
						disabled = function() return vradb.castSuccess end,
						order = 2,
						args = {
							general = {
								type = 'group',
								inline = true,
								name = L["General Abilities"],
								order = 4,
								args = listOption({178207,323436},"castSuccess"),
							},
							dk	= {
								type = 'group',
								inline = true,
								name = L["|cffC41F3BDeath Knight|r"],
								order = 5,
								args = listOption({51052,61999,108199,315443},"castSuccess"),
							},
							dh	= {
								type = 'group',
								inline = true,
								name = L["|cffA330C9Demon Hunter|r"],
								order = 6,
								args = listOption({196718,179057,202137,207684,202138,329554},"castSuccess"),
							},
							druid = {
								type = 'group',
								inline = true,
								name = L["|cffFF7D0ADruid|r"],
								order = 7,
								args = listOption({740,106898,77764,77761,20484,197721,102793,323764,205636},"castSuccess"),
							},
							hunter = {
								type = 'group',
								inline = true,
								name = L["|cffABD473Hunter|r"],
								order = 8,
								args = listOption({264667,109248,328231},"castSuccess"),
							},
							mage = {
								type = 'group',
								inline = true,
								name = L["|cff69CCF0Mage|r"],
								order = 9,
								args = listOption({80353},"castSuccess"),
							},
							monk = {
								type = 'group',
								inline = true,
								name = L["|cFF558A84Monk|r"],
								order = 10,
								args = listOption({115310,119381,116844,310454},"castSuccess"),
							},
							paladin = {
								type = 'group',
								inline = true,
								name = L["|cffF58CBAPaladin|r"],
								order = 11,
								args = listOption({31821,633,316958,304971},"castSuccess"),
							},
							preist	= {
								type = 'group',
								inline = true,
								name = L["|cffFFFFFFPriest|r"],
								order = 12,
								args = listOption({200183,64843,62618,271466,32375,15286,64901,205369,265202,73325,34433,246287,47536,325013,323673,109964},"castSuccess"),
							},
							rogue = {
								type = 'group',
								inline = true,
								name = L["|cffFFF569Rogue|r"],
								order = 13,
								args = listOption({76577},"castSuccess"),
							},
							shaman	= {
								type = 'group',
								inline = true,
								name = L["|cff0070daShaman|r"],
								order = 14,
								args = listOption({2825,32182,108280,98008,192077,198838,192058,207399,8143,320674,328923,326059,324386},"castSuccess"),
							},
							warlock = {
								type = 'group',
								inline = true,
								name = L["|cff9482C9Warlock|r"],
								order = 15,
								args = listOption({111771,20707,30283},"castSuccess"),
							},
							warrior	= {
								type = 'group',
								inline = true,
								name = L["|cffC79C6EWarrior|r"],
								order = 16,
								args = listOption({97462,1160,228920,46968},"castSuccess"),	
							},
						},
					},
					spellCastSuccessCrowdControl = {
						type = 'group',
						--inline = true,
						name = L["Crowd Control"],
						disabled = function() return vradb.aruaApplied end,
						order = 3,
						args = {
							general = {
								type = 'group',
								inline = true,
								name = L["General Abilities"],
								order = 4,
								args = listOption({107079},"auraApplied"),
							},
							dk	= {
								type = 'group',
								inline = true,
								name = L["|cffC41F3BDeath Knight|r"],
								order = 5,
								args = listOption({221562,49576},"auraApplied"),
							},
							dh	= {
								type = 'group',
								inline = true,
								name = L["|cffA330C9Demon Hunter|r"],
								order = 6,
								args = listOption({217832,211881},"auraApplied"),
							},
							druid = {
								type = 'group',
								inline = true,
								name = L["|cffFF7D0ADruid|r"],
								order = 7,
								args = listOption({33786},"auraApplied"),
							},
							hunter = {
								type = 'group',
								inline = true,
								name = L["|cffABD473Hunter|r"],
								order = 8,
								args = listOption({187650},"auraApplied"),
							},
							mage = {
								type = 'group',
								inline = true,
								name = L["|cff69CCF0Mage|r"],
								order = 9,
								args = listOption({118},"auraApplied"),
							},
							monk = {
								type = 'group',
								inline = true,
								name = L["|cFF558A84Monk|r"],
								order = 10,
								args = listOption({115078},"auraApplied"),
							},
							paladin = {
								type = 'group',
								inline = true,
								name = L["|cffF58CBAPaladin|r"],
								order = 11,
								args = listOption({853,20066},"auraApplied"),
							},
							preist	= {
								type = 'group',
								inline = true,
								name = L["|cffFFFFFFPriest|r"],
								order = 12,
								args = listOption({8122},"auraApplied"),
							},
							rogue = {
								type = 'group',
								inline = true,
								name = L["|cffFFF569Rogue|r"],
								order = 13,
								args = listOption({2094},"auraApplied"),
							},
							shaman	= {
								type = 'group',
								inline = true,
								name = L["|cff0070daShaman|r"],
								order = 14,
								args = listOption({51514},"auraApplied"),
							},
							warlock = {
								type = 'group',
								inline = true,
								name = L["|cff9482C9Warlock|r"],
								order = 15,
								args = listOption({5782},"auraApplied"),
							},
							warrior	= {
								type = 'group',
								inline = true,
								name = L["|cffC79C6EWarrior|r"],
								order = 16,
								args = listOption({5246},"auraApplied"),	
							},
						},
					},
					spellInterrupt = {
						type = 'group',
						--inline = true,
						name = L["Friendly Interrupt"],
						disabled = function() return vradb.interrupt end,
						order = 4,
						args = {
							lockout = {
								type = 'toggle',
								name = L["Friendly Interrupt"],
								desc = L["Spell Lock, Counterspell, Kick, Pummel, Mind Freeze, Skull Bash, Rebuke, Solar Beam, Spear Hand Strike, Wind Shear"],
								order = 1,
							},
						}
					},
				},
			},
			CooldownBar = {
				type = 'group',
				name = "Cooldown Bar",
				desc = "Cooldown Bar",
				set = setOption,
				get = getOption,
				childGroups = "tree",
				order = 3,
				handler = VocalRaidAssistant,
				args = {
					barX = {
						name = "barX",
						desc = "barX",
						type = 'input',
						get = "getBarX",
						set = "setBarX",
						hidden = true,
					},
					barY = {
						name = "barY",
						desc = "barY",
						type = 'input',
						get = "getBarY",
						set = "setBarY",
						hidden = true,
					},
					heightX = {
						name = "heightX",
						desc = "heightX",
						type = 'input',
						get = "getHeightX",
						set = "setHeightX",
						hidden = true,
					},
					enableCooldownBar = {
						name = "Enable",
						desc = "Enable Cooldown Bar (Only Works in Raid Group)",
						type = 'toggle',
						order = 1,
						handler = VocalRaidAssistant,
					},
					moveBars = {
						name = "Move me!",
						desc = "Click to move the position of the bar(s) - Clears all active cooldowns!",
						type = 'execute',
						order = 2,
						disabled = function() if(vradb.enableCooldownBar) then return false else VRA:ClearBars() return true end end,
						func = function() 
							VRA:MoveBar("COOLDOWN BAR!",20)
							--vradb.spells["1022"] = newSpellTable()
							--self:AddDataOption("1022")
							--VRA:CreateBar("Damista","97462")
							--VRA:CreateBar("Nítrak","97462")
							--VRA:CreateBar("Zørg-TheMaelstrom","97462")
						end,
						handler = VocalRaidAssistant,
					},
					userTest = {
						name = "Test!",
						desc = "Test some bars!",
						type = 'execute',
						order = 3,
						disabled = function() if(vradb.enableCooldownBar) then return false else return true end end,
						func = function() 
								VRA:CreateBar("Priest","64843")
								VRA:CreateBar("Druid","740")
								VRA:CreateBar("Death Knight","51052")
								VRA:CreateBar("Paladin","31821")
								VRA:CreateBar("Warrior","97462")
								VRA:CreateBar("Shaman","108280")
						end,
						handler = VocalRaidAssistant,
					},
					resetBars = {
						name = "Reset location",
						desc = "Click to reset the position of the bar(s)",
						type = 'execute',
						order = 5,
						disabled = function() if(vradb.enableCooldownBar) then return false else VRA:ClearBars() return true end end,
						func = function() 
							vradb.barX = 500
							vradb.barY = 500
						end,
						handler = VocalRaidAssistant,
					},
					forcetest = {
						name = "TEST!",
						desc = "TEST!",
						type = 'execute',
						order = 4,
						disabled = function() if(vradb.enableCooldownBar) then return false else return true end end,
						hidden = not testingactive,
						func = function() 
								VRA:CreateBar("Priest","64843")
								VRA:CreateBar("Druid","740")
								VRA:CreateBar("Death Knight","51052")
								VRA:CreateBar("Paladin","31821")
								VRA:CreateBar("Warrior","97462")
								VRA:CreateBar("Warrior","108280")
						end,
						handler = VocalRaidAssistant,
					},
					BarSettings = {
						type = 'group',
						name = "Bar Settings",
						desc = "Bar Settings",
						inline = true,
						order = -2,
						disabled = function() if(vradb.enableCooldownBar) then return false else return true end end,
						args = {
							barWidth = {
								type = 'range',
								max = 600,
								min = 1,
								step = 1,
								name = "Bar Width",
								desc = "Adjust Bar Width",
								get = "getBarWidth",
								order = 1,
							},
							barHeight = {
								type = 'range',
								max = 75,
								min = 1,
								step = 1,
								name = "Bar Height",
								desc = "Adjust Bar Height",
								get = "getBarHeight",
								order = 2,
							},
							fontSize = {
								type = 'range',
								max = 28,
								min = 1,
								step = 1,
								name = "Font Size",
								desc = "Adjust Font Size",
								get = "getFontSize",
								order = 3,
							},
							fontType = {
								name = "Set Font",
								desc = "Set Font Type",
								type = "select",
								dialogControl = 'LSM30_Font',
								get = "getFontType",
								values = AceGUIWidgetLSMlists.font,
								order = 4,
							},
							barTexture = {
								type = 'select',
								dialogControl = 'LSM30_Statusbar',
								name = "Set Bar Texture",
								desc = "Set Bar Texture",
								values = AceGUIWidgetLSMlists.statusbar,
								get = "getBarTexture",
								order=5,
							},
							growthDirection = {
								type = 'toggle',
								name = "Growth Direction",
								desc = "Active = UP \nDisabled = DOWN",
								order=6,
							},
							enablePulse = {
								type = 'toggle',
								name = "Enable Pulse",
								desc = "Bar starts pulsing once timer is met",
								order=7,
							},
							pulseStart = {
								type = 'range',
								max = 25,
								min = 1,
								step = 1,
								disabled = function() if(vradb.enableCooldownBar and vradb.enablePulse) then return false else return true end end,
								name = "Pulse Start",
								desc = "Adjust remaining time pulse",
								get = "getPulseStart",
								order = 8,
							},
							pulseIntensity = {
								type = 'range',
								max = 3,
								min = 1,
								step = 0.1,
								disabled = function() if(vradb.enableCooldownBar and vradb.enablePulse) then return false else return true end end,
								name = "Pulse Intensity",
								desc = "Adjust pulse intensity",
								get = "getPulseIntensity",
								order = 8,
							},
						},
					},
					BarAbilities = {
						type = 'group',
						name = "Bar Abilities",
						desc = "Bar Abilities",
						inline = true,
						order = -1,
						disabled = function() if(vradb.enableCooldownBar) then return false else return true end end,
						args = {
							spellId = {
								name = "Spell ID",
								type = "input",
								set = function(info, value) newSpellId = value end,
								get = function() return newSpellId end,
								--pattern = "^%d+$",
								order = 1,
							},
							addCustom = {
								type = "execute",
								name = "Add New CD",
								func = function()
									if not newSpellId then return end
									if not vradb.spells[newSpellId] then
										vradb.spells[tostring(newSpellId)] = newSpellTable()
										self:AddDataOption(tostring(newSpellId))
										self.options.args.CooldownBar.args.BarAbilities.args.spellId.set("","")
									else
										--self:log("Id '" .. newSpellId .. "' " .. "already exists.")
									end
								end,
								order = 2,
							},
							dataDelete = {
								type = "execute",
								name = "Delete Custom Data",
								desc = "To delete all custom data, the addon's original data will not be changed",
								confirm = true,
								confirmText = "Are you sure to delete all custom data?",
								order = 3,
								func = function()
									local op = self.options.args.CooldownBar.args
									local data = self:GetBarData()
									local db = vradb.spells
									for k, v in pairs(db) do
										if v.type == "custom" then
											db[k] = nil
											op[k] = nil
										end
									end
								end,
							},
						},
					},
				},
			},
			BuffBar = {
				type = 'group',
				name = "Buff Bar",
				desc = "Buff Bar",
				set = setOption,
				get = getOption,
				childGroups = "tree",
				order = 3,
				handler = VocalRaidAssistant,
				args = {
					bbarX = {
						name = "bbarX",
						desc = "bbarX",
						type = 'input',
						get = "getBBarX",
						set = "setBBarX",
						hidden = true,
					},
					bbarY = {
						name = "bbarY",
						desc = "bbarY",
						type = 'input',
						get = "getBBarY",
						set = "setBBarY",
						hidden = true,
					},
					bheightX = {
						name = "bheightX",
						desc = "bheightX",
						type = 'input',
						get = "getBHeightX",
						set = "setBHeightX",
						hidden = true,
					},
					enableBCooldownBar = {
						name = "Enable",
						desc = "Enable Buff Bar (Only Works in Raid Group)",
						type = 'toggle',
						order = 1,
						handler = VocalRaidAssistant,
					},
					moveBBars = {
						name = "Move me!",
						desc = "Click to move the position of the bar(s) - Clears all active cooldowns!",
						type = 'execute',
						order = 2,
						disabled = function() if(vradb.enableBCooldownBar) then return false else VRA:ClearBBars() return true end end,
						func = function() 
							VRA:MoveBBar("DEFENSIVE BUFF BAR!",20)
						end,
						handler = VocalRaidAssistant,
					},
					userBTest = {
						 name = "Test!",
						 desc = "Test some bars!",
						 type = 'execute',
						 order = 3,
						 disabled = function() if(vradb.enableBCooldownBar) then return false else return true end end,
						 func = function() 
								VRA:CreateBBar("Priest","64843")
								VRA:CreateBBar("Druid","740")
								VRA:CreateBBar("Monk","116849","personal")
								VRA:CreateBBar("Hunter","53480","personal")
								VRA:CreateBBar("Death Knight","51052")
								VRA:CreateBBar("Paladin","31821")
								VRA:CreateBBar("Rogue","76577")
								VRA:CreateBBar("Warrior","97462")
								VRA:CreateBBar("Shaman","98008")
						 end,
						 handler = VocalRaidAssistant,
					},
					resetBBars = {
						name = "Reset location",
						desc = "Click to reset the position of the bar(s)",
						type = 'execute',
						order = 5,
						disabled = function() if(vradb.enableCooldownBar) then return false else VRA:ClearBars() return true end end,
						func = function() 
							vradb.bbarX = 800
							vradb.bbarY = 500
						end,
						handler = VocalRaidAssistant,
					},
					forceBtest = {
						 name = "TEST!",
						 desc = "TEST!",
						 type = 'execute',
						 order = 4,
						 disabled = function() if(vradb.enableBCooldownBar) then return false else return true end end,
						 hidden = not testingactive,
						 func = function() 
								VRA:CreateBBar("Priest","64843")
								VRA:CreateBBar("Druid","740")
								VRA:CreateBBar("Death Knight","51052")
								VRA:CreateBBar("Paladin","31821")
								VRA:CreateBBar("Rogue","76577")
								VRA:CreateBBar("Warrior","97462")
								VRA:CreateBBar("Shaman","98008")
						 end,
						 handler = VocalRaidAssistant,
					},
					bBarSettings = {
						type = 'group',
						name = "Bar Settings",
						desc = "Bar Settings",
						inline = true,
						disabled = function() if(vradb.enableBCooldownBar) then return false else return true end end,
						order = -2,
						args = {
							bbarWidth = {
								type = 'range',
								max = 600,
								min = 1,
								step = 1,
								name = "Bar Width",
								desc = "Adjust Bar Width",
								get = "getBBarWidth",
								order = 1,
							},
							bbarHeight = {
								type = 'range',
								max = 75,
								min = 1,
								step = 1,
								name = "Bar Height",
								desc = "Adjust Bar Height",
								get = "getBBarHeight",
								order = 2,
							},
							bfontSize = {
								type = 'range',
								max = 28,
								min = 1,
								step = 1,
								name = "Font Size",
								desc = "Adjust Font Size",
								get = "getBFontSize",
								order = 3,
							},
							bfontType = {
								name = "Set Font",
								desc = "Set Font Type",
								type = "select",
								dialogControl = 'LSM30_Font',
								get = "getBFontType",
								values = AceGUIWidgetLSMlists.font,
								order = 4,
							},
							bbarTexture = {
								type = 'select',
								dialogControl = 'LSM30_Statusbar',
								name = "Set Bar Texture",
								desc = "Set Bar Texture",
								values = AceGUIWidgetLSMlists.statusbar,
								get = "getBBarTexture",
								order=5,
							},
							bgrowthDirection = {
								type = 'toggle',
								name = "Growth Direction",
								desc = "Active = UP \nDisabled = DOWN",
								order=6,
							},
						},
					},
					bBarAbilities = {
						type = 'group',
						name = "Bar Abilities",
						desc = "Bar Abilities",
						inline = true,
						order = -1,
						disabled = function() if(vradb.enableBCooldownBar) then return false else return true end end,
						args = {
							bspellId = {
								name = "Spell ID",
								type = "input",
								set = function(info, value) newSpellId = value end,
								get = function() return newSpellId end,
								--pattern = "^%d+$",
								order = 1,
							},
							baddCustom = {
								type = "execute",
								name = "Add New Buff",
								func = function()
									if not newSpellId then return end
									if not vradb.spellsB[newSpellId] then
										vradb.spellsB[tostring(newSpellId)] = newSpellTable()
										self:AddDataBOption(tostring(newSpellId))
										self.options.args.BuffBar.args.bBarAbilities.args.bspellId.set("","")
									else
										--self:log("Id '" .. newSpellId .. "' " .. "already exists.")
									end
								end,
								order = 2,
							},
							bdataDelete = {
								type = "execute",
								name = "Delete Custom Data",
								desc = "To delete all custom data, the addon's original data will not be changed",
								confirm = true,
								confirmText = "Are you sure to delete all custom data?",
								order = 3,
								func = function()
									local op = self.options.args.BuffBar.args
									local data = self:GetBarDataB()
									local db = vradb.spellsB
									for k, v in pairs(db) do
										if v.type == "custom" then
											db[k] = nil
											op[k] = nil
										end
									end
								end,
							},
						},
					},
				},
			},
			OffensiveCooldownBar = {
				type = 'group',
				name = "Offensive Cooldown Bar",
				desc = "Offensive Cooldown Bar",
				set = setOption,
				get = getOption,
				childGroups = "tree",
				order = 3,
				handler = VocalRaidAssistant,
				args = {
					obarX = {
						name = "obarX",
						desc = "obarX",
						type = 'input',
						get = "getOBarX",
						set = "setOBarX",
						hidden = true,
					},
					obarY = {
						name = "obarY",
						desc = "obarY",
						type = 'input',
						get = "getOBarY",
						set = "setOBarY",
						hidden = true,
					},
					oheightX = {
						name = "oheightX",
						desc = "oheightX",
						type = 'input',
						get = "getOHeightX",
						set = "setOHeightX",
						hidden = true,
					},
					enableOCooldownBar = {
						name = "Enable",
						desc = "Enable Cooldown Bar (Only Works in Raid Group)",
						type = 'toggle',
						order = 1,
						handler = VocalRaidAssistant,
					},
					moveOBars = {
						name = "Move me!",
						desc = "Click to move the position of the bar(s) - Clears all active cooldowns!",
						type = 'execute',
						order = 3,
						disabled = function() if(vradb.enableOCooldownBar) then return false else VRA:ClearOBars() return true end end,
						func = function() 
							VRA:MoveOBar("OFFENSIVE BUFF BAR!",20)
							--VRA:CreateBar("Nitrak","97462")
						end,
						handler = VocalRaidAssistant,
					},
					userOTest = {
						name = "Test!",
						desc = "Test some bars!",
						type = 'execute',
						order = 4,
						disabled = function() if(vradb.enableOCooldownBar) then return false else return true end end,
						func = function() 
								VRA:CreateOBar("Mage","80353")
								VRA:CreateOBar("Rogue","57934")
						end,
						handler = VocalRaidAssistant,
					},
					resetOBars = {
						name = "Reset location",
						desc = "Click to reset the position of the bar(s)",
						type = 'execute',
						order = 5,
						disabled = function() if(vradb.enableCooldownBar) then return false else VRA:ClearBars() return true end end,
						func = function() 
							vradb.obarX = 1000
							vradb.obarY = 500
						end,
						handler = VocalRaidAssistant,
					},
					forceOtest = {
						name = "TEST!",
						desc = "TEST!",
						type = 'execute',
						disabled = function() if(vradb.enableOCooldownBar) then return false else return true end end,
						hidden = not testingactive,
						func = function() 
								VRA:CreateOBar("Mage","80353")
						end,
						handler = VocalRaidAssistant,
					},
					oBarSettings = {
						type = 'group',
						name = "Bar Settings",
						desc = "Bar Settings",
						inline = true,
						disabled = function() if(vradb.enableOCooldownBar) then return false else return true end end,
						order = -2,
						args = {
							obarWidth = {
								type = 'range',
								max = 600,
								min = 1,
								step = 1,
								name = "Bar Width",
								desc = "Adjust Bar Width",
								get = "getOBarWidth",
								order = 1,
							},
							obarHeight = {
								type = 'range',
								max = 75,
								min = 1,
								step = 1,
								name = "Bar Height",
								desc = "Adjust Bar Height",
								get = "getOBarHeight",
								order = 2,
							},
							ofontSize = {
								type = 'range',
								max = 28,
								min = 1,
								step = 1,
								name = "Font Size",
								desc = "Adjust Font Size",
								get = "getOFontSize",
								order = 3,
							},
							ofontType = {
								name = "Set Font",
								desc = "Set Font Type",
								type = "select",
								dialogControl = 'LSM30_Font',
								get = "getOFontType",
								values = AceGUIWidgetLSMlists.font,
								order = 4,
							},
							obarTexture = {
								type = 'select',
								dialogControl = 'LSM30_Statusbar',
								name = "Set Bar Texture",
								desc = "Set Bar Texture",
								values = AceGUIWidgetLSMlists.statusbar,
								get = "getOBarTexture",
								order=5,
							},
							ogrowthDirection = {
								type = 'toggle',
								name = "Growth Direction",
								desc = "Active = UP \nDisabled = DOWN",
								order=6,
							},
						},
					},
					oBarAbilities = {
						type = 'group',
						name = "Bar Abilities",
						desc = "Bar Abilities",
						inline = true,
						order = -1,
						disabled = function() if(vradb.enableOCooldownBar) then return false else return true end end,
						args = {
							ospellId = {
								name = "Spell ID",
								type = "input",
								set = function(info, value) newSpellId = value end,
								get = function() return newSpellId end,
								--pattern = "^%d+$",
								order = 1,
							},
							oaddCustom = {
								type = "execute",
								name = "Add New Buff",
								func = function()
									if not newSpellId then return end
									if not vradb.spellsO[newSpellId] then
										vradb.spellsO[tostring(newSpellId)] = newSpellTable()
										self:AddDataOOption(tostring(newSpellId))
										self.options.args.OffensiveCooldownBar.args.oBarAbilities.args.ospellId.set("","")
									else
										--self:log("Id '" .. newSpellId .. "' " .. "already exists.")
									end
								end,
								order = 2,
							},
							odataDelete = {
								type = "execute",
								name = "Delete Custom Data",
								desc = "To delete all custom data, the addon's original data will not be changed",
								confirm = true,
								confirmText = "Are you sure to delete all custom data?",
								order = 3,
								func = function()
									local op = self.options.args.OffensiveCooldownBar.args
									local data = self:GetBarDataO()
									local db = vradb.spellsO
									for k, v in pairs(db) do
										if v.type == "custom" then
											db[k] = nil
											op[k] = nil
										end
									end
								end,
							},
						},
					},
				},
			},
			IndividualAssingment = {
				type = 'group',
				name = "Individual Assingment",
				desc = L["Abilities options"],
				set = setOption,
				get = getOption,
				childGroups = "tab",
				order = 3,
				args = {
					Individual = {
						type = 'group',
						name = "Target specific",
						desc = "Buffs on Specialization",
						inline = true,
						order = -2,
						args = {
							raid1 = {
								type = 'toggle',
								name = function() return rosterInfoArray[1] end,
								desc = "Check this will alert for buff applied to this player",
								order = 1,
								disabled = function() return (rosterInfoArray[1] == "") end,
								hidden = function() return (rosterInfoArray[1] == "") end,
							},
							raid2 = {
								type = 'toggle',
								name = function() return rosterInfoArray[2] end,
								desc = "Check this will alert for buff applied to this player",
								order = 2,
								disabled = function() return (rosterInfoArray[2] == "") end,
								hidden = function() return (rosterInfoArray[2] == "") end,
							},
							raid3 = {
								type = 'toggle',
								name = function() return rosterInfoArray[3] end,
								desc = "Check this will alert for buff applied to this player",
								order = 3,
								disabled = function() return (rosterInfoArray[3] == "") end,
								hidden = function() return (rosterInfoArray[3] == "") end,
							},
							raid4 = {
								type = 'toggle',
								name = function() return rosterInfoArray[4] end,
								desc = "Check this will alert for buff applied to this player",
								order = 4,
								disabled = function() return (rosterInfoArray[4] == "") end,
								hidden = function() return (rosterInfoArray[4] == "") end,
							},
							raid5 = {
								type = 'toggle',
								name = function() return rosterInfoArray[5] end,
								desc = "Check this will alert for buff applied to this player",
								order = 5,
								disabled = function() return (rosterInfoArray[5] == "") end,
								hidden = function() return (rosterInfoArray[5] == "") end,
							},
							raid6 = {
								type = 'toggle',
								name = function() return rosterInfoArray[6] end,
								desc = "Check this will alert for buff applied to this player",
								order = 6,
								disabled = function() return (rosterInfoArray[6] == "") end,
								hidden = function() return (rosterInfoArray[6] == "") end,
							},
							raid7 = {
								type = 'toggle',
								name = function() return rosterInfoArray[7] end,
								desc = "Check this will alert for buff applied to this player",
								order = 7,
								disabled = function() return (rosterInfoArray[7] == "") end,
								hidden = function() return (rosterInfoArray[7] == "") end,
							},
							raid8 = {
								type = 'toggle',
								name = function() return rosterInfoArray[8] end,
								desc = "Check this will alert for buff applied to this player",
								order = 8,
								disabled = function() return (rosterInfoArray[8] == "") end,
								hidden = function() return (rosterInfoArray[8] == "") end,
							},
							raid9 = {
								type = 'toggle',
								name = function() return rosterInfoArray[9] end,
								desc = "Check this will alert for buff applied to this player",
								order = 9,
								disabled = function() return (rosterInfoArray[9] == "") end,
								hidden = function() return (rosterInfoArray[9] == "") end,
							},
							raid10 = {
								type = 'toggle',
								name = function() return rosterInfoArray[10] end,
								desc = "Check this will alert for buff applied to this player",
								order = 10,
								disabled = function() return (rosterInfoArray[10] == "") end,
								hidden = function() return (rosterInfoArray[10] == "") end,
							},
							raid11 = {
								type = 'toggle',
								name = function() return rosterInfoArray[11] end,
								desc = "Check this will alert for buff applied to this player",
								order = 11,
								disabled = function() return (rosterInfoArray[11] == "") end,
								hidden = function() return (rosterInfoArray[11] == "") end,
							},
							raid12 = {
								type = 'toggle',
								name = function() return rosterInfoArray[12] end,
								desc = "Check this will alert for buff applied to this player",
								order = 12,
								disabled = function() return (rosterInfoArray[12] == "") end,
								hidden = function() return (rosterInfoArray[12] == "") end,
							},
							raid13 = {
								type = 'toggle',
								name = function() return rosterInfoArray[13] end,
								desc = "Check this will alert for buff applied to this player",
								order = 13,
								disabled = function() return (rosterInfoArray[13] == "") end,
								hidden = function() return (rosterInfoArray[13] == "") end,
							},
							raid14 = {
								type = 'toggle',
								name = function() return rosterInfoArray[14] end,
								desc = "Check this will alert for buff applied to this player",
								order = 14,
								disabled = function() return (rosterInfoArray[14] == "") end,
								hidden = function() return (rosterInfoArray[14] == "") end,
							},
							raid15 = {
								type = 'toggle',
								name = function() return rosterInfoArray[15] end,
								desc = "Check this will alert for buff applied to this player",
								order = 15,
								disabled = function() return (rosterInfoArray[15] == "") end,
								hidden = function() return (rosterInfoArray[15] == "") end,
							},
							raid16 = {
								type = 'toggle',
								name = function() return rosterInfoArray[16] end,
								desc = "Check this will alert for buff applied to this player",
								order = 16,
								disabled = function() return (rosterInfoArray[16] == "") end,
								hidden = function() return (rosterInfoArray[16] == "") end,
							},
							raid17 = {
								type = 'toggle',
								name = function() return rosterInfoArray[17] end,
								desc = "Check this will alert for buff applied to this player",
								order = 17,
								disabled = function() return (rosterInfoArray[17] == "") end,
								hidden = function() return (rosterInfoArray[17] == "") end,
							},
							raid18 = {
								type = 'toggle',
								name = function() return rosterInfoArray[18] end,
								desc = "Check this will alert for buff applied to this player",
								order = 18,
								disabled = function() return (rosterInfoArray[18] == "") end,
								hidden = function() return (rosterInfoArray[18] == "") end,
							},
							raid19 = {
								type = 'toggle',
								name = function() return rosterInfoArray[19] end,
								desc = "Check this will alert for buff applied to this player",
								order = 19,
								disabled = function() return (rosterInfoArray[19] == "") end,
								hidden = function() return (rosterInfoArray[19] == "") end,
							},
							raid20 = {
								type = 'toggle',
								name = function() return rosterInfoArray[20] end,
								desc = "Check this will alert for buff applied to this player",
								order = 20,
								disabled = function() return (rosterInfoArray[20] == "") end,
								hidden = function() return (rosterInfoArray[20] == "") end,
							},
							raid21 = {
								type = 'toggle',
								name = function() return rosterInfoArray[21] end,
								desc = "Check this will alert for buff applied to this player",
								order = 21,
								disabled = function() return (rosterInfoArray[21] == "") end,
								hidden = function() return (rosterInfoArray[21] == "") end,
							},
							raid22 = {
								type = 'toggle',
								name = function() return rosterInfoArray[22] end,
								desc = "Check this will alert for buff applied to this player",
								order = 22,
								disabled = function() return (rosterInfoArray[22] == "") end,
								hidden = function() return (rosterInfoArray[22] == "") end,
							},
							raid23 = {
								type = 'toggle',
								name = function() return rosterInfoArray[23] end,
								desc = "Check this will alert for buff applied to this player",
								order = 23,
								disabled = function() return (rosterInfoArray[23] == "") end,
								hidden = function() return (rosterInfoArray[23] == "") end,
							},
							raid24 = {
								type = 'toggle',
								name = function() return rosterInfoArray[24] end,
								desc = "Check this will alert for buff applied to this player",
								order = 24,
								disabled = function() return (rosterInfoArray[24] == "") end,
								hidden = function() return (rosterInfoArray[24] == "") end,
							},
							raid25 = {
								type = 'toggle',
								name = function() return rosterInfoArray[25] end,
								desc = "Check this will alert for buff applied to this player",
								order = 25,
								disabled = function() return (rosterInfoArray[25] == "") end,
								hidden = function() return (rosterInfoArray[25] == "") end,
							},
							raid26 = {
								type = 'toggle',
								name = function() return rosterInfoArray[26] end,
								desc = "Check this will alert for buff applied to this player",
								order = 26,
								disabled = function() return (rosterInfoArray[26] == "") end,
								hidden = function() return (rosterInfoArray[26] == "") end,
							},
							raid27 = {
								type = 'toggle',
								name = function() return rosterInfoArray[27] end,
								desc = "Check this will alert for buff applied to this player",
								order = 27,
								disabled = function() return (rosterInfoArray[27] == "") end,
								hidden = function() return (rosterInfoArray[27] == "") end,
							},
							raid28 = {
								type = 'toggle',
								name = function() return rosterInfoArray[28] end,
								desc = "Check this will alert for buff applied to this player",
								order = 28,
								disabled = function() return (rosterInfoArray[28] == "") end,
								hidden = function() return (rosterInfoArray[28] == "") end,
							},
							raid29 = {
								type = 'toggle',
								name = function() return rosterInfoArray[29] end,
								desc = "Check this will alert for buff applied to this player",
								order = 29,
								disabled = function() return (rosterInfoArray[29] == "") end,
								hidden = function() return (rosterInfoArray[29] == "") end,
							},
							raid30 = {
								type = 'toggle',
								name = function() return rosterInfoArray[30] end,
								desc = "Check this will alert for buff applied to this player",
								order = 30,
								disabled = function() return (rosterInfoArray[30] == "") end,
								hidden = function() return (rosterInfoArray[30] == "") end,
							},
							raid31 = {
								type = 'toggle',
								name = function() return rosterInfoArray[31] end,
								desc = "Check this will alert for buff applied to this player",
								order = 31,
								disabled = function() return (rosterInfoArray[31] == "") end,
								hidden = function() return (rosterInfoArray[31] == "") end,
							},
							raid32 = {
								type = 'toggle',
								name = function() return rosterInfoArray[32] end,
								desc = "Check this will alert for buff applied to this player",
								order = 32,
								disabled = function() return (rosterInfoArray[32] == "") end,
								hidden = function() return (rosterInfoArray[32] == "") end,
							},
							raid33 = {
								type = 'toggle',
								name = function() return rosterInfoArray[33] end,
								desc = "Check this will alert for buff applied to this player",
								order = 33,
								disabled = function() return (rosterInfoArray[33] == "") end,
								hidden = function() return (rosterInfoArray[33] == "") end,
							},
							raid34 = {
								type = 'toggle',
								name = function() return rosterInfoArray[34] end,
								desc = "Check this will alert for buff applied to this player",
								order = 34,
								disabled = function() return (rosterInfoArray[34] == "") end,
								hidden = function() return (rosterInfoArray[34] == "") end,
							},
							raid35 = {
								type = 'toggle',
								name = function() return rosterInfoArray[35] end,
								desc = "Check this will alert for buff applied to this player",
								order = 35,
								disabled = function() return (rosterInfoArray[35] == "") end,
								hidden = function() return (rosterInfoArray[35] == "") end,
							},
							raid36 = {
								type = 'toggle',
								name = function() return rosterInfoArray[36] end,
								desc = "Check this will alert for buff applied to this player",
								order = 36,
								disabled = function() return (rosterInfoArray[36] == "") end,
								hidden = function() return (rosterInfoArray[36] == "") end,
							},
							raid37 = {
								type = 'toggle',
								name = function() return rosterInfoArray[37] end,
								desc = "Check this will alert for buff applied to this player",
								order = 37,
								disabled = function() return (rosterInfoArray[37] == "") end,
								hidden = function() return (rosterInfoArray[37] == "") end,
							},
							raid38 = {
								type = 'toggle',
								name = function() return rosterInfoArray[38] end,
								desc = "Check this will alert for buff applied to this player",
								order = 38,
								disabled = function() return (rosterInfoArray[38] == "") end,
								hidden = function() return (rosterInfoArray[38] == "") end,
							},
							raid39 = {
								type = 'toggle',
								name = function() return rosterInfoArray[39] end,
								desc = "Check this will alert for buff applied to this player",
								order = 39,
								disabled = function() return (rosterInfoArray[39] == "") end,
								hidden = function() return (rosterInfoArray[39] == "") end,
							},
							raid40 = {
								type = 'toggle',
								name = function() return rosterInfoArray[40] end,
								desc = "Check this will alert for buff applied to this player",
								order = 40,
								disabled = function() return (rosterInfoArray[40] == "") end,
								hidden = function() return (rosterInfoArray[40] == "") end,
							},
						},
					},
					forcerefresh = {
						name = "Force refresh",
						desc = "Force refresh of roster (If for some reason it is wrong)",
						type = 'execute',
						func = function() 
							self:UpdateRoster()
						end,
						handler = VocalRaidAssistant,
					},
				},
			},
			custom = {
				type = 'group',
				name = L["Custom"],
				desc = L["Custom Spell"],
				order = 4,
				args = {
					newalert = {
						type = 'execute',
						name = L["New Sound Alert"],
						order = -1,

						func = function()
							vradb.custom[L["New Sound Alert"]] = {
								name = L["New Sound Alert"],
								soundfilepath = "Interface\\VRASound\\"..L["New Sound Alert"]..".ogg",
								sourceuidfilter = "any",
								destuidfilter = "any",
								eventtype = {
									SPELL_CAST_SUCCESS = true,
									SPELL_CAST_START = false,
									SPELL_AURA_APPLIED = false,
									SPELL_AURA_REMOVED = false,
									SPELL_INTERRUPT = false,
								},
								sourcetypefilter = COMBATLOG_FILTER_EVERYTHING,
								desttypefilter = COMBATLOG_FILTER_EVERYTHING,
								order = 0,
							}
							self:MakeCustomOption(L["New Sound Alert"])
						end,
						disabled = function()
							if vradb.custom[L["New Sound Alert"]] then
								return true
							else
								return false
							end
						end,
					}
				}
			}
		}
	}
	for k, v in pairs(vradb.custom) do
		self:MakeCustomOption(k)
	end	
	AceConfig:RegisterOptionsTable("VocalRaidAssistant", self.options)
	self:AddOption(L["General"], "general")
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db1)
	self.options.args.profiles.order = -1
	
	self:AddOption(L["Abilities"], "spells")
	self:AddOption("Individual Assignment", "IndividualAssingment")
	self:AddOption("Cooldown Bar", "CooldownBar")
	self:AddOption("Defensive Buff Bar", "BuffBar")
	self:AddOption("Offensive Buff Bar", "OffensiveCooldownBar")
	self:AddOption(L["Custom"], "custom")
	self:AddOption(L["Profiles"], "profiles")
end
