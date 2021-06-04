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
local first = true
local raidMaxSize = 40
local playerSpell = {}
local locked = false

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

function VRA:SetFont(font)
	return LSM:Fetch("font", font, true)
end

function VRA:SetFont(font)
	return LSM:Fetch("font", font, true)
end

local function ArraySize(array)

	local Count = 0
	for Index, Value in pairs( array ) do
		Count = Count + 1
	end
	
	return Count

end

function VRA:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(GetAddOnMetadata("VocalRaidAssistant", "Title"))
	InterfaceOptionsFrame_OpenToCategory(GetAddOnMetadata("VocalRaidAssistant", "Title"))
end

function VRA:ChangeProfile()
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
	for i=1,raidMaxSize do
		rosterStatusOldArray[i] = vradb["raid" .. tostring(i)]
		if GetRaidRosterInfo(i) ~= nil then
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
		vradb["raid" .. tostring(i)] = rosterStatusArray[i]
	end
	
	if(testnull == 1) then
	LibStub("AceConfigRegistry-3.0"):NotifyChange("VocalRaidAssistant")
	else 
	testnull = 1
	end
	
end

function VRA:IsSelected(name)
	for i=1,raidMaxSize do
		rosterStatusOldArray[1] = vradb["raid" .. tostring(i)]
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

local function raidOptions()
	args = {}
	
	for i=1,raidMaxSize do
		args["raid" .. tostring(i)] = {
			type = 'toggle',
			name = function() return rosterInfoArray[i] end,
			desc = "Check this will alert for buff applied to this player",
			order = i,
			disabled = function() return (rosterInfoArray[i] == "") end,
			hidden = function() return (rosterInfoArray[i] == "") end,
		}
	end

	return args
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

local function spellDescription(order, spellID)
	local spellname, _, icon = GetSpellInfo(spellID)
	if (spellID == nil) then
		return {
			type = 'description',
			name = "empty spell id",	
			order = order,
		}
	end

	if (spellname ~= nil) then
		return {
			type = 'description',
			name = "\124T" .. icon .. ":24\124t" .. spellname,							
			desc = function () 
				GameTooltip:SetHyperlink(GetSpellLink(spellID));
			end,
			descStyle = "custom",
					order = order,
		}
	end
		
	VRA.log("spell id: " .. spellID .. " is invalid")
	return {
		type = 'description',
		name = "unknown spell, id:" .. spellID,	
		order = order,
	}
end

local function listOption(spellList, listType, ...)
	local args = {}
	for k, v in pairs(spellList) do
		if VRA.spellList[listType][v] then
			rawset (args, VRA.spellList[listType][v] ,spellOption(k, v))
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
			enabled = {
				type = 'toggle',
				order = 5,
				name = L["enabled"],
			},
			spellIcon = spellDescription(6, db[key].spellid),
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
								args = listOption({102342,22812,61336,33891,102558,192081,29166},"auraApplied"),	
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
								args = listOption({190319,110909},"auraApplied"),
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
							priest	= {
								type = 'group',
								inline = true,
								name = L["|cffFFFFFFPriest|r"],
								order = 12,
								args = listOption({33206,47788,10060},"auraApplied"),
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
							priest	= {
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
							priest	= {
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
						args = raidOptions(),
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
								enabled = true,
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
	self:AddOption(L["Custom"], "custom")
	self:AddOption(L["Profiles"], "profiles")
end
