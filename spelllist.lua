local _, addon = ...

-- Info: The strings assigned to the spellIds are only used for external sound file generation script
local spellList = {
    ["DEATHKNIGHT"] = {
        [51052] = "Anti Magic Zone",
        [61999] = "Raise Ally!",
        [108199] = "Gorefiend's Grasp!",
        [315443] = "Abomination Limb!",
        [48792] = "Icebound",
        [49028] = "dancing runeweapon",
        [55233] = "vampiric blood",
        [48707] = "anti magic shell",
        [221562] = "asphyxiate",
        [49576] = "deathgrip",
        [42650] = "army of the dead",
        [194844] = "bonestorm",
        [194679] = "runetap",
        [219809] = "tombstone"
    },
    ["DEMONHUNTER"] = {
        [196718] = "darkness",
        [179057] = "chaosnova",
        [202137] = "sigil of silence",
        [207684] = "sigil of misery",
        [202138] = "sigil of chains",
        [329554] = "fodder to the flame",
        [206491] = "nemesis",
        [198589] = "blur",
        [217832] = "imprison",
        [204021] = "fiery brand",
        [187827] = "metamorphosis",
        [211881] = "fel eruption"
    },
    ["DRUID"] = {
        [740] = "tranquility",
        [2908] = "soothe",
        [106898] = "stampeding roar",
        [77764] = "stampeding roar", -- cat
        [77761] = "stampeding roar", -- bear
        [20484] = "rebirth",
        [197721] = "flourish",
        [102793] = "ursols vortex",
        [323764] = "convoke",
        [205636] = "force of nature",
        [323546] = "ravenous frenzy",
        [102342] = "ironbark",
        [22812] = "barkskin",
        [61336] = "survival instincts",
        [33891] = "incarnation tree", -- resto
        [102558] = "incarnation bear", -- guardian
        [29166] = "innervate",
        [33786] = "cyclone"
    },
    ["HUNTER"] = {
        [264667] = "primalrage",
        [109248] = "binding shot",
        [328231] = "wild spirits",
        [34477] = "misdirection",
        [53480] = "roar of sacrifice",
        [187650] = "freezing trap",
        [193530] = "Aspect of the Wild",
        [281195] = "Survival of the Fittest",
    },
    ["MAGE"] = {
        [80353] = "timewarp",
        [321507] = "touch of the magi",
        [118] = "polymorph",
        [12472] = "icy veins",
        [12042] = "arcane power",
        [45438] = "Ice Block",
        [55342] = "Mirror Image",
        [86949] = "cauterize",
        [190319] = "combustion",
        [110909] = "alter time",
    },
    ["MONK"] = {
        [115310] = "revival",
        [119381] = "leg sweep",
        [116844] = "ring of peace",
        [310454] = "weapons of order",
        [322109] = "touch of death",
        [116849] = "life cocoon",
        [115203] = "fortifying brew",
        [122278] = "dampen harm",
        [122783] = "diffuse magic",
        [115176] = "zen meditation",
        [325197] = "invoke chiji",
        [115078] = "paralysis",
        [326860] = "Fallen Order"
    },
    ["PALADIN"] = {
        [498] = "Divine Protection",
        [31821] = "aura mastery",
        [633] = "lay on hands",
        [316958] = "ashen hallow",
        [304971] = "divine toll",
        [1022] = "blessing of protection",
        [6940] = "sacrifice",
        [86659] = "guardian of ancient kings",
        [31850] = "ardent defender",
        [204018] = "spellwarding",
        [642] = "divine shield",
        [31884] = "avenging wrath",
        [216331] = "avenging crusader",
        [105809] = "holy avenger",
        [853] = "hammer of justice",
        [20066] = "repentance"
    },
    ["PRIEST"] = {
        [8122] = "psychic scream",
        [10060] = "power infusion",
        [15286] = "vampiric embrace",
        [19236] = "Desperate Prayer",
        [32375] = "massdispel",
        [33206] = "pain suppression",
        [34433] = "shadowfiend",
        [47536] = "rapture",
        [47788] = "guardian spirit",
        [62618] = "barrier",
        [64843] = "divine hymn",
        [64901] = "symbol of hope",
        [73325] = "leap of faith",
        [109964] = "spiritshell",
        [200183] = "apotheosis",
        [205369] = "mindbomb",
        [228260] = "void eruption",
        [246287] = "evangelism",
        [265202] = "salvation",
        [271466] = "luminous barrier",
        [323673] = "mindgames",
        [325013] = "boon of the ascended"
    },
    ["ROGUE"] = {
        [76577] = "smoke Bomb",
        [57934] = "tricks of the trade",
        [2094] = "blind",
        [31224] = "cloak of shadows",
        [13750] = "adrenalin rush",
        [1966] = "Feint",
        [5277] = "Evasion",
        [185311] = "Crimson Vial",
    },
    ["SHAMAN"] = {
        [16191] = "manatide",
        [98008] = "spiritlink-totem",
        [108280] = "healing tide",
        [2825] = "bloodlust",
        [32182] = "heroism",
        [192077] = "windrush-totem",
        [8143] = "tremor totem",
        [207399] = "ancestral protection",
        [198838] = "earthenshield-totem",
        [192058] = "lightningsurge-totem",
        [320674] = "chainharvest",
        [328923] = "fae transfusion",
        [326059] = "primordial wave",
        [324386] = "vesper-totem",
        [114052] = "ascendance",
        [79206] = "spiritwalker",
        [51514] = "hex",
        [108271] = "Astralshift"
    },
    ["WARLOCK"] = {
        [20707] = "soulstone",
        [30283] = "shadowfury",
        [104773] = "Unending Resolve",
        [108416] = "Dark Pact",
        [111771] = "gateway",
        [5782] = "fear"
    },
    ["WARRIOR"] = {
        [97462] = "rallying cry",
        [1160] = "demoralizing shout",
        [228920] = "ravager",
        [46968] = "shockwave",
        [871] = "shieldwall",
        [12975] = "laststand",
        [118038] = "die by the sword",
        [190456] = "ignore pain",
        [2565] = "shieldblock",
        [5246] = "intimidating shout",
        [23920] = "spell reflection"
    },
    ["general"] = {
        [20594] = "stoneform",
        [107079] = "quaking palm",
        [58984] = "shadowmeld",
        [178207] = "drums",
        [323436] = "purify soul",
    }
}

local interruptList = {
    [19647] = "countered!", -- Spell Lock
    [2139] = "countered!", -- Counter Spell
    [1766] = "countered!", -- Kick
    [6552] = "countered!", -- Pummel
    [47528] = "countered!", -- Mind Freeze
    [96231] = "countered!", -- Rebuke
    [93985] = "countered!", -- Skull Bash
    [97547] = "countered!", -- Solar Beam
    [57994] = "countered!", -- Wind Shear
    [116705] = "countered!", -- Spear Hand Strike
    [113287] = "countered!", -- Symbiosis Solar Beam
    [147362] = "countered!", -- Counter Shot
    [34490] = "countered!", -- Silencing Shot
    [183752] = "countered!", -- Consume Magic
    [187707] = "countered!" -- Muzzle
}

function addon:GetAllSpellIds()
    local spells = {}
    for _, v in pairs(spellList) do
        for k, v in pairs(v) do
            spells[k] = v
        end
    end
    return spells
end

function addon:GetSpellIdsByClass(name)
    return spellList[name]
end

function addon:GetInterruptSpellIds()
    local spells = {}
    for k, v in pairs(interruptList) do
        spells[k] = v
    end
    return spells
end

