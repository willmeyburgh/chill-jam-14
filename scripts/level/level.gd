extends Control
class_name Level

@onready var slot_machine: SlotMachine = $SlotMachine

func _ready() -> void:
	Global.level = self
	slot_machine.init()
