extends Control

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $Panel/GridContainer

func _ready() -> void:
	update_inventory()
	PlayerInventory.inventory_updated.connect(update_inventory)


func update_inventory() -> void:
	for child in grid.get_children():
		child.queue_free()

	for item in PlayerInventory.items:
		var slot: Control = slot_scene.instantiate()
		grid.add_child(slot)

		var amount: int = PlayerInventory.items[item]
		slot.set_item(item, amount)
