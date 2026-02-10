class_name SymbolFactory

static func create(data: SymbolData) -> Symbol:
	match data.rank:
		Enums.SymbolRank.VOILET, Enums.SymbolRank.CRIMSON, Enums.SymbolRank.GOLD, Enums.SymbolRank.DIAMOND:
			return StandardSymbol.create(data)
	return null
