extends Node2D

@export var required_item: Item   # fire potion
@onready var text: Sprite2D = $Text

func interact() -> void:
	try_break()

func try_break() -> void:
	if PlayerInventory.has_item(required_item, 1):
		PlayerInventory.remove_item(required_item, 1)
		destroy_wall()
	else:
		print("Need ", required_item.name)

func destroy_wall() -> void:
	queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.hide()
