extends Control

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $Panel/GridContainer
@onready var tooltip: ItemTooltip = preload("res://ui/item_tool_tip.tscn").instantiate()


func _ready() -> void:
	get_parent().add_child.call_deferred(tooltip)
	tooltip.hide()
	tooltip.add_to_group("tooltip")
	
	update_inventory()
	PlayerInventory.inventory_updated.connect(update_inventory)

func close_all_ui() -> void:
	var root := get_tree().root
	
	for node in root.get_tree().get_nodes_in_group("ui_screen"):
		node.hide()

func update_inventory() -> void:
	for child in grid.get_children():
		child.queue_free()

	for item in PlayerInventory.items:
		var slot: Control = slot_scene.instantiate()
		grid.add_child(slot)
		if item.type == item.ItemType.POTION:
			slot.in_hotbar = true
			slot.show_item_count = false
		var amount: int = PlayerInventory.items[item]
		slot.set_item(item, amount)
