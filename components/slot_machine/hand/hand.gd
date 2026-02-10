extends Control
class_name SlotMachineHand

@onready var slot_machine: SlotMachine = $"../.."
@onready var containers: HBoxContainer = $MarginContainer/Containers

func _on_container_selected(token: Token):
	for container: SlotMachineHandContainer in containers.get_children():
		if container.token != token and container.select:
			container.select = false

func _on_token_tree_exited(container: SlotMachineHandContainer):
	return func():
		container.queue_free()

func init():
	for i in range(3):
		var container = SlotMachineHandContainer.create(slot_machine.pool.token.next())
		container.selected.connect(_on_container_selected)
		container.token.tree_exited.connect(_on_token_tree_exited(container))
		containers.add_child(container)
		container.token.init()
