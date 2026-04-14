extends PotionEffect
class_name FireEffect

@export var radius: float = 100.0

func apply(target: Node = null) -> void:
	if target.has_method("burn"):
		target.burn(radius)
	#if target == null:
		#return
	#
	## find nearby burnable objects
	#var space = target.get_world_2d().direct_space_state
	#
	#var query = PhysicsShapeQueryParameters2D.new()
	#var shape = CircleShape2D.new()
	#shape.radius = radius
	#
	#query.shape = shape
	#query.transform = target.global_transform
	#
	#var results = space.intersect_shape(query)
	#
	#for result in results:
		#var collider = result.collider
		#
		#if collider and collider.has_method("burn"):
			#collider.burn()
