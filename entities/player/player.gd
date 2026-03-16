extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var max_speed: float = 200.0
@export var acceleration: float = 2000.0
@export var friction: float = 1700.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		
		animated_sprite_2d.flip_h = direction.x > 0
		animated_sprite_2d.play("walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		animated_sprite_2d.play("default")
		#velocity = move_toward(velocity, Vector2.ZERO, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action("interact"):
		try_harvest()

func try_harvest() -> void:
	for area: Area2D in $InteractionArea.get_overlapping_areas():
		var body: Node2D = area.get_parent()
		if body.has_method("harvest"):
			body.harvest()
