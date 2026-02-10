extends Node
class_name SlotMachinePatterns

@onready var slot_machine: SlotMachine = $".."
var grid: SlotMachineGrid:
	get:
		return slot_machine.grid

func activate() -> int:
	return 0
