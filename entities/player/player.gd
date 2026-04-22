extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var input_controller: InputController = $InputController

@export_category("Inventory")
@export var inventory_ui: Control

@export_category("Movement Modifiers")
@export var max_speed: float = 120.0
var original_max_speed: float = max_speed
@export var acceleration: float = 1700.0
@export var friction: float = 1000.0
var external_velocity: Vector2 = Vector2.ZERO
var river_force: Vector2 = Vector2.ZERO

@export_category("Health")
@export var health: int = 1
@export var health_container: HBoxContainer
@export var heart_icon_scene: PackedScene

@export_category("Potion Effects")
@onready var stationary_potion_effects_container: Node = $StatPotionEffectsContainer
@onready var potion_effects_container: Node2D = $PotionEffectsContainer
var has_speed_effect: bool = false
@export var burn_area: PackedScene
@onready var light_source: Node2D = $PotionEffectsContainer/LightSource
var light_boost_on: bool = false
var in_dark_area: bool = false
@export var freeze_area: PackedScene

@export var win_screen: Control
# size effects
var original_scale: Vector2

func _ready() -> void:
	original_scale = self.scale

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
	
	# river
	if not has_speed_effect:
		velocity += river_force
	else:
		velocity += river_force / 3
	velocity = velocity.limit_length(max_speed * 1.5)
	river_force = Vector2.ZERO # reset for next frame
	move_and_slide()

func apply_external_force(force: Vector2) -> void:
	external_velocity += force


func handle_movement(direction: Vector2, delta: float) -> void:
	if direction:
		# physical changes
		var input_velocity: Vector2 = velocity.move_toward(direction * max_speed, acceleration * delta)
		velocity = input_velocity
		
		# visual changes
		animated_sprite_2d.flip_h = direction.x > 0
		animated_sprite_2d.play("walk")
	else:
		# physical changes
		var input_velocity: Vector2 = velocity.move_toward(Vector2.ZERO, friction * delta) # no input vel
		velocity = input_velocity
		
		# visual changes
		animated_sprite_2d.play("default")
	
	# reset external velocity so it doesnt compound
	external_velocity = Vector2.ZERO


func toggle_inventory() -> void:
	inventory_ui.visible = not inventory_ui.visible

func close_inventory() -> void:
	inventory_ui.visible = false


func _on_timer_timeout() -> void:
	$DarkGrabLabel.hide()

func try_interact() -> void:	
	for area: Area2D in $InteractionArea.get_overlapping_areas():
		var body: Node2D = area.get_parent()
		if body.has_method("interact"):
			body.interact()
			
	var closest: Node2D = get_closest_interactable()
	if not closest: return
	#print("Closet: ", closest)
	#print("Closest parent: ", closest.get_parent())
	
	if in_dark_area and not closest.is_in_group("doors") and not light_boost_on:
		$DarkGrabLabel.show()
		$DarkGrabLabel/Timer.start()
		return
	
	# interact
	var interactable: Interactable = closest.get_node("Interactable")
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
	
# ===== PLAYER DEATH =====
func reset_level() -> void:
	var level_manager: Node = get_tree().root.get_node("Main").get_node("LevelManager")
	level_manager.call_deferred("load_level", "res://levels/outside.tscn")
	
# ===== POTION EFFECT HANDLING =====
func heal(amount: int) -> void:
	health += amount
	for i in range(amount):
		var heart: TextureRect = heart_icon_scene.instantiate()
		health_container.add_child(heart)

func apply_speed_boost(amount: float, duration: float) -> void:
	max_speed *= amount
	has_speed_effect = true
	await get_tree().create_timer(duration).timeout
	
	has_speed_effect = false
	max_speed /= amount
	if max_speed < original_max_speed:
		max_speed = original_max_speed

func burn(_radius: float) -> void:
	var new_burn_area: Area2D = burn_area.instantiate()
	new_burn_area.global_position = self.global_position
	
	stationary_potion_effects_container.add_child(new_burn_area)
			
func hide_light() -> void:
	light_source.hide()
	
func show_light() -> void:
	light_source.show()

func apply_light_boost(new_texture_scale: float, duration: float) -> void:
	light_source.boost(new_texture_scale, duration)
	light_boost_on = true
	show_light()
	
func _on_light_source_light_boost_ended() -> void:
	light_boost_on = false
	if not in_dark_area:
		hide_light()
		
func freeze(_radius: float) -> void:
	var new_freeze_area: Area2D = freeze_area.instantiate()
	new_freeze_area.global_position = self.global_position
	
	stationary_potion_effects_container.add_child(new_freeze_area)
	
func freeze_follow(_radius: float) -> void:
	print("follow")
	var new_freeze_area: Area2D = freeze_area.instantiate()
	new_freeze_area.global_position = self.global_position
	
	potion_effects_container.add_child(new_freeze_area)
	
func win() -> void:
	win_screen.show()
	get_tree().paused = true
	
func change_size(new_scale: Vector2, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", new_scale, 2)
	await get_tree().create_timer(duration).timeout

	var tween2: Tween = create_tween()
	tween2.set_ease(Tween.EASE_IN)
	tween2.tween_property(self, "scale", original_scale, 2)
