extends Area2D

@onready var timer: Timer = $FireLastTimer

func _ready() -> void:
	timer.start()
	

func _on_fire_last_timer_timeout() -> void:
	self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("bramble"):
		if body.has_method("burn"):
			body.burn()
