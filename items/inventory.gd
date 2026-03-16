extends Node
class_name Inventory

var debug: bool = true

var items: Dictionary[Item, int] = {}

func add_item(item: Item, amount: int = 1) -> void:
	if item in items:
		items[item] += amount
	else:
		items[item] = amount

	if debug: print(items)

func remove_item(item: Item, amount: int = 1) -> void:
	if item in items:
		items[item] -= amount
		if items[item] <= 0:
			items.erase(item)
	
	if debug: print(items)


func has_item(item: Item, amount: int = 1) -> bool:
	if debug: print(items)
	
	return item in items and items[item] >= amount
