extends Node


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_P:
		get_tree().reload_current_scene()
