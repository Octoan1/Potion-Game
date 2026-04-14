extends PotionEffect
class_name SpeedEffect

@export var speed_boost: float = 100
@export var duration: float = 5.0

func apply(target: Node = null) -> void:
	if target.has_method("apply_speed_boost"):
		target.apply_speed_boost(speed_boost, duration)
