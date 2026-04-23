extends PotionEffect
class_name RandomEffect

@export var effect: String

func apply(target: Node = null) -> void:
	target.apply_random_effect(effect)
