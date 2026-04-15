extends PotionEffect
class_name LightEffect

@export var new_texture_scale: float = 1.0
@export var duration: float = 10.0

func apply(target: Node = null) -> void:
	if target.has_method("apply_light_boost"):
		target.apply_light_boost(new_texture_scale, duration)
