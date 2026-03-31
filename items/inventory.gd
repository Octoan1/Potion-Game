extends Node
class_name Inventory

signal inventory_updated

var debug: bool = false
var drinking: bool = true

var items: Dictionary[Item, int] = {}

func add_item(item: Item, amount: int = 1) -> void:
	if item in items:
		items[item] += amount
	else:
		items[item] = amount

	inventory_updated.emit()
	if debug: print(items)

func remove_item(item: Item, amount: int = 1) -> void:
	if item in items:
		items[item] -= amount
		if items[item] <= 0:
			items.erase(item)
	
	inventory_updated.emit()
	if debug: print(items)


func has_item(item: Item, amount: int = 1) -> bool:
	if debug: print(items)
	
	return item in items and items[item] >= amount
	
	
# testing
func use_speed_potion(item: Item) -> void:
	remove_item(item, 1)
	get_tree().get_nodes_in_group("Player").get(0).max_speed *= 3
	get_tree().get_nodes_in_group("Player").get(0).friction *= 3
	await get_tree().create_timer(5.0).timeout
	print("hi")
	get_tree().get_nodes_in_group("Player").get(0).max_speed /= 3
	get_tree().get_nodes_in_group("Player").get(0).friction /= 3
	
func use_health_potion(item: Item) -> void:
	remove_item(item, 1)
	get_tree().current_scene.get_node("CanvasLayer/HealthBar").value += 25
