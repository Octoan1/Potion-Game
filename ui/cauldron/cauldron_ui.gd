extends Control

@export var mushroom: Item
@export var bug: Item
@export var wood: Item

@export var potion_mushroom_bug: Item
@export var potion_mushroom_wood: Item
@export var potion_wood_bug: Item

@export var slot_scene: PackedScene
@onready var grid: GridContainer = $InventoryGrid


var slot1: Item = null
var slot2: Item = null

func _ready() -> void:
	get_tree().paused = true
	load_inventory()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func add_ingredient(item: Item) -> void:
	if not PlayerInventory.has_item(item, 1):
		return
	
	if slot1 == null:
		slot1 = item
	elif slot2 == null:
		slot2 = item
	else:
		print("Slots full")

	update_ui()

func brew() -> void:
	if slot1 == null or slot2 == null:
		print("Need 2 ingredients")
		return

	var result: Item = get_result(slot1, slot2)

	if result == null:
		print("Invalid combo")

	
	if result:
		# remove ingredients
		PlayerInventory.remove_item(slot1, 1)
		PlayerInventory.remove_item(slot2, 1)

		# add potion
		PlayerInventory.add_item(result, 1)

	if result:
		$Panel/ResultLabel.text = "Created: " + result.name
	else:
		$Panel/ResultLabel.text = "Invalid combo"

	# clear slots
	slot1 = null
	slot2 = null
	
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

func update_ui() -> void:
	$Panel/IngredientSlot1.texture = slot1.icon if slot1 else null
	$Panel/IngredientSlot2.texture = slot2.icon if slot2 else null


func _on_brew_button_pressed() -> void:
	brew()
