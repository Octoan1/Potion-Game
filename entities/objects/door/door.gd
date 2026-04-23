extends Node2D

signal used_door

@export var target_scene : String
@export var target_door_id : String   
@export var door_id : String         

func _on_interactable_interacted() -> void:
	var level_manager: Node = get_tree().root.get_node("Main").get_node("LevelManager")
	
	# store which door we want to arrive at
	level_manager.next_door_id = target_door_id
	
	used_door.emit()
	level_manager.call_deferred("play_door_sound")
	level_manager.call_deferred("load_level", target_scene)
