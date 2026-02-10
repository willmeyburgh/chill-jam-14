class_name StandardSymbol extends Symbol

const BLUEPRINT = preload("res://scenes/symbols/Standard.tscn")

@export var rank_values: Dictionary[Enums.SymbolRank, int]

func _ready() -> void:
	var atlas: AtlasTexture = texture.duplicate()
	atlas.region.position = Vector2(data.category*64, data.rank*64)
	texture = atlas
	
func activate() -> int:
	return rank_values[data.rank]

static func create(data: SymbolData) -> StandardSymbol:
	var symbol: StandardSymbol = BLUEPRINT.instantiate()
	symbol.data = data
	return symbol
