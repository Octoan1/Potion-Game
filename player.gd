extends CharacterBody2D

signal update_display(amount: int)


const SPEED = 300.0

var ingredient_count: int = 0


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		#velocity = move_toward(velocity, Vector2.ZERO, SPEED)

	move_and_slide()


func _on_tree_harvest() -> void:
	ingredient_count += 1
	
	update_display.emit(ingredient_count)


func _on_cauldron_ui_craft_potion() -> void:
	ingredient_count -= 1
	
	update_display.emit(ingredient_count)
