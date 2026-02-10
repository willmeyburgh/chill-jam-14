extends Node
class_name SlotMachinePoolToken


func next() -> Token:
	return TokenFactory.create(Enums.TokenType.values()[Global.rng.randi_range(0, Enums.TokenType.size()-1)])

func init():
	pass
