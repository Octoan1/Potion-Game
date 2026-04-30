extends Control

@export var recipe_database: RecipeDatabase

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $InventoryGrid

@onready var slot1: InventorySlot = $Panel/HBoxContainer/IngredientSlot1
@onready var slot2: InventorySlot = $Panel/HBoxContainer/IngredientSlot2
@onready var slot3: InventorySlot = $Panel/HBoxContainer/IngredientSlot3

@onready var result_h_box_container_2: HBoxContainer = $Panel/ResultHBoxContainer2
@onready var result_label: Label = $Panel/ResultHBoxContainer2/ResultLabel
@onready var result_icon: TextureRect = $Panel/ResultHBoxContainer2/ResultIcon
@onready var hide_result: Timer = $HideResult

@export var placeholder_potion: Item

@onready var ui_click: AudioStreamPlayer = $UIClick
@onready var ui_error: AudioStreamPlayer = $UIError
@onready var potion_success: AudioStreamPlayer = $PotionSuccess
@onready var enter_exit_cauldron: AudioStreamPlayer = $EnterExitCauldron


func _ready() -> void:
	close_all_ui()
	get_tree().root.get_node("/root/Main/CanvasLayer/Hotbar").hide()
	enter_exit_cauldron.play()
	get_tree().paused = true
	PlayerInventory.drinking = false
	$/root/Main/CanvasLayer/PlayerInventoryUI.visible = false
	GameState.cauldron_3_slot = true # just doing 3 slots nows
	slot3.visible = GameState.cauldron_3_slot
	load_inventory()

func close_all_ui() -> void:
	var root := get_tree().root
	
	for node in root.get_tree().get_nodes_in_group("ui_screen"):
		node.hide()

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
func is_item_already_used(item: Item) -> bool:
	return slot1.item == item or slot2.item == item or slot3.item == item

func add_ingredient(item: Item) -> void:
	if slot1.item == item:
		ui_click.play(0.23)
		PlayerInventory.add_item(slot1.item)
		slot1.clear_item()
		load_inventory()
		return
		
	if slot2.item == item:
		ui_click.play(0.23)
		PlayerInventory.add_item(slot2.item)
		slot2.clear_item()
		load_inventory()
		return
		
	if slot3.item == item:
		ui_click.play(0.23)
		PlayerInventory.add_item(slot3.item)
		slot3.clear_item()
		load_inventory()
		return

	if not PlayerInventory.has_item(item, 1):
		return

	ui_click.play(0.23)

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
	if slot1.item == null or slot2.item == null or slot3.item == null:
		result_label.text = "Need 3 Ingredients"
		result_icon.hide()
		show_result()
		ui_error.play()
		return

	var recipe: Recipe = get_matching_recipe()

	if recipe == null:
		#PlayerInventory.add_item(slot1.item)
		#slot1.clear_item()
		#PlayerInventory.add_item(slot2.item)
		#slot2.clear_item()
		#if slot3.item:
			#PlayerInventory.add_item(slot3.item)
			#slot3.clear_item()
		
		ui_error.play()
		print("Invalid combo")
		result_label.text = "Those Ingredients don't mix well!"
		# not final
		#slot1.clear_item()
		#slot2.clear_item()
		#slot3.clear_item()
		#result_label.text = "Created: Placeholder Potion"
		#PlayerInventory.add_item(placeholder_potion)
		result_icon.hide()
		show_result()
	
	# recipe already discovered
	elif GameState.is_recipe_discovered(recipe):
		PlayerInventory.add_item(slot1.item)
		slot1.clear_item()
		PlayerInventory.add_item(slot2.item)
		slot2.clear_item()
		if slot3.item:
			PlayerInventory.add_item(slot3.item)
			slot3.clear_item()
		
		ui_error.play()
		result_label.text = "You already discovered that recipe!"
		result_icon.hide()
		show_result()
		
	
	else:
		slot1.clear_item()
		slot2.clear_item()
		slot3.clear_item()

		PlayerInventory.add_item(recipe.result, 1)
		
		# Discover recipe
		GameState.discover_recipe(recipe)
		
		result_h_box_container_2.show()
		result_label.text = "Discovered: " + recipe.result.name + "!"
		
		potion_success.play()
		result_icon.texture = recipe.result.icon
		#result_icon.scale = Vector2.ONE * 0.1
		#var tween: Tween = create_tween()
		#tween.tween_property(result_icon, "scale", Vector2.ONE, 2.5)
		#await tween.finished
		result_icon.show()
		show_result()
		#await hide_result.timeout
		
		#result_h_box_container_2.hide()
		

	load_inventory()
	update_ui()

func show_result() -> void:
	hide_result.start()
	result_h_box_container_2.show()

func _on_hide_result_timeout() -> void:
	result_h_box_container_2.hide()

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

	for recipe in recipe_database.recipe_list:
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

		#slot.item_clicked.connect(add_ingredient)
		
		if is_item_already_used(item):
			slot.show_disabled(true)
		else:
			slot.show_disabled(false)

		slot.item_clicked.connect(add_ingredient)


func close() -> void:
	enter_exit_cauldron.play()
	get_tree().paused = false
	queue_free()
	PlayerInventory.drinking = true
	get_tree().root.get_node("/root/Main/CanvasLayer/Hotbar").show()


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
