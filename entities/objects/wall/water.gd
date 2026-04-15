extends Area2D

@export var push_direction: Vector2 = Vector2.RIGHT
@export var push_strength: float = 200.0

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.river_force += push_direction.normalized() * push_strength * delta
			#body.river_force = body.river_force.limit_length(push_strength*1.25)
