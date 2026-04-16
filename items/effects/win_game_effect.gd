extends PotionEffect
class_name WinGameEffect

#@export var radius: float = 100.0

func apply(target: Node = null) -> void:
	target.win()
	
