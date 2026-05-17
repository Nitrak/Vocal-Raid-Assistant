local _, addon = ...

-- We depend on MiniCC now, they already implemented all the logic to get spell info from frames.
if not MiniCCApi then
    print("|cFFFF0000[VocalRaidAssistant]|r MiniCC addon is required but not loaded.")
    return
end

local MiniCCApi = MiniCCApi.v1

local function playsound_cb(_, spellId)
	addon:playSpell(spellId)
end

MiniCCApi:RegisterPredictedCallback(playsound_cb)

