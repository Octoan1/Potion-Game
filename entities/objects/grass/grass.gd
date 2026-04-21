extends AnimatedSprite2D


func _ready() -> void:
	var type: float = randf()
	
	if type >= 0.95:
		self.play("flower")
		print("flower")
	elif type >= 0.6:
		self.play("grass2")
