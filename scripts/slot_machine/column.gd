extends Control
class_name SlotMachineColumn

signal spin_done(column_id: int)

@export var spin_speed: float

@onready var container: VBoxContainer = $Margin/Container
@onready var margin: MarginContainer = $Margin
@onready var slot_machine: SlotMachine = $"../.."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var column_id: int
var spin_count: int = 0

func init(column_id: int):
	self.column_id = column_id
	
	for _i in range(5):
		container.add_child(slot_machine.grid.next_symbol(column_id))
		
func spin(count: int):
	spin_count = count
	margin.set("theme_override_constants/margin_top", -64)
	var symbol = slot_machine.grid.next_symbol(column_id)
	container.add_child(symbol)
	container.move_child(symbol, 0)
	animation_player.play("spin", -1, spin_speed)
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'spin':
		container.get_children()[-1].queue_free()
		if spin_count > 1:
			spin(spin_count-1)
		else:
			spin_done.emit(column_id)
