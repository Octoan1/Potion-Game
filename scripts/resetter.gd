extends Node


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_P:
		get_tree().reload_current_scene()
	if event is InputEventKey and event.keycode == KEY_0:
		$"../LevelManager".load_level("res://levels/playground/playground.tscn")
	if event is InputEventKey and event.keycode == KEY_9:
		$"../LevelManager".load_level($"../LevelManager".starting_level)
	if event is InputEventKey and event.keycode == KEY_8:
		GameState.has_discover_all_recipes = true
