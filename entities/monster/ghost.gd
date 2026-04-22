extends CharacterBody2D

@export var speed: float = 60.0
@export var detection_range: float = 200.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player: Node2D = null
var frozen: bool = false
var attacking: bool = false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(_delta: float) -> void:
	if frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if player == null:
		return
		
	if attacking:
		var dir: Vector2 = (player.global_position - global_position).normalized()
		animated_sprite_2d.flip_h = dir.x > 0
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.reset_level()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attacking = true
		animated_sprite_2d.play("attack")


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attacking = false
		animated_sprite_2d.play("default")
