extends Control

@export var mushroom: Item
@export var bug: Item
@export var wood: Item

@export var potion_mushroom_bug: Item
@export var potion_mushroom_wood: Item
@export var potion_wood_bug: Item

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $InventoryGrid


@onready var slot1: InventorySlot = $Panel/IngredientSlot1
@onready var slot2: InventorySlot = $Panel/IngredientSlot2

func _ready() -> void:
	get_tree().paused = true
	PlayerInventory.drinking = false
	$/root/Main/CanvasLayer/InventoryUI.visible = false
	load_inventory()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if slot1.item:
			PlayerInventory.add_item(slot1.item)
		if slot2.item:
			PlayerInventory.add_item(slot2.item)
		close()

func add_ingredient(item: Item) -> void:
	if not PlayerInventory.has_item(item, 1):
		return
	
	if slot1.item == null:
		slot1.item = item
		slot1.icon.texture = item.icon
		PlayerInventory.remove_item(item)
	elif slot2.item == null:
		slot2.item = item
		slot2.icon.texture = item.icon
		PlayerInventory.remove_item(item)
	else:
		print("Slots full")

	load_inventory()
	update_ui()

func brew() -> void:
	if slot1.item == null or slot2.item == null:
		print("Need 2 ingredients")
		return

	var result: Item = get_result(slot1.item, slot2.item)

	if result == null:
		PlayerInventory.add_item(slot1.item)
		slot1.clear_item()
		PlayerInventory.add_item(slot2.item)
		slot2.clear_item()
		
		print("Invalid combo")
		
		$Panel/ResultLabel.text = "Invalid combo"
	
	elif result:
		# remove ingredients
		#PlayerInventory.remove_item(slot1.item)
		#PlayerInventory.remove_item(slot2.item)
		slot1.clear_item()
		slot2.clear_item()

		# add potion
		PlayerInventory.add_item(result, 1)

		$Panel/ResultLabel.text = "Created: " + result.name

	
	load_inventory()   # update inventory display
	update_ui()
	
func get_result(a: Item, b: Item) -> Item:

	if (a == mushroom and b == bug) or (a == bug and b == mushroom):
		return potion_mushroom_bug

	if (a == mushroom and b == wood) or (a == wood and b == mushroom):
		return potion_mushroom_wood

	if (a == wood and b == bug) or (a == bug and b == wood):
		return potion_wood_bug

	return null

func load_inventory() -> void:
	for child in grid.get_children():
		child.queue_free()

	for item in PlayerInventory.items:
		var slot: Control = slot_scene.instantiate()
		grid.add_child(slot)

		var amount: int = PlayerInventory.items[item]
		slot.set_item(item, amount)

		# CONNECT CLICK
		slot.item_clicked.connect(add_ingredient)

func close() -> void:
	get_tree().paused = false
	queue_free()
	PlayerInventory.drinking = true

func update_ui() -> void:
	#$Panel/IngredientSlot1.texture = slot1.icon if slot1 else null
	#$Panel/IngredientSlot2.texture = slot2.icon if slot2 else null
	pass

func _on_brew_button_pressed() -> void:
	brew()


func _on_ingredient_slot_1_item_clicked(item: Item) -> void:
	if slot1.item != null:
		PlayerInventory.add_item(slot1.item)
		slot1.clear_item()
		
		load_inventory()


func _on_ingredient_slot_2_item_clicked(item: Item) -> void:
	if slot2.item != null:
		PlayerInventory.add_item(slot2.item)
		slot2.clear_item()
		
		load_inventory()
