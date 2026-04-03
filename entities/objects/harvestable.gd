extends Node2D

@export var debug: bool = false

@export var item: Item
@export var amount: int
@export var respawn_time: float = 0.75 # 0 = never respawn

@onready var base_sprite: Sprite2D = $BaseSprite
@onready var harvested_sprite: Sprite2D = $HarvestedSprite
@onready var text: Sprite2D = $Text

var harvested: bool = false

func _ready() -> void: 
	harvested_sprite.hide()
	text.hide()
	
func harvest() -> void:
	if harvested:
		return
	
	PlayerInventory.add_item(item, amount)
	if debug: print("Harvested ", item.name)
	
	harvested = true
	base_sprite.hide()
	harvested_sprite.show()
	
	if respawn_time > 0:
		await get_tree().create_timer(respawn_time).timeout
		respawn()


func respawn() -> void:
	harvested = false
	base_sprite.show()
	harvested_sprite.hide()


func _on_collectable_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.show()


func _on_collectable_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.hide()



func _on_interactable_interacted() -> void:
	harvest()
