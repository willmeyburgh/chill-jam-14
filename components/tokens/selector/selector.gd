extends Node2D
class_name TokenSelector

const DELETE_COLOR := Color('e83b3b', .5)
const HIGHLIGHT_COLOR := Color('ffffff', .5)

@export var strategy: TokenSelectorStrategy

@onready var token: Token = $".."

var slot_machine: SlotMachine:
	get:
		return Global.level.slot_machine
var grid: SlotMachineGrid:
	get:
		return slot_machine.grid
var store: Dictionary[String, Variant] = {}
var last_hover: Vector2i = -Vector2i.ONE

func init():
	strategy.init(self)

func _draw() -> void:
	strategy.draw(self)

func _process(delta: float) -> void:
	if token.select:
		var mouse = get_global_mouse_position()
		var hover = Vector2i(floor((get_global_mouse_position()-grid.global_position)/48))
		hover = Vector2i(hover.y, hover.x)
		if not grid.check_valid(hover.x, hover.y):
			hover = -Vector2i.ONE
		
		if hover != last_hover:
			if hover == -Vector2i.ONE:
				strategy.unhover(self)
			else:
				strategy.hover(self, hover.x, hover.y)
			
			last_hover = hover

func _input(event):
	if token.select:
		if event is InputEventMouseButton and event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT:
				if grid.check_valid(last_hover.x, last_hover.y):
					strategy.select(self, last_hover.x, last_hover.y)
					token.queue_free()
