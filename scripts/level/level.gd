extends Control
class_name Level

@onready var slot_machine: SlotMachine = $SlotMachine
@onready var misc: Node2D = $Misc

func _ready() -> void:
	Global.level = self
	slot_machine.init()
