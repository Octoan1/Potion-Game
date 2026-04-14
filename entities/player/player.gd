extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var input_controller: InputController = $InputController

@export_category("Inventory")
@export var inventory_ui: Control

@export_category("Movement Modifiers")
@export var max_speed: float = 150.0
var original_max_speed: float = max_speed
@export var acceleration: float = 1700.0
@export var friction: float = 1700.0

@export_category("Health")
@export var health: float = 100.0

@export_category("Potion Effects")
@onready var stationary_potion_effects_container: Node = $StatPotionEffectsContainer
@export var burn_area: PackedScene

func _physics_process(delta: float) -> void:
	var input := input_controller.get_input()
	
	# player interaction
	if input[InputController.InputType.INTERACT]:
		try_interact()
		
	# player inventory toggling 
	if input[InputController.InputType.INVENTORY]:
		toggle_inventory()
	if Input.is_action_just_pressed("ui_cancel"):
		close_inventory()
	
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

func close_inventory() -> void:
	inventory_ui.visible = false


func try_interact() -> void:
	for area: Area2D in $InteractionArea.get_overlapping_areas():
		var body: Node2D = area.get_parent()
		if body.has_method("interact"):
			body.interact()
			
	var closest: Node2D = get_closest_interactable()
	if not closest: return
	#print("Closet: ", closest)
	#print("Closest parent: ", closest.get_parent())
	
	# interact
	var interactable: Interactable =	 closest.get_node("Interactable")
	interactable.interact()
	
			
	
func get_closest_interactable() -> Node2D:
	#print($InteractionArea.get_overlapping_bodies())
	var closest: Node = null
	var closest_dist: float = -1
	for body: Node2D in $InteractionArea.get_overlapping_bodies():
		if not body.get_node("Interactable"): # skip nodes that don't have interactable (shouldn't happen)
			continue
		
		var distance: float = self.global_position.distance_to(body.global_position)
		
		#if closest: print("Curr Closest: ", closest.name)
		if closest == null or distance < closest_dist:
			#closest = body.get_node("Interactable")
			closest = body
			closest_dist = distance
	
	return closest
		
# ===== POTION EFFECT HANDLING =====
func heal(amount: int) -> void:
	health += amount

func apply_speed_boost(amount: float, duration: float) -> void:
	max_speed *= amount
	
	await get_tree().create_timer(duration).timeout
	
	max_speed /= amount
	if max_speed < original_max_speed:
		max_speed = original_max_speed

func burn(radius: float) -> void:
	var new_burn_area: Area2D = burn_area.instantiate()
	new_burn_area.global_position = self.global_position
	
	stationary_potion_effects_container.add_child(new_burn_area)
			
		
