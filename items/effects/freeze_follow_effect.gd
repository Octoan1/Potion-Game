extends PotionEffect
class_name FreezeEffect

@export var radius: float = 100.0

func apply(target: Node = null) -> void:
	#if target.has_method("freeze"):
	target.freeze_follow(radius)
