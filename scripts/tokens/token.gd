extends Control
class_name Token

@export var title: String
@export var description: String

@onready var selector: TokenSelector = $Selector
@onready var hover_node: TextureRect = $Hover
@onready var select_node: TextureRect = $Select

var hover: bool = false:
	set(value):
		hover = value
		hover_node.visible = hover

var select: bool = false:
	set(value):
		select = value
		select_node.visible = select
		
func init():
	selector.init()
		
