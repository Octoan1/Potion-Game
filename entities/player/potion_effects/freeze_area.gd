extends Area2D

@export var duration: float = 3.0

@onready var freeze_last_timer: Timer = $FreezeLastTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

var affected_ghosts: Array[Node2D] = []

func _ready() -> void:
	# freeze everything inside
	for body in get_overlapping_bodies():
		if body.is_in_group("Ghost"):
			freeze(body)
	
	freeze_last_timer.start()
	



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ghost"):
		freeze(body)


func freeze(ghost: Node2D) -> void:
	if ghost in affected_ghosts:
		return
	
	ghost.frozen = true
	affected_ghosts.append(ghost)


func unfreeze_all() -> void:
	for ghost: Node2D in affected_ghosts:
		if ghost:
			ghost.frozen = false


func _on_free_last_timer_timeout() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite_2d, "modulate", Color(1,1,1,0), 1)
	
	await tween.finished
	unfreeze_all()
	
	queue_free()
