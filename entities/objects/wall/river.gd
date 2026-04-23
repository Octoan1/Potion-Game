extends Area2D

@export var target: Marker2D

@export var push_strength: float = 400.0
@export var falloff: float = 0.0 # optional (0 = constant force)

#@onready var target: Marker2D = $Marker2D

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			apply_river_force(body, delta)
			
	#queue_redraw()


func apply_river_force(player: Node2D, delta: float) -> void:
	var dir: Vector2 = (target.global_position - player.global_position)
	
	if dir.length() == 0:
		return
	
	dir = dir.normalized()
	
	var strength := push_strength
	
	# optional falloff (closer to marker = weaker/stronger)
	if falloff != 0.0:
		var dist: float = player.global_position.distance_to(target.global_position)
		strength *= clamp(dist / 200.0, 0.2, 1.5)
	
	# apply force
	player.river_force += dir * strength * delta
	
func _draw() -> void:
	pass
	#draw_line(Vector2.ZERO, to_local(target.global_position), Color.BLUE, 2)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.in_water = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.in_water = false
