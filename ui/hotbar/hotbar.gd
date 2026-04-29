extends Control
class_name Hotbar

@export var slot_scene: PackedScene
@onready var container: HBoxContainer = $HBoxContainer

var slots: Array = []  # holds item references
var empty_index: int = 0

func _ready() -> void:
	# create 5 slots
	for i in range(5):
		var slot: InventorySlot = slot_scene.instantiate()
		slot.show_item_count = false
		container.add_child(slot)
		slots.append(null)

func set_slot(index: int, item: Item) -> void:
	slots[index] = item
	container.get_child(index).set_item(item, 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hotbar_1"):
		drink_slot(0)
	elif event.is_action_pressed("hotbar_2"):
		drink_slot(1)
	elif event.is_action_pressed("hotbar_3"):
		drink_slot(2)
	elif event.is_action_pressed("hotbar_4"):
		drink_slot(3)
	elif event.is_action_pressed("hotbar_5"):
		drink_slot(4)
		

func drink_slot(index: int) -> void:
	var item: Item = slots[index]
	
	if item == null:
		return
	
	if item.type != item.ItemType.POTION:
		return
	
	# apply effect (you already have this system)
	#PlayerInventory.drink(item)
	#PlayerInventory.dr

	# remove from inventory
	#PlayerInventory.remove_item(item, 1)

	# clear slot
	slots[index] = null
	container.get_child(index).clear_item()
	
func add_potion(item: Item) -> void:
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = item
			container.get_child(i).set_item(item, 1)
			return
	
	print("Hotbar full")
	
