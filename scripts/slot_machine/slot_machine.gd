extends Control
class_name SlotMachine

@onready var pool: SlotMachinePool = $Pool
@onready var grid: SlotMachineGrid = $Grid
@onready var patterns: SlotMachinePatterns = $Patterns

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		grid.spin()

func init():
	pool.init()
	grid.init()
