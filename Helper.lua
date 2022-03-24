local _, addon = ...
local L = addon.L

local intendedWoWProject = WOW_PROJECT_MAINLINE

function addon:IsClassic()
  return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end

function addon:IsBCC()
  return WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
end

function addon:IsRetail()
  return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

function addon:IsCorrectVersion()
  return intendedWoWProject == WOW_PROJECT_ID
end

addon.prettyPrint = function(...)
  print("|c00ff0000Vocal Raid Assistant:|r ", ...)
end

local intendedWoWProjectName = {
  [WOW_PROJECT_MAINLINE] = "Retail",
  [WOW_PROJECT_CLASSIC] = "Classic",
  [WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5] = "The Burning Crusade Classic"
}

addon.wrongTargetMessage = "This version of VRA was packaged for World of Warcraft " .. intendedWoWProjectName[intendedWoWProject] ..
                              ". Please install the " .. intendedWoWProjectName[WOW_PROJECT_ID] ..
                              " version instead.\nIf you are using an addon manager, then" ..
                              " contact their support for further assistance and reinstall VRA manually."

if not addon.IsCorrectVersion() then --Wait 10 seconds then error message
  C_Timer.After(10, function() addon.prettyPrint(addon.wrongTargetMessage) end)
end