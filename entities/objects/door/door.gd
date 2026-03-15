extends Node2D

@export var target_scene : String
@export var spawn_point : Marker2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#GameManager.spawn_point = spawn_point
		var main = get_tree().root.get_node("Main")
		main.call_deferred("load_level", target_scene)
