extends Node2D
#class_name Main

@onready var level_container: Node = $LevelContainer
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level("res://levels/outside.tscn")


func load_level(path: String) -> void: 
	# remove old levels
	for child in $LevelContainer.get_children():
		child.queue_free()

	# load new level
	var level: Node2D = load(path).instantiate()
	level_container.add_child(level)
	
	var spawn_point: Marker2D = level.find_child("Door").spawn_point
	player.global_position = spawn_point.global_position
	
	
