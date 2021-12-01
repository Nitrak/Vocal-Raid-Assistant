# Vocal Raid Assistant

## 2.0.0(beta)
- Complete rewrite
- Added voicepacks
- Removed remaining legacy feature fragments

## 1.6.7 
- Code cleanup
- Added spell icon for custom abilties
- Combustion
- Alter Time
- Power Infusion

## 1.6.6 
- Removed CD bar tracking, added enable/disable for custom sounds and code cleanup.

## 1.6.5 
- Added abilities
- Force of Nature

## 1.6.4 Changelog

### Added abilities
- Boon of the Ascended 
- Convoke the Spirits
- Ashen Hallow 
- Chain Harvest
- Mindgames
- Fae Transfusion
- Primordial Wave
- Weapons of Order
- Divine Toll 
- Vesper Totem
- Fae Guardians
- Fodder to the Flame
- Abomination Limb
- Purify Soul
- Fleshcraft
- Spirit Shell

## 1.6.3 Changelog
### Added abilities
- Spell reflection
- Shadowmeld
- Ursols Vortex
- Flourish (Off by default)
- Rallying Cry

## 1.6.2 Changelog
### Shadowlands hotfix to make addon functional. Further update will come with update of abilities.

## 1.6.1 Changelog
- Fixed a misspelled ability
- Actually Moved Crowd Control abilities to a separate section
- Added Abilities (On/Off by default) - Holy Avenger (On)"

## 1.6.0 Changelog
- Added option to swap audio channel
- Moved Crowd Control abilities to a separate section

## 1.5.2 Changelog
-  Added missing fonts
### Added Abilities (On/Off by default):
- Asphyxiate
- Fel Eruption
- Death Grip

## 1.5.1 Changelog
- Fixed function call

## 1.5.0 Changelog
- Added ability to only track buffs applied to player
- Moved Innervate to Individual Buff
- Moved Aegies of Light to Special Ability
### Added Abilities (On/Off by default):
- Sigil of Silence (On) 
- Sigil of Misery (On)
- Sigil of Chains (On) 
- Ring of Peace (On)
- Shadowfiend-Disc (Off
- Evangelism (Off)
- Leap of Faith (On) (Says Grip, since much shorter)
- Apotheosis (On)
- Luminous Barrier (On)
- Rapture (On)
- Blind (On)
- Hex (On)
- Polymorph (On)
- Fear (On)
- Psychic Scream (On)
- Intimidating Shout (On)
- Hammer of Justice (On) (Says Hodje, as HoJ abbreviation is commonly used)
- Blessing of Spellwarding (On)
- Repentance (On)
- Paralysis (On)
- Freezing Trap (On)
- Cyclone (On)
- Imprison (On)
- Quaking Palm (On)

## 1.4.4 
### Removed debug statement.

## 1.4.3 
### Fixed incorrect function call.

## 1.4.2 
- Made functioning with new event system.
- Added Holy Word: Salvation

## 1.4.1 
### Version fix

## 1.4.0
- Made compatible with Battle for Azeroth
- Removed a lot of abilities and added new ones.

## 1.3.9
- Added Demonic Gateway

## 1.3.8 
- Changed Hand of Protection to Protection.
- Added Drums of Fury to defaults for Offensive Buff Bar

## 1.3.7
### Removed few spells: 
- Removed Bristling Fur, as it is not longer a mitigation cooldown
- Removed Vigilance as it is no longer in the game
- Removed empty classes.
- Added some fixes for bars from spells cast by yourself on yourself.

## 1.3.6 
- Added Mind Bomb

## 1.3.5 
- Added AoE stun abilities for making Mythic Plus easier.
- Fixed volume on Gift of the Queen
- Enabled the ability to disable Darkness
- You are now able to MOVE the Defensive Buff Bar
- You are now able to reset the position of the bars if they somehow managed to escape your screen!

## 1.3.4 
- Added interrupt announcing for Demon Hunters and Survival Hunter.
- Fixed missing name entry for Demon Hunters

## 1.3.3 
- Updated spells to match legion cooldowns.
### Added abilities:
- Blood Mirror
- Bonestorm
- Tombstone
- Blur
- Darkness
- Fiery Brand
- Metamorphosis
- Nether Bond
- Soul Carver
- Innervate
- Ironfur
- Rage of the Sleeper
- Essence of G'Hanir
- Dampen Harm
- Diffuse Magic
- Zen Meditation
- Invoke Chi-Ji
- Sheilun's Gift
- Tyr's Deliverance
- Aegis of Light
- Eye of Tyr
- Light's Wrath
- Light of T'uure
- Wind Rush Totem
- Earthen Shield Totem
- Gift of the Queen
- Commanding Shout
- Die by the Sword
- Ignore Pain
- Neltharion's Fury
- Ravager
- Shield Block

## 1.3.2 
- Hotfix to work for LEGION. Will update fully soon.

## 1.3.1 
- Fixed bug where bars would show for spells you cast yourself
- Fixed error when using new profile until a reload is done
- Added Reload of UI after profile swap to sort inconsistencies

## 1.3.0 
- Reimplemented bar system
- Sorted out logic such that bars will only exist within your own group
- Still need to fix issue that bars are not correctly reset after boss kill/reset.
### Removed abilities:
- Aspect of the Fox
- Amplify Magic

## 1.2.2 
- Small bugfix - stopped calling method that does not exist

## 1.2.1 
- Small logical bugfix so player will not hear own cast on tanks
### Added abilities:
- Nature's Vigil
- Guard
- Incarnation: Tree of Life
- Sacred Shield
- Eternal Flame
- Stoneform
- Mocking Banner

## 1.2.0
- Removed all bar features, and reverted back to the core of the addon. There are other addons that handle cooldown timers and bars, this addon will only handle vocal announcement from now on.
### Added abilities:
- Nature's Vigil
- Gorefiend's Grasp
- Ancestral Guidance
- This addon should no longer conflict with WA or other addons

## 1.1.2
- Fixed a color missing bug in bars
- Applied to self only now works with personal cast abilities as well! (Like Shield Wall)
- Can now add custom abilities by name instead of only by spellID
- Fixed an error where if Tank specilization only were chosen, you would not hear on yourself if you were tank
- Disabling specific bars now work once more!
- Fixed various bugs including spells cast of party accidentally getting shown on bars (Now only show on bars if cast out of raid with raid setting on if player is affected)

## 1.1.1 
- Added more options for when VRA should be enabled
### Added abilities:
- Anti-Magic Shell
- Rune Tap
- Added following abilities to Defensive Buff Bar (Applied to self only)
- Hand of Sacrifice
- Ironbark
- Life Cocoon
- Pain Suppression
- Vigilance

- Moved default position of bars

## 1.1.0
- Removed spells which Patch 6.0.2 removed
### Added abilities:
- Bristling Fur
- Aspect of the Fox
- Amplifying Magic
- Avenging Wrath (Holy)
- Ascendance (Resto)

## 1.0.9
- Fixed a bug where you could not move the Cooldownbar
- Now cooldowns that reset on boss kill/wipe will be reset on Cooldownbar

## 1.0.8 
- Fixed a bug where Interrupting enemy target would not activate the proper sound
- Added option to customize spells shown on ALL the bars!
- Fixed a nil error that occurred when X-Realm cast specific buffs
- Fixed an errors with spells like AMZ
- Only Buff On Tanks now require TANK role to be set
- Fixed incorrect cooldown on Tranquility for resto druids (Require Healing role set!)

## 1.0.7 
- Fixed bug where tanks would not hear buffs cast on self if \"tanks only\" was selected
- Added personal defensive buffs applications to show on defensive buff bar
- Recompiled several voice-files to make voice level more even and fixed a few spelling errors
### Added abilities:
- Unholy Frenzy
- Roar of Sacrifice

## 1.0.6 
 - Fixed \"nil\" bar error that would occur in rare situations
 - Added class color to progress bars
 - Added ability to see \"pulsing\" cooldown bars for low cooldown remaining
 - Update bar interface slightly
 ### Added abilities:
 - Shattering Throw

## 1.0.5 
- Added Cooldown Bar
- Added Defensive Buff Bar
- Added Offensive Buff Bar (NOTE: All the bar's will receive further updates)
- Added class color to Individual Buff
### Added abilities:
- Icebound Fortitude
- Dancing Rune Weapon
- Vampiric Blood
- Barkskin
- Might of Ursoc
- Survival Instinct
- Fortifying Brew
- Argent Defender
- Guardian of Ancient Kings
- Divine Protection
- Divine Shield
- Shield Wall
- Last Stand
- Demoralizing Shout

## 1.0.4 
- Added \"Individual Buff\" feature
### Added abilities:
- Soulstone
- Raise Ally
- Rebirth

## 1.0.3 
- Added \"Buffs on Tank\" only feature
- Added \"Only Check Raid Group\" feature
### Added abilities:
- Iron Bark
- Vampiric Embrace

## 1.0.2 
- Improved menu utility
- Removed Load Configuration and now load on default
### Added abilities:
- Tricks of the Trade (Off by default)
- Misdirection (Off by default)

- Fixed multiple appliances of buff (Bloodlust, Heroism, Time Warp, Ancient Hysteria)

## 1.0.1
- Fixed raid was not toggled as default
### Added abilities:
- Innervate
- Fixed multiple appliances of buff (Like Stampede and Avert Harm)
