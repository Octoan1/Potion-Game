extends PotionEffect
class_name HealEffect

@export var amount: int = 25

func apply(target: Node = null) -> void:
	if target.has_method("heal"):
		target.heal(amount)
