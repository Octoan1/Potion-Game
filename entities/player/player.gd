extends CharacterBody2D

const SPEED = 200.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
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
