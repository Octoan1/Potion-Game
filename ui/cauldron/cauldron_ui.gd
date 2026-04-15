extends Control

@export var recipe_list: Array[Recipe]

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $InventoryGrid

@onready var slot1: InventorySlot = $Panel/HBoxContainer/IngredientSlot1
@onready var slot2: InventorySlot = $Panel/HBoxContainer/IngredientSlot2
@onready var slot3: InventorySlot = $Panel/HBoxContainer/IngredientSlot3


func _ready() -> void:

	get_tree().paused = true
	PlayerInventory.drinking = false
	$/root/Main/CanvasLayer/PlayerInventoryUI.visible = false
	GameState.cauldron_3_slot = true # just doing 3 slots nows
	slot3.visible = GameState.cauldron_3_slot
	load_inventory()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if slot1.item:
			PlayerInventory.add_item(slot1.item)
		if slot2.item:
			PlayerInventory.add_item(slot2.item)
		if slot3.item:
			PlayerInventory.add_item(slot3.item)
		close()


# =========================
# ADD INGREDIENT
# =========================
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
	elif GameState.cauldron_3_slot and slot3.item == null:
		slot3.item = item
		slot3.icon.texture = item.icon
		PlayerInventory.remove_item(item)
	else:
		print("Slots full")

	load_inventory()
	update_ui()


# =========================
# BREW
# =========================
func brew() -> void:
	if slot1.item == null or slot2.item == null:
		$Panel/ResultLabel.text = "Need at least 2 Ingredients"
		return

	var recipe: Recipe = get_matching_recipe()

	if recipe == null:
		PlayerInventory.add_item(slot1.item)
		slot1.clear_item()
		PlayerInventory.add_item(slot2.item)
		slot2.clear_item()
		if slot3.item:
			PlayerInventory.add_item(slot3.item)
			slot3.clear_item()
		
		print("Invalid combo")
		$Panel/ResultLabel.text = "Invalid combo"
	
	else:
		slot1.clear_item()
		slot2.clear_item()
		slot3.clear_item()

		PlayerInventory.add_item(recipe.result, 1)
		
		# Discover recipe
		GameState.discover_recipe(recipe)
		
		$Panel/ResultLabel.text = "Created: " + recipe.result.name

	load_inventory()
	update_ui()


# =========================
# MATCHING SYSTEM
# =========================

func to_count_map(items: Array) -> Dictionary:
	var map := {}
	
	for item: Item in items:
		if item == null:
			continue
			
		var id: String = item.id
		
		if map.has(id):
			map[id] += 1
		else:
			map[id] = 1
	
	return map


func matches_recipe(input_items: Array, recipe: Recipe) -> bool:
	var input_map: Dictionary = to_count_map(input_items)
	
	var recipe_map := {}
	for item in recipe.ingredients:
		if item == null:
			continue
			
		var id: String = item.id
		
		if recipe_map.has(id):
			recipe_map[id] += 1
		else:
			recipe_map[id] = 1
	
	return input_map == recipe_map


func get_matching_recipe() -> Recipe:
	var items: Array[Item] = []
	
	if slot1.item: items.append(slot1.item)
	if slot2.item: items.append(slot2.item)
	if slot3.item: items.append(slot3.item)

	for recipe in recipe_list:
		if matches_recipe(items, recipe):
			return recipe
	
	return null


# =========================
# INVENTORY UI
# =========================
func load_inventory() -> void:
	for child in grid.get_children():
		child.queue_free()

	for item in PlayerInventory.items:
		if item.type != item.ItemType.INGREDIENT:
			continue
		
		var slot: Control = slot_scene.instantiate()
		grid.add_child(slot)

		var amount: int = PlayerInventory.items[item]
		slot.set_item(item, amount)

		slot.item_clicked.connect(add_ingredient)


func close() -> void:
	get_tree().paused = false
	queue_free()
	PlayerInventory.drinking = true


func update_ui() -> void:
	pass


# =========================
# UI SIGNALS
# =========================
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
		

func _on_ingredient_slot_3_item_clicked(item: Item) -> void:
	if slot3.item != null:
		PlayerInventory.add_item(slot3.item)
		slot3.clear_item()
		load_inventory()


func upgrade() -> void:
	slot3.visible = GameState.cauldron_3_slot
