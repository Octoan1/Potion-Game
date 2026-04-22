extends PotionEffect
class_name CameraEffect

@export var sprite: String = "default"

func apply(target: Node = null) -> void:
	target.change_camera(sprite)
