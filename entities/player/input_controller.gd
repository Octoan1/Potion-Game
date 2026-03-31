extends Node
class_name InputController

enum InputType {
	MOVE,
	INTERACT,
	INVENTORY
}

func get_input() -> Dictionary:
	return {
		InputType.MOVE: Input.get_vector("move_left", "move_right", "move_up", "move_down"),
		InputType.INTERACT: Input.is_action_just_pressed("interact"),
		InputType.INVENTORY: Input.is_action_just_pressed("inventory")
	}
