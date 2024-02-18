local _, addon = ...

-- Track debuff aura application
addon.cheatDeathList = {
	[31230]  = true, -- Cheat Death
	[87024]  = true, -- Cauterized / Mage: 86949 - Cauterize
	[116888] = true, -- Perdition / Death Knight: 114556 - Purgatory
	[209258] = true, -- Last Resort
	[393879] = true, -- Ardent Defender
	[404369] = true, -- Defy Fate
	-- Trinkets
	[417069] = true, --
}
