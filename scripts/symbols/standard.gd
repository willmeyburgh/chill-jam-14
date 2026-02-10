class_name StandardSymbol extends Symbol

const BLUEPRINT = preload("res://scenes/symbols/Standard.tscn")

@export var rank_values: Dictionary[Enums.SymbolRank, int]

func _ready() -> void:
	var atlas: AtlasTexture = texture.duplicate()
	atlas.region.position = Vector2(data.category*48, data.rank*48)
	texture = atlas
	
func score() -> Vector2i:
	return Vector2i(rank_values[data.rank], 0)

static func create(data: SymbolData) -> StandardSymbol:
	var symbol: StandardSymbol = BLUEPRINT.instantiate()
	symbol.data = data
	return symbol
