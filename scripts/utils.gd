extends Node

func reset_tween(object: Object, property: StringName = "tween"):
	if object.get(property):
		object.get(property).kill()
	object.set(property, create_tween())
