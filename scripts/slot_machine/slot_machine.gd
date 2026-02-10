extends Control
class_name SlotMachine

@onready var pool: SlotMachinePool = $Pool
@onready var grid: SlotMachineGrid = $MarginContainer/Grid
@onready var hand: SlotMachineHand = $MarginContainer2/Hand
@onready var patterns: SlotMachinePatterns = $Patterns
@onready var play_button: Button = $MarginContainer3/VBoxContainer/Play
@onready var spin_button: Button = $MarginContainer3/VBoxContainer/Spin
@onready var score_label: Label = $MarginContainer4/HBoxContainer3/Score
var score: int = 0:
	set(value):
		score = value
		score_label.text = str(value)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		grid.spin()

func init():
	pool.init()
	grid.init()
	hand.init()
	patterns.init()
