extends PotionEffect
class_name SizeEffect

@export var multiplier: Vector2 = Vector2.ONE
@export var duration: float = 15

func apply(target: Node = null) -> void:
	target.change_size(multiplier, duration)
