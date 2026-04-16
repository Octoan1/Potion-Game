extends Control

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $Panel/GridContainer
@onready var tooltip: ItemTooltip = preload("res://ui/item_tool_tip.tscn").instantiate()


func _ready() -> void:
	add_child(tooltip)
	tooltip.hide()
	tooltip.add_to_group("tooltip")
	
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
