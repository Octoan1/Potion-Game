extends PotionEffect
class_name ScreenFilterEffect

@export var change: String = "default"

func apply(target: Node = null) -> void:
	target.apply_screen_filter(change)
