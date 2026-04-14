extends StaticBody2D

@onready var burn_time: Timer = $BurnTime
@onready var sprite_2d: Sprite2D = $Sprite2D

func burn() -> void:
	if not burn_time.is_stopped():
		return
	
	burn_time.start()

func _process(_delta: float) -> void:
	if burn_time.is_stopped():
		return
	
	# burn effects
	sprite_2d.rotation = randf_range(-0.05, 0.05)
	var t: float = (burn_time.wait_time - burn_time.time_left) / burn_time.wait_time
	sprite_2d.modulate = lerp(Color.WHITE, Color.DARK_RED, t)
	
func _on_burn_time_timeout() -> void:
	queue_free()
