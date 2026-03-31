extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var input_controller: InputController = $InputController

@export_category("Inventory")
@export var inventory_ui: Control

@export_category("Movement Modifiers")
@export var max_speed: float = 200.0
@export var acceleration: float = 2000.0
@export var friction: float = 1700.0



func _physics_process(delta: float) -> void:
	var input := input_controller.get_input()
	
	# player interaction
	if input[InputController.InputType.INTERACT]:
		try_harvest()
		try_cauldron()
		try_interact()
		
	# player inventory toggling 
	if input[InputController.InputType.INVENTORY]:
		toggle_inventory()
	
	# player movement
	var direction: Vector2 = input[InputController.InputType.MOVE]
	handle_movement(direction, delta)
	move_and_slide()


func handle_movement(direction: Vector2, delta: float) -> void:
	if direction:
		# physical changes
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		
		# visual changes
		animated_sprite_2d.flip_h = direction.x > 0
		animated_sprite_2d.play("walk")
	else:
		# physical changes
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		# visual changes
		animated_sprite_2d.play("default")


func toggle_inventory() -> void:
	inventory_ui.visible = not inventory_ui.visible


func try_harvest() -> void:
	for area: Area2D in $InteractionArea.get_overlapping_areas():
		var body: Node2D = area.get_parent()
		if body.has_method("harvest"):
			body.harvest()


func try_cauldron() -> void:
	for area: Area2D in $InteractionArea.get_overlapping_areas():
		var body: Node2D = area.get_parent()
		if body.has_method("activate_cauldron"):
			body.activate_cauldron()
		if body.has_method("activate_shop"):
			body.activate_shop()
		if body.has_method("activate_sell"):
			body.activate_sell()


func try_interact() -> void:
	for area: Area2D in $InteractionArea.get_overlapping_areas():
		var body: Node2D = area.get_parent()
		if body.has_method("interact"):
			body.interact()
			
	var closest: Node2D = null
	var prev_dist: float = -1
	for body: Node in $InteractionArea.get_overlapping_bodies():
		if body is Interactable:
			var interactable: Interactable = body
		
		var parent: Node2D = body.get_parent()
		var distance: float = self.global_position.distance_to(parent.global_position)
		if closest: print("Curr Closest: ", closest.name)
		if closest == null or distance < prev_dist:
			closest = parent
			prev_dist = distance
	if closest: print("Closest: ", closest.name)
			
		
