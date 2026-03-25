@tool
extends Node
class_name LevelManager

@export_tool_button("Load Level", "Callable") var load_level_action: Callable = load_level
@export var starting_level: String

@export var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(starting_level)


func load_level(path: String = starting_level) -> void: 
	# remove old levels
	for child in self.get_children():
		child.queue_free()

	# load new level
	var level: Node2D = load(path).instantiate()
	self.add_child(level)
	
	var spawn_point: Marker2D = level.find_child("Door").spawn_point
	player.global_position = spawn_point.global_position
