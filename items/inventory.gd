extends Node
class_name Inventory

signal inventory_updated

var debug: bool = false
var drinking: bool = true

var items: Dictionary[Item, int] = {}
const potion_registry = preload("res://items/potion_registry.gd")

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

	# Resolve effects for this potion (registry-based)
	var effects: Array = []
	if item.id != "":
		effects = PotionRegistry.get_effects_for(item.id)

	# Apply each effect (effects may be resources that perform their own timers)
	@warning_ignore("untyped_declaration")
	for effect in effects:
		if effect and effect.has_method("apply"):
			effect.apply()

	# Remove the consumed potion
	remove_item(item, 1)
