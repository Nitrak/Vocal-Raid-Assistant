local L = LibStub("AceLocale-3.0"):NewLocale("VocalRaidAssistant", "enUS",true)
if not L then return end

L["Main Options"] = "Main Options"
L["MAIN_OPTIONS_DESC"] = "Main Options test"
L["GET_VERSION"] = GetAddOnMetadata("VocalRaidAssistant", "Version")
L["Vocal Raid Assistant"] = "Vocal Raid Assistant"
L["VOCAL_RAID_ASSISTANCE_DESC"] = ""
L["Version"] = "Version/Changelog"
L["VERSION_DESC"] = ""
L["Discord"] = "Discord"
L["Discord_Info"] = ""
L["DISCORD_HEADER"] = "Discord"
L["DISCORD_DESCRIPTION"] = "To join the Vocal Raid Assistant community please visit the official Discord server and chime in!"
L["1.6.5 Changelog"] = "Added abilities" .. 
"\n" .. " - Force of Nature"
L["1.6.4 Changelog"] = "Added abilities" .. 
"\n" .. " - Boon of the Ascended" .. 
"\n" .. " - Convoke the Spirits" .. 
"\n" .. " - Ashen Hallow" .. 
"\n" .. " - Chain Harvest" .. 
"\n" .. " - Mindgames " .. 
"\n" .. " - Fae Transfusion" .. 
"\n" .. " - Primordial Wave" .. 
"\n" .. " - Weapons of Order" .. 
"\n" .. " - Divine Toll" .. 
"\n" .. " - Vesper Totem" .. 
"\n" .. " - Fae Guardians" .. 
"\n" .. " - Fodder to the Flame" .. 
"\n" .. " - Abomination Limb" .. 
"\n" .. " - Purify Soul" .. 
"\n" .. " - Fleshcraft" .. 
"\n" .. " - Spirit Shell"
L["1.6.3 Changelog"] = "Added abilities" .. "\n" .. " - Spell reflection" .. "\n" .. " - Shadowmeld" .. "\n" .. " - Ursols Vortex" .. "\n" .. " - Flourish (Off by default)" .. "\n" .. " - Rallying Cry"
L["1.6.2 Changelog"] = "Shadowlands hotfix to make addon functional." .. "\n" .. "Further update will come with update of abilities."
L["1.6.1 Changelog"] = "Fixed a misspelled ability" .. "\n" .. "Actually Moved Crowd Control abilities to a separate section" .. "\n" .. "Added Abilities (On/Off by default):" .. "\n" .. "  - Holy Avenger (On)"
L["1.6.0 Changelog"] = "Added option to swap audio channel" .. "\n" .. "Moved Crowd Control abilities to a separate section"
L["1.5.1 Changelog"] = "Added missing fonts" .. "\n" .. "Added Abilities (On/Off by default):" .. "\n" .. " - Asphyxiate" .. "\n" .. " - Fel Eruption" .. "\n" .. " - Death Grip"
L["1.5.0.1 Changelog"] = "Fixed function call"
L["1.5 Changelog"] = "Added ability to only track buffs applied to player" .. "\n" .. "Moved Innervate to Individual Buff" .. "\n" .. "Moved Aegies of Light to Special Ability" .. "\n" .. "Added Abilities (On/Off by default):" .. "\n" .. "  - Sigil of Silence (On)" .. "\n" .. "  - Sigil of Misery (On)" .. "\n" .. "  - Sigil of Chains (On)" .. "\n" .. "  - Ring of Peace (On)" .. "\n" .. "  - Shadowfiend-Disc (Off)" .. "\n" .. "  - Evangelism (Off)" .. "\n" .. "  - Leap of Faith (On) (Says Grip, since much shorter)" .. "\n" .. "  - Apotheosis (On)" .. "\n" .. "  - Luminous Barrier (On)" .. "\n" .. "  - Rapture (On)" .. "\n" .. "  - Blind (On)" .. "\n" .. "  - Hex (On)" .. "\n" .. "  - Polymorph (On)" .. "\n" .. "  - Fear (On)" .. "\n" .. "  - Psychic Scream (On)" .. "\n" .. "  - Intimidating Shout (On)" .. "\n" .. "  - Hammer of Justice (On) (Says Hodje, as HoJ abbreviation is commonly used)" .. "\n" .. "  - Blessing of Spellwarding (On)" .. "\n" .. "  - Repentance (On)" .. "\n" .. "  - Paralysis (On)" .. "\n" .. "  - Freezing Trap (On)" .. "\n" .. "  - Cyclone (On)" .. "\n" .. "  - Imprison (On)" .. "\n" .. "  - Quaking Palm (On)"
L["1.4.4 Changelog"] = "Removed debug statement."
L["1.4.3 Changelog"] = "Fixed incorrect function call."
L["1.4.2 Changelog"] = "Made functioning with new event system." .. "\n" .. "Added Holy Word: Salvation"
L["1.4.1 Changelog"] = "Version fix"
L["1.4.0 Changelog"] = "Made compatible with Battle for Azeroth." .. "\n" .. "Removed a lot of abilities and added new ones."
L["1.3.9 Changelog"] = "Added Demonic Gateway"
L["1.3.8 Changelog"] = "Changed Hand of Protection to Protection." .. "\n" .. "Added Drums of Fury to defaults for Offensive Buff Bar"
L["1.3.7 Changelog"] = "Removed few spells: " .. "\n" .. "  - Removed Bristling Fur, as it is not longer a mitigation cooldown" .. "\n" .. "  - Removed Vigilance as it is no longer in the game" .. "\n" .. "Removed empty classes." .. "\n" .. "Added some fixes for bars from spells cast by yourself on yourself."
L["1.3.6 Changelog"] = "Added Mind Bomb."
L["1.3.5 Changelog"] = "Added AoE stun abilities for making Mythic Plus easier." .. "\n" .. "Fixed volume on Gift of the Queen" .. "\n" .. "Enabled the ability to disable Darkness" .. "\n" .. "You are now able to MOVE the Defensive Buff Bar" .. "\n" .. "You are now able to reset the position of the bars if they somehow managed to escape your screen!"
L["1.3.4 Changelog"] = "Added interrupt announcing for Demon Hunters and Survival Hunter." .. "\n" .. "Fixed missing name entry for Demon Hunters"
L["1.3.3 Changelog"] = "Updated spells to match legion cooldowns." .. "\n" .. "Added abilities:" .. "\n" .. "  - Blood Mirror" .. "\n" .. "  - Bonestorm" .. "\n" .. "  - Tombstone" .. "\n" .. "  - Blur" .. "\n" .. "  - Darkness" .. "\n" .. "  - Fiery Brand" .. "\n" .. "  - Metamorphosis" .. "\n" .. "  - Nether Bond" .. "\n" .. "  - Soul Carver" .. "\n" .. "  - Innervate" .. "\n" .. "  - Ironfur" .. "\n" .. "  - Rage of the Sleeper" .. "\n" .. "  - Essence of G'Hanir" .. "\n" .. "  - Dampen Harm" .. "\n" .. "  - Diffuse Magic" .. "\n" .. "  - Zen Meditation" .. "\n" .. "  - Invoke Chi-Ji" .. "\n" .. "  - Sheilun's Gift" .. "\n" .. "  - Tyr's Deliverance" .. "\n" .. "  - Aegis of Light" .. "\n" .. "  - Eye of Tyr" .. "\n" .. "  - Light's Wrath" .. "\n" .. "  - Light of T'uure" .. "\n" .. "  - Wind Rush Totem" .. "\n" .. "  - Earthen Shield Totem" .. "\n" .. "  - Gift of the Queen" .. "\n" .. "  - Commanding Shout" .. "\n" .. "  - Die by the Sword" .. "\n" .. "  - Ignore Pain" .. "\n" .. "  - Neltharion's Fury" .. "\n" .. "  - Ravager" .. "\n" .. "  - Shield Block"
L["1.3.2 Changelog"] = "Hotfix to work for LEGION. Will update fully soon."
L["1.3.1 Changelog"] = "Fixed bug where bars would show for spells you cast yourself" .. "\n" .. "Fixed error when using new profile until a reload is done" .. "\n" .. "Added Reload of UI after profile swap to sort inconsistencies"
L["1.3 Changelog"] = "Reimplemented bar system" .. "\n" .. "Sorted out logic such that bars will only exist within your own group." .. "\n" .. "Still need to fix issue that bars are not correctly reset after boss kill/reset." .. "\n" .. "Removed abilities:" .. "\n" .. "  - Aspect of the Fox" .. "\n" .. "  - Amplify Magic"
L["1.2.2 Changelog"] = "Small bugfix - stopped calling method that does not exist"
L["1.2.1 Changelog"] = "Small logical bugfix so player will not hear own cast on tanks" .. "\n" .. "Added abilities:" .. "\n" .. "  - Nature's Vigil" .. "\n" .. "  - Guard" .. "\n" .. "  - Incarnation: Tree of Life" .. "\n" .."  - Sacred Shield".. "\n" .."  - Eternal Flame".. "\n" .."  - Stoneform".. "\n" .."  - Mocking Banner"
L["1.2 Changelog"] = "Removed all bar features, and reverted back to the core of the addon." .. "\n" .. "There are other addons that handle cooldown timers and bars, this addon will only handle vocal announcement from now on." .. "\n" .. "Added abilities:" .. "\n" .. "  - Nature's Vigil" .. "\n" .. "  - Gorefiend's Grasp" .. "\n" .. "  - Ancestral Guidance" .. "\n" .."This addon should no longer conflict with WA or other addons" 
L["1.1.2 Changelog"] = "Fixed a color missing bug in bars" .. "\n" .. "Applied to self only now works with personal cast abilities as well! (Like Shield Wall)" .. "\n" .. "Can now add custom abilities by name instead of only by spellID" .. "\n" .. "Fixed an error where if Tank specilization only were chosen, you would not hear on yourself if you were tank"  .. "\n" .. "Disabling specific bars now work once more!"  .. "\n" .. "Fixed various bugs including spells cast of party accidentally getting shown on bars (Now only show on bars if cast out of raid with raid setting on if player is affected)"
L["1.1.1 Changelog"] = "Added more options for when VRA should be enabled" .. "\n" .. "Added abilities:" .. "\n" .. "  - Anti-Magic Shell" .. "\n" .. "  - Rune Tap" .. "\n" .. "Added following abilities to Defensive Buff Bar (Applied to self only):" .. "\n" .. "  - Hand of Sacrifice" .. "\n" .. "  - Ironbark" .. "\n" .. "  - Life Cocoon" .. "\n" .. "  - Pain Suppression" .. "\n" .. "  - Vigilance" .. "\n" .. "Moved default position of bars"
L["1.1.0 Changelog"] = "Removed spells which Patch 6.0.2 removed" .. "\n" .. "Added abilities:" .. "\n" .. "  - Bristling Fur" .. "\n" .. "  - Aspect of the Fox" .. "\n" .. "  - Amplifying Magic" .. "\n" .. "  - Avenging Wrath (Holy)" .. "\n" .. "  - Ascendance (Resto)"
L["1.0.9 Changelog"] = "Fixed a bug where you could not move the Cooldownbar" .. "\n" .. "Now cooldowns that reset on boss kill/wipe will be reset on Cooldownbar"
L["1.0.8 Changelog"] = "Fixed a bug where Interrupting enemy target would not activate the proper sound" .. "\n" .. "Added option to customize spells shown on ALL the bars!" .. "\n" .. "Fixed a nil error that occurred when X-Realm cast specific buffs" .. "\n" .. "Fixed an errors with spells like AMZ".. "\n" .. "\"Only Buff On Tanks\" now require TANK role to be set".. "\n" .. "Fixed incorrect cooldown on Tranquility for resto druids (Require Healing role set!)"
L["1.0.7 Changelog"] = "Fixed bug where tanks would not hear buffs cast on self if \"tanks only\" was selected" .. "\n" .. "Added personal defensive buffs applications to show on defensive buff bar" .. "\n" .. "Added personal offensive buffs applications to show on offensive buff bar" .. "\n" .. "Recompiled several voice-files to make voice level more even and fixed a few spelling errors." .. "\n" .. "Added abilities:" .. "\n" .. "  - Unholy Frenzy" .. "\n" .. "  - Roar of Sacrifice"
L["1.0.6 Changelog"] = "Fixed \"nil\" bar error that would occur in rare situations" .. "\n" .. "Added class color to progress bars" .. "\n" .. "Added ability to see \"pulsing\" cooldown bars for low cooldown remaining" .. "\n" .. "Update bar interface slightly" .. "\n" .. "Added abilities:" .. "\n" .. "  - Shattering Throw"
L["1.0.5 Changelog"] = "Added Cooldown Bar" .. "\n" .. "Added Defensive Buff Bar" .. "\n" .. "Added Offensive Buff Bar" .. "\n" .. "(NOTE: All the bar's will receive further updates)" .. "\n" .. "Added class color to Individual Buff" .. "\n" .. "Added abilities:" .. "\n" .. "  - Icebound Fortitude" .. "\n" .. "  - Dancing Rune Weapon" .. "\n" .. "  - Vampiric Blood" .. "\n" .. "  - Barkskin" .. "\n" .. "  - Might of Ursoc" .. "\n" .. "  - Survival Instincts" .. "\n" .. "  - Fortifying Brew" .. "\n" .. "  - Argent Defender" .. "\n" .. "  - Guardian of Ancient Kings" .. "\n" .. "  - Divine Protection" .. "\n" .. "  - Divine Shield" .. "\n" .. "  - Shield Wall" .. "\n" .. "  - Last Stand" .. "\n" .. "  - Demoralizing Shout"
L["1.0.4 Changelog"] = "Added \"Individual Buff\" feature" .. "\n" .. "Added abilities:" .. "\n" .. "  - Soulstone" .. "\n" .. "  - Raise Ally" .. "\n" .. "  - Rebirth"
L["1.0.3 Changelog"] = "Added \"Buffs on Tank\" only feature" .. "\n" .. "Added \"Only Check Raid Group\" feature" .. "\n" .. "Added abilities:" .. "\n" .. "  - Iron Bark" .. "\n" .. "  - Vampiric Embrace"
L["1.0.2 Changelog"] = "Improved menu utility" .. "\n" .. "Removed Load Configuration and now load on default" .. "\n" .. "Added abilities:" .. "\n" .. "  - Tricks of the Trade (Off by default)" .. "\n" .. "  - Misdirection (Off by default)" .. "\n" .. "Fixed multiple appliances of buff (Bloodlust, Heroism, Time Warp, Ancient Hysteria)"
L["1.0.1 Changelog"] = "Fixed raid was not toggled as default" .. "\n" .. "Added abilities:" .. "\n" .. "  - Innervate" .. "\n" .. "Fixed multiple appliances of buff (Like Stampede and Avert Harm)".. "\n\n\n\n\n\n\n\n\n\n\n\n\n"
L["GENERAL_HEADER"] = "General"
L["GENERAL_DESCRIPTION"] = "Enabled area: Determines where you want Vocal Raid Assistant to be active" .. "\n\n" .. "Voice Config: Set up voice and volume (Currently only one voice available)" .. "\n\n" .. "Advance options: Enable thotteling of sounds to not be overwhelmed (Try without throtteling first)"
L["ABILITIES_HEADER"] = "Abilities"
L["ABILITIES_DESCRIPTION"] = "Target specific: Enable you to select who you want to hear receive buffs(General)" .. "\n\n" .. "Disable options: Disable segments of vocal options with one click" .. "\n\n" .. "Buff Applied: Single buffs applied to a friendly unit" .. "\n\n" .. "Special Abilities: Multi target or raid abilities to several friendly units" .. "\n\n" .. "Friendly Interrupt: Announce successful friendly interrupts"
L["INDIVIDUAL_HEADER"] = "Individual Assignment"
L["ASSINGMENT_DESCRIPTION"] = "Target specific: Enable you to select who you want to hear receive buffs(Specific)"
L["COOLDOWN_HEADER"] = "Cooldown Bar"
L["COOLDOWN_DESCRIPTION"] = "Shows cooldowns for major defensive cooldowns" .. "\n\n" .. "Bar Settings:" .. "\n\n" .. "Set up the bars so they look like you want!"
L["DEF_BUFF_HEADER"] = "Defensive Buff Bar"
L["DEF_BUFF_DESCRIPTION"] = "Shows timers for major defensive cooldowns uptime" .. "\n\n" .. "Show single target buff ONLY when cast on you!" .. "\n\n" .. "Bar Settings:" .. "\n\n" .. "Set up the bars so they look like you want!"
L["OFF_BUFF_HEADER"] = "Offensive Buff Bar"
L["OFF_BUFF_DESCRIPTION"] = "Shows timers for major offensive cooldowns uptime" .. "\n\n" .. "Show single target buff ONLY when cast on you!" .. "\n\n" .. "Bar Settings:" .. "\n\n" .. "Set up the bars so they look like you want!"
L["CUSTOM_ABILITIES_HEADER"] = "Custom Abilities"
L["CUSTOM_ABILITIES_DESCRIPTION"] = "Enable you to track a custom ability of your own choice. Fill in the fields as asked, and it should work!" .. "\n\n" .. "Use existing sound currently does not work, but will in a later version. You will have to provide the sound file yourself".. "\n\n\n\n\n\n\n\n\n\n\n\n\n"





L["Spell cast success"] = true
L["Spell cast start"] = true
L["Spell aura applied"] = true
L["Spell aura removed"] = true
L["Spell interrupt"] = true
L["Spell summon"] = true
L["Any"] = true
L["Player"] = true
L["Target"] = true
L["Focus"] = true
L["Mouseover"] = true
L["Party"] = true
L["Raid"] = true
L["Arena"] = true
L["Boss"] = true
L["Custom"] = true
L["Friendly"] = true
L["Hostile player"] = true
L["Hostile unit"] = true
L["Neutral"] = true
L["Myself"] = true
L["Mine"] = true
L["My pet"] = true
L["Custom Spell"] = true
L["New Sound Alert"] = true
L["name"] = true
L["same name already exists"] = true
L["spellid"] = true
L["Remove"] = true
L["enabled"] = true
L["Are you sure?"] = true
L["Test"] = true
L["Use existing sound"] = true
L["choose a sound"] = true
L["file path"] = true
L["event type"] = true
L["Source unit"] = true
L["Source type"] = true
L["Custom unit name"] = true
L["Dest unit"] = true
L["Dest type"] = true


L["PVP Voice Alert"] = true
L["PVE Voice Alert"] = true
L["Load Configuration"] = true
L["Load Configuration Options"] = true
L["Load Configuration Options - Red + will appear"] = true
L["General"] = true
L["General options"] = true
L["Enable area"] = "Enable VRA"
L["Anywhere"] = "Anywhere"
L["Anywhere Option Description"] = "Enable VRA anywhere"
L["World"] = "World"
L["World Option Description"] = "Enable VRA in open world"
L["Battleground"] = "Battleground"
L["Battleground Option Description"] = "Enable VRA in battlegrounds"
L["Arena"] = true
L["Arena Option Description"] = "Enable VRA in arenas"
L["Instance"] = true
L["Instance Option Description"] = "Enable VRA in instances"
L["Raid"] = true
L["Raid Option Description"] = "Enable VRA in raids"
L["Scenario"] = true
L["Scenario Option Description"] = "Enable VRA in scenarios"


L["Voice config"] = true
L["Voice language"] = true
L["Select language of the alert"] = true
L["Output channel"] = true
L["Output channel desc"] = "Select desired output channel"
L["Chinese(female)"] = true
L["English(female)"] = true
L["Volume"] = true
L["adjusting the voice volume(the same as adjusting the system master sound volume)"] = true
L["Advance options"] = true
L["Smart disable"] = true
L["Disable addon for a moment while too many alerts comes"] = true
L["Throttle"] = true
L["The minimum interval of each alert"] = true
L["Abilities"] = true
L["Abilities options"] = true
L["Disable options"] = true
L["Disable abilities by type"] = true
L["Disable Buff Applied"] = true
L["Check this will disable alert for buff applied to friendly targets"] = true
L["Disable Buff Down"] = true
L["Check this will disable alert for buff removed from friendly targets"] = true
L["Disable Spell Casting"] = true
L["Chech this will disable alert for spell being casted to friendly targets"] = true
L["Disable special abilities"] = true
L["Check this will disable alert for instant-cast important abilities"] = true
L["Disable friendly interrupt"] = true
L["Check this will disable alert for successfully-landed friendly interrupting abilities"] = true
L["Buff Applied"] = true
L["Crowd Control"] = true
L["Target and Focus Only"] = true
L["Alert works only when your current target or focus gains the buff effect or use the ability"] = true
L["Alert Drinking"] = true
L["In arena, alert when enemy is drinking"] = true
L["PvP Trinketed Class"] = true
L["Also announce class name with trinket alert when hostile targets use PvP trinket in arena"] = true
L["General Abilities"] = true
L["|cffFF7D0ADruid|r"] = true
L["|cffF58CBAPaladin|r"] = true
L["|cffFFF569Rogue|r"] = true
L["|cffC79C6EWarrior|r"] = true
L["|cffFFFFFFPriest|r"] = true
L["|cff0070daShaman|r"] = true
L["|cff69CCF0Mage|r"] = true
L["|cffC41F3BDeath Knight|r"] = true
L["|cffA330C9Demon Hunter|r"] = true
L["|cffABD473Hunter|r"] = true
L["|cFF558A84Monk|r"] = true
L["Buff Down"] = true
L["Spell Casting"] = true
L["Big Heals"] = true
L["Greater Heal, Divine Light, Greater Healing Wave, Healing Touch, Enveloping Mist"] = true
L["Resurrection"] = true
L["Resurrection, Redemption, Ancestral Spirit, Revive, Resuscitate"] = true
L["|cff9482C9Warlock|r"] = true
L["Special Abilities"] = true
L["Friendly Interrupt"] = true
L["Spell Lock, Counterspell, Kick, Pummel, Mind Freeze, Skull Bash, Rebuke, Solar Beam, Spear Hand Strike, Wind Shear"] = true


L["Profiles"] = true
