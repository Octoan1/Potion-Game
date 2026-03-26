extends Control

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $InventoryGrid

@onready var slot1: InventorySlot = $Panel/SellSlot

func _ready() -> void:
	get_tree().paused = true
	PlayerInventory.drinking = false
	
	$/root/Main/CanvasLayer/InventoryUI.visible = false
	load_inventory()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if slot1.item:
			PlayerInventory.add_item(slot1.item)
		close()

func add_potion(item: Item) -> void:
	if not PlayerInventory.has_item(item, 1):
		return
	
	if slot1.item == null:
		slot1.item = item
		slot1.icon.texture = item.icon
		PlayerInventory.remove_item(item)
	else:
		print("Slots full")

	load_inventory()
	update_ui()

func sell() -> void:
	if slot1.item == null:
		print("Need something to sell")
		$Panel/ResultLabel.text = "Result: Nothing to Sell"
		return


	$Panel/ResultLabel.text = "Sold: " + slot1.item.name
	GameState.give_gold(	1)

	slot1.clear_item()
	load_inventory()   # update inventory display
	update_ui()


func load_inventory() -> void:
	for child in grid.get_children():
		child.queue_free()

	for item in PlayerInventory.items:
		if item.type != 1:
			continue
		
		var slot: Control = slot_scene.instantiate()
		grid.add_child(slot)

		var amount: int = PlayerInventory.items[item]
		slot.set_item(item, amount)

		# CONNECT CLICK
		slot.item_clicked.connect(add_potion)

func close() -> void:
	get_tree().paused = false
	queue_free()
	PlayerInventory.drinking = true

func update_ui() -> void:
	#$Panel/IngredientSlot1.texture = slot1.icon if slot1 else null
	#$Panel/IngredientSlot2.texture = slot2.icon if slot2 else null
	pass


func _on_sell_slot_item_clicked(item: Item) -> void:
	if slot1.item != null:
		PlayerInventory.add_item(slot1.item)
		slot1.clear_item()
		
		load_inventory()


func _on_sell_button_pressed() -> void:
	sell()
