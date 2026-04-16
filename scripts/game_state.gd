extends Node
#class_name Game

# ===== GOLD & SHOP UPGRADES =====

signal update_gold(curr_gold: int)
@warning_ignore("unused_signal")
signal got_upgrade

var gold: int = 0

var friends_upgrade: bool = false
var bridge_upgrade: bool = false
var cauldron_3_slot: bool = false
var cave_no_dark_upgrade: bool = false

func give_gold(amount: int = 1) -> void:
	gold += amount
	update_gold.emit(gold)
	
func remove_gold(amount: int = 1) -> void:
	gold -= amount
	update_gold.emit(gold)
	
# ===== RECIPE BOOK =====
var has_discover_all_recipes: bool = false
var discovered_recipes: Dictionary[String, bool] = {}

func discover_recipe(recipe: Recipe) -> void:
	if not discovered_recipes.has(recipe.recipe_id):
		discovered_recipes[recipe.recipe_id] = true
		print("Discovered recipe: ", recipe.recipe_name)


func is_recipe_discovered(recipe: Recipe) -> bool:
	return discovered_recipes.has(recipe.recipe_id)
