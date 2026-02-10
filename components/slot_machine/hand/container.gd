extends MarginContainer
class_name SlotMachineHandContainer

const BLUEPRINT = preload("res://components/slot_machine/hand/Container.tscn")

signal selected(token: Token)

@export var hover_speed: float = 4
@export var hover_top: int = -20

@onready var token: Token = $"Token"


var select: bool = false:
	set(value):
		select = value
		token.select = value
		if select:
			selected.emit(token)
		elif !hover:
			unelevate()

var hover: bool = false:
	set(value):
		hover = value
		token.hover = value
var tween : Tween

func tween_hover_top(value: int):
	add_theme_constant_override("margin_top", value)

func elevate():
	Utils.reset_tween(self)
	tween.tween_method(
		tween_hover_top,
		0,
		hover_top,
		1.0/hover_speed
	)
	
func unelevate():
	Utils.reset_tween(self)
	tween.tween_method(
		tween_hover_top,
		get("theme_override_constants/margin_top"),
		0,
		1.0/hover_speed
	)

func _on_mouse_entered() -> void:
	if not select:
		elevate()
	hover = true

func _on_mouse_exited() -> void:
	if not select:
		unelevate()
	hover = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and hover:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select = !select

static func create(token: Token) -> SlotMachineHandContainer:
	var container: SlotMachineHandContainer = BLUEPRINT.instantiate()
	container.token = token
	container.add_child(token)
	return container
