extends Control
class_name SlotMachineGrid

signal spin_done

@export var spins_base: int = 10
@export var spins_delta: int = 2
@export var spin_speed: float = 10

@onready var slot_machine: SlotMachine = $"../.."

var symbols: Array[Symbol] = []
var spins_col: Array[int] = []
var spins_col_tweening: Array[int] = []
var spinning: bool:
	get:
		for col in range(5):
			if spins_col[col] > 0:
				return true
		return false

func init():
	for row in range(5):
		for col in range(5):
			var symbol = slot_machine.pool.symbol.next()
			symbol.position = Vector2(24+48*col, 24+48*row)
			add_child(symbol)
			symbols.append(symbol)
			
	for col in range(5):
		spins_col.append(0)
		spins_col_tweening.append(0)
	
	slot_machine.spin_button.pressed.connect(spin)
		
	#spin()
			
func get_symbol(row: int, col: int) -> Symbol:
	return symbols[row*5+col]

func set_symbol(row: int, col: int, symbol: Symbol):
	symbols[row*5+col] = symbol
	
func _spin_col_finished(symbol: Symbol, row: int, col: int):
	return func():
		if row >= 5:
			symbol.queue_free()
			return
		spins_col_tweening[col] -= 1
		if spins_col_tweening[col] == 0:
			if spinning:
				_spin_col(col)
		
		
func _setup_spin_col_tween(symbol: Symbol, col: int, to_row: int):
	Utils.reset_tween(symbol)
	symbol.tween.tween_property(
		symbol,
		"position",
		Vector2(24+48*col, 24+48*to_row),
		1/spin_speed
	)
	symbol.tween.finished.connect(_spin_col_finished(symbol, to_row, col))
	
func _spin_col(col: int):
	spins_col[col] -= 1
	if spins_col[col] == 0:
		if not spinning:
			spin_done.emit()
		return
	spins_col_tweening[col] = 5
	for row in range(5):
		var symbol = get_symbol(row, col)
		_setup_spin_col_tween(symbol, col, row+1)
	for row in range(3, -1, -1):
		var symbol = get_symbol(row, col)
		set_symbol(row+1, col, symbol)
	var symbol = slot_machine.pool.symbol.next()
	symbol.position = Vector2(24+48*col, -24)
	set_symbol(0, col, symbol)
	add_child(symbol)
	_setup_spin_col_tween(symbol, col, 0)
	
func fall():
	for col in range(5):
		var rows: int = 0
		for row in range(4, -1, -1):
			var symbol = get_symbol(row, col)
			if symbol == null:
				rows += 1
			elif rows > 0:
				set_symbol(row, col, null)
				set_symbol(row+rows, col, symbol)
				_setup_spin_col_tween(
					symbol,
					col,
					row+rows
				)
		for i in range(rows):
			var symbol = slot_machine.pool.symbol.next()
			symbol.position = Vector2(24+48*col, 24+48*(i-rows))
			set_symbol(i, col, symbol)
			add_child(symbol)
			_setup_spin_col_tween(symbol, col, i)

func cell_global_position(row: int, col: int):
	return global_position+Vector2(24+48*col, 24+48*row)

func spin() -> bool:
	if spinning:
		return false
	
	var spins = spins_base
	for col in range(5):
		spins_col[col] = spins
		spins += spins_delta
		_spin_col(col)
		
	return true
	
func check_valid(row: int, col: int) -> bool:
	return row >= 0 and row < 5 and col >= 0 and col < 5
	
func delete_symbol(row: int, col: int):
	get_symbol(row, col).queue_free()
	set_symbol(row, col, null)
