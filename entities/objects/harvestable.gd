extends Node2D

@export var debug: bool = false

@export var item: Item
@export var amount: int
@export var respawn_time: float = 0.75 # 0 = never respawn

@onready var base_sprite: Sprite2D = $BaseSprite
var base_sprite_scale: Vector2
@onready var harvested_sprite: Sprite2D = $HarvestedSprite
@onready var text: Sprite2D = $Text

var harvest_sound: AudioStream
const HARVEST_SOUND = preload("res://audio/creatorshome-sharp-pop-328170.mp3")

var harvested: bool = false

func _ready() -> void: 
	harvested_sprite.hide()
	text.hide()
	base_sprite_scale = base_sprite.scale
	
func harvest() -> void:
	if harvested:
		return
	
	PlayerInventory.add_item(item, amount)
	if debug: print("Harvested ", item.name)
	
	harvested = true
	#base_sprite.hide()
	#harvested_sprite.show()
	text.hide()
	
	var tween: Tween = create_tween()
	tween.tween_property(base_sprite, "scale", Vector2.ONE * 1.4, 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	play_harvest_sound()
	await tween.finished
	base_sprite.hide()
	
	if respawn_time > 0:
		await get_tree().create_timer(respawn_time).timeout
		respawn()


func respawn() -> void:
	harvested = false
	base_sprite.show()
	harvested_sprite.hide()
	base_sprite.scale = base_sprite_scale


func _on_collectable_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not harvested:
		text.show()


func _on_collectable_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.hide()



func _on_interactable_interacted() -> void:
	harvest()
	
func play_harvest_sound() -> void:
	var player := AudioStreamPlayer.new()
	player.stream = HARVEST_SOUND
	add_child(player)
	player.play()
	
	player.finished.connect(player.queue_free)
