extends Control

@export var mushroom: Item
@export var bug: Item
@export var fire: Item

@export var potion_mushroom_bug: Item
@export var potion_mushroom_fire: Item
@export var potion_fire_bug: Item


var slot1: Item = null
var slot2: Item = null

func _ready() -> void:
	get_tree().paused = true

func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func add_ingredient(item: Item) -> void:
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
		return

	# remove ingredients
	PlayerInventory.remove_item(slot1, 1)
	PlayerInventory.remove_item(slot2, 1)

	# add potion
	PlayerInventory.add_item(result, 1)

	$Panel/ResultLabel.text = "Created: " + result.name

	# clear slots
	slot1 = null
	slot2 = null
	update_ui()
	
func get_result(a: Item, b: Item) -> Item:

	if (a == mushroom and b == bug) or (a == bug and b == mushroom):
		return potion_mushroom_bug

	if (a == mushroom and b == fire) or (a == fire and b == mushroom):
		return potion_mushroom_fire

	if (a == fire and b == bug) or (a == bug and b == fire):
		return potion_fire_bug

	return null

func close():
	get_tree().paused = false
	queue_free()

func update_ui() -> void:
	$Panel/IngredientSlot1.texture = slot1.icon if slot1 else null
	$Panel/IngredientSlot2.texture = slot2.icon if slot2 else null


func _on_brew_button_pressed() -> void:
	brew()
