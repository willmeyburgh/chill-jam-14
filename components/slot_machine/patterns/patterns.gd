extends Node
class_name SlotMachinePatterns

signal score_done

@export var pattern_score: Dictionary[Enums.PatternType, Vector2i]
@export var score_interval: float = 1

@onready var slot_machine: SlotMachine = $".."

@onready var score_label: Label = $"../MarginContainer4/HBoxContainer/Score"
@onready var multi_label: Label = $"../MarginContainer4/HBoxContainer/Multi"
@onready var timer: Timer = $Timer

var grid: SlotMachineGrid:
	get:
		return slot_machine.grid

var ref_grid: Array[Enums.SymbolCategory] = []
var excludes: Array[Array] = []
var patterns: Dictionary[Enums.PatternType, Array] = {}
var score: int:
	set(value):
		score = value
		score_label.text = "%d" % score
var multi: int:
	set(value):
		multi = value
		multi_label.text = "%d" % multi

const PATTERN_ORDER: Array[Enums.PatternType] = [
	Enums.PatternType.STRAIGHT_3,
	Enums.PatternType.DIAG_3,
	Enums.PatternType.STRAIGHT_4,
	Enums.PatternType.DIAG_4,
	Enums.PatternType.STRAIGHT_5,
	Enums.PatternType.DIAG_5,
	Enums.PatternType.DIAMOND_HEAD,
	Enums.PatternType.DIAMOND,
]
var score_increase_queue: Array[Dictionary] = []

func _setup_score():
	ref_grid.clear()
	excludes.clear()
	patterns.clear()
	score = 0
	multi = 0
	for i in range(5*5):
		ref_grid.append(grid.symbols[i].data.category)
		excludes.append([])
	
		
func _get_cat(row: int, col: int) -> Enums.SymbolCategory:
	return ref_grid[row*5 + col]
	
func _add_exclude(row: int, col: int, exclude: String):
	excludes[row*5+col].append(exclude)
	
func _has_exclude(row: int, col: int, exclude: String):
	for _exclude: String in excludes[row*5+col]:
		if exclude == _exclude:
			return true
	return false
	
func eq_cat(left: Enums.SymbolCategory, right: Enums.SymbolCategory):
	if left == Enums.SymbolCategory.JOKER or right == Enums.SymbolCategory.JOKER:
		return true
	return left == right
		
func _check_horz_n(row: int, col: int, n: int) -> bool:
	var ori = _get_cat(row, col)
	for _col in range(col+1, col+n):
		if !grid.check_valid(row, _col):
			return false
		var cat = _get_cat(row, _col)
		if ori == Enums.SymbolCategory.JOKER:
			ori = cat
		if !eq_cat(cat,ori):
			return false
	return true
	
func _check_vert_n(row: int, col: int, n: int) -> bool:
	var ori = _get_cat(row, col)
	for _row in range(row+1, row+n):
		if !grid.check_valid(_row, col):
			return false
		var cat = _get_cat(_row, col)
		if ori == Enums.SymbolCategory.JOKER:
			ori = cat
		if !eq_cat(cat,ori):
			return false
	return true
	
func _check_down_diag_n(row: int, col: int, n: int) -> bool:
	var ori = _get_cat(row, col)
	for i in range(1, n):
		var _row = row+i
		var _col = col+i
		if !grid.check_valid(_row, _col):
			return false
		var cat = _get_cat(_row, _col)
		if ori == Enums.SymbolCategory.JOKER:
			ori = cat
		if !eq_cat(cat,ori):
			return false
	return true
	
func _check_up_diag_n(row: int, col: int, n: int) -> bool:
	var ori = _get_cat(row, col)
	for i in range(1, n):
		var _row = row-i
		var _col = col+i
		if !grid.check_valid(_row, _col):
			return false
		var cat = _get_cat(_row, _col)
		if ori == Enums.SymbolCategory.JOKER:
			ori = cat
		if !eq_cat(cat,ori):
			return false
	return true
	
func _add_pattern(type: Enums.PatternType, row: int, col: int):
	patterns.get_or_add(type, []).append(Vector2i(row, col))
	
func _check_straight_n(n: int, type: Enums.PatternType):
	# horizontal
	for col in range(6-n):
		for row in range(5):
			if _check_horz_n(row, col, n) and !_has_exclude(row, col, 'sh'):
				for _col in range(col, col+n):
					_add_exclude(row, _col, "sh")
				_add_pattern(type, row, col)
				
	# vertical
	for row in range(6-n):
		for col in range(5):
			if _check_vert_n(row, col, n) and !_has_exclude(row, col, 'sv'):
				for _row in range(row, row+n):
					_add_exclude(_row, col, "sv")
				_add_pattern(type, row, col)
					
func _check_diag_n(n: int, type: Enums.PatternType):
	# diag up
	for row in range(4, -1, -1):
		for col in range(5):
			if _check_up_diag_n(row, col, n) and !_has_exclude(row, col, 'du'):
				for i in range(n):
					_add_exclude(row-i, col+i, "du")
				_add_pattern(type, row, col)
	# diag down
	for row in range(5):
		for col in range(5):
			if _check_down_diag_n(row, col, n) and !_has_exclude(row, col, 'dd'):
				for i in range(n):
					_add_exclude(row+i, col+i, "dd")
				_add_pattern(type, row, col)
	
func _check_straights():
	_check_straight_n(5, Enums.PatternType.STRAIGHT_5)
	_check_straight_n(4, Enums.PatternType.STRAIGHT_4)
	_check_straight_n(3, Enums.PatternType.STRAIGHT_3)
	
func _check_diags():
	_check_diag_n(5, Enums.PatternType.DIAG_5)
	_check_diag_n(4, Enums.PatternType.DIAG_4)
	_check_diag_n(3, Enums.PatternType.DIAG_3)
	
func _check_diamonds():
	pass
	
func _score_symbol(row: int, col: int):
	var score = grid.get_symbol(row, col).score()
	score_increase_queue.append({
		'position': grid.cell_global_position(row, col),
		'score': score.x,
		'multi': score.y
	})
	
func _pattern_name(type: Enums.PatternType) -> String:
	var name: String = Enums.PatternType.keys()[type]
	name = name.to_lower().replace('_', ' ')
	name = name.substr(0, 1).to_upper() + name.substr(1)
	match type:
		Enums.PatternType.DIAG_3,Enums.PatternType.DIAG_4,Enums.PatternType.DIAG_5:
			return "Diagonal %d" % (type-Enums.PatternType.DIAG_3+3)
		_:
			return name
	
	
func _score_pattern(type: Enums.PatternType, position: Vector2):
	var score = pattern_score[type]
	
	score_increase_queue.append({
		'position': position,
		'score': score.x,
		'multi': score.y,
		'title': _pattern_name(type)
	})
	
func _score_straight(type: Enums.PatternType, row: int, col: int):
	var n = type - Enums.PatternType.STRAIGHT_3+3
	
	var start = grid.cell_global_position(row, col)
	
	for exclude in excludes[row*5+col]:
		if exclude == 'sh':
			for _col in range(col, col+n):
				_score_symbol(row, _col)
			var end = grid.cell_global_position(row, col+n-1)
			_score_pattern(type, (start+end)/2)
		elif exclude == 'sv':
			for _row in range(row, row+n):
				_score_symbol(_row, col)
			var end = grid.cell_global_position(row+n-1, col)
			_score_pattern(type, (start+end)/2)
				
func _score_diag(type: Enums.PatternType, row: int, col: int):
	var n = type - Enums.PatternType.DIAG_3+3
	
	var start = grid.cell_global_position(row, col)
	
	for exclude in excludes[row*5+col]:
		if exclude == 'du':
			for i in range(n):
				var _row = row-i
				var _col = col+i
				_score_symbol(_row, _col)
			var end = grid.cell_global_position(row-(n-1), col+n-1)
			_score_pattern(type, (start+end)/2)
		elif exclude == 'dd':
			for i in range(n):
				var _row = row+i
				var _col = col+i
				_score_symbol(_row, _col)
			var end = grid.cell_global_position(row+n-1, col+n-1)
			_score_pattern(type, (start+end)/2)
				

func _score_diamond(type: Enums.PatternType, row: int, col: int):
	pass

func _check():
	_check_straights()
	_check_diamonds()
	_check_diags()
	
func _score():
	for type in PATTERN_ORDER:
		if type in patterns:
			for position: Vector2i in patterns[type]:
				match type:
					Enums.PatternType.STRAIGHT_3,Enums.PatternType.STRAIGHT_4,Enums.PatternType.STRAIGHT_5:
						_score_straight(type, position.x, position.y)
					Enums.PatternType.DIAG_3,Enums.PatternType.DIAG_4,Enums.PatternType.DIAG_5:
						_score_diag(type, position.x, position.y)
					Enums.PatternType.DIAMOND, Enums.PatternType.DIAMOND_HEAD:
						_score_diamond(type, position.x, position.y)
						

func do_score():
	slot_machine.play_button.disabled = true
	_setup_score()
	_check()
	_score()
	timer.start()
	
func init():
	slot_machine.play_button.pressed.connect(do_score)


func _on_timer_timeout() -> void:
	if score_increase_queue.is_empty():
		slot_machine.score += score * multi
		score_done.emit()
		return
		
	var item: Dictionary = score_increase_queue.pop_front()
	score += item['score']
	multi += item['multi']
	ScoreIncrease.create(
		item['position'],
		item['score'],
		item['multi'],
		item.get('title', '')
	)
	
	timer.start()
