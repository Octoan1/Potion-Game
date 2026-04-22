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
	
	
func use_item(item: Item) -> void:
	if item.type != Item.ItemType.POTION:
		return

	var player: Player = get_tree().get_nodes_in_group("Player")[0]

	for effect in item.effects:
		if effect:
			effect.apply(player)

	#remove_item(item, 1)
