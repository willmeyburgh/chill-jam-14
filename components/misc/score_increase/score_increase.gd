extends Node2D
class_name ScoreIncrease

const BLUEPRINT = preload("res://components/misc/score_increase/ScoreIncrease.tscn")

@export var speed: float
@export var to_position: Vector2
@onready var score_label: Label = $VBoxContainer/HBoxContainer/Score
@onready var multi_label: Label = $VBoxContainer/HBoxContainer/Multi
@onready var title_label: Label = $VBoxContainer/Title

var title: String
var score: int
var multi: int
var start_position: Vector2

func _on_tween_finished():
	queue_free()
	
func _on_tween(value: Vector2):
	global_position = start_position + value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	
	if !title.is_empty():
		title_label.text = title
		title_label.visible = true
	if score > 0:
		score_label.visible = true
		score_label.text = "+%d" % score
	if multi > 0:
		multi_label.visible = true
		multi_label.text = "+%d" % multi
	
	create_tween()\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)\
		.tween_method(
			_on_tween,
			Vector2(0,0),
			to_position,
			1/speed
		)\
		.finished.connect(_on_tween_finished)
		
static func create(
	position: Vector2,
	score: int,
	multi: int,
	title: String = ""
):
	var score_increase: ScoreIncrease = BLUEPRINT.instantiate()
	score_increase.global_position = position
	score_increase.title = title
	score_increase.score = score
	score_increase.multi = multi
	Global.level.misc.add_child(score_increase)
