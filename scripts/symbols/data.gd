class_name SymbolData extends Resource

@export var category: Enums.SymbolCategory
@export var rank: Enums.SymbolRank

func hash() -> int:
	return ("%d::%d" % [category, rank]).hash()

func _init(
	category: Enums.SymbolCategory = 0,
	rank: Enums.SymbolRank = 0
):
	self.category = category
	self.rank = rank
