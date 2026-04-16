extends Node2D

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.show_light()
	player.in_dark_area = true


func _on_door_used_door() -> void:
	player.in_dark_area = false
	if not player.light_boost_on:
		player.hide_light()
