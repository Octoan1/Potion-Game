extends PotionEffect
class_name SpriteEffect

@export var sprite: String = "default"

func apply(target: Node = null) -> void:
	target.change_sprite(sprite)
