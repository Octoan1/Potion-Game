@tool
extends Node
class_name LevelManager

@export_tool_button("Load Level", "Callable") var load_level_action: Callable = load_level
@export var starting_level: String

@export var player: CharacterBody2D

var next_door_id : String = ""

@onready var door_sound: AudioStreamPlayer = $"../DoorSound"

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
	
	place_player()


func place_player() -> void:
	if next_door_id == "":
		var spawn_point: Marker2D = get_tree().get_first_node_in_group("spawn_point")
		if spawn_point:
			player.global_position = spawn_point.global_position
		return
		
	
	var doors: Array[Node] = get_tree().get_nodes_in_group("doors")
	
	for door in doors:
		if door.door_id == next_door_id:
			player.global_position = door.global_position
			break
			
func play_door_sound() -> void:
	door_sound.play()
			
