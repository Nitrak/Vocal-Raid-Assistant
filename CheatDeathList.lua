local _, addon = ...

-- Track debuff aura application
addon.cheatDeathList = {
	[45181]  = true, -- Cheat Death / Rogue: 31230 - Cheat Death
	[87024]  = true, -- Cauterized / Mage: 86949 - Cauterize
	[116888] = true, -- Perdition / Death Knight: 114556 - Purgatory
	[209261] = true, -- Last Resort / Demon Hunter: 209258 - Last Resort
	[404369] = true, -- Defy Fate / Evoker: 404195 - Defy Fate
	-- Trinkets
	[417069] = true, -- Prophetic Stonescale / Trinket Spell: 417050
}
