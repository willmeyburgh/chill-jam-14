extends Node
class_name SlotMachineGrid

signal spin_done

@export var spin_column_start: int = 10
@export var spin_column_delta: int = 2

@onready var columns_section: HBoxContainer = $"../Columns"
@onready var slot_machine: SlotMachine = $".."

var columns: Array[SlotMachineColumn] = []
var board: Array[Array] = []
var column_spinning: Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for column: SlotMachineColumn in columns_section.get_children():
		columns.append(column)
		
func next_symbol(column_id: int) -> Symbol:
	return slot_machine.pool.next()

func _column_spin_done(column_id: int):
	column_spinning.remove_at(column_spinning.find(column_id))
	if column_spinning.is_empty():
		spin_done.emit()

func init():
	for i in range(5):
		columns[i].init(i)
		columns[i].spin_done.connect(_column_spin_done)

func spin() -> bool:
	if column_spinning.size() > 0:
		return false
	
	var count = spin_column_start
	for i in range(5):
		columns[i].spin(count)
		column_spinning.append(i)
		count += spin_column_delta
	return true
