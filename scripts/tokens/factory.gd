class_name TokenFactory

const TYPE_FILES: Dictionary[Enums.TokenType, String] = {
	Enums.TokenType.SINGLE_DELETE: "res://scenes/tokens/SingleDelete.tscn",
	Enums.TokenType.HORIZONTAL_DELETE: "res://scenes/tokens/HorizontalDelete.tscn",
	Enums.TokenType.VERTICAL_DELETE: "res://scenes/tokens/VerticalDelete.tscn",
}

static func create(type: Enums.TokenType) -> Token:
	return load(TYPE_FILES[type]).instantiate()
