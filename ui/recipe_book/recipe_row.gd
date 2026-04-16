extends HBoxContainer
class_name RecipeRow

@onready var ing1: InventorySlot = $InventorySlot
@onready var ing2: InventorySlot = $InventorySlot2
@onready var ing3: InventorySlot = $InventorySlot3
@onready var result: InventorySlot = $InventorySlot4

@onready var plus2: TextureRect = $Plus2
@onready var plus3: TextureRect = $Plus3
@onready var equals: TextureRect = $Equals


func setup(recipe: Recipe, discovered: bool) -> void:
	if not discovered:
		set_unknown(recipe)
		return

	var ingredients: Array[Item] = recipe.ingredients

	# Ingredient 1
	if ingredients.size() >= 1:
		ing1.set_item(ingredients[0], 1)

	# Ingredient 2
	if ingredients.size() >= 2:
		ing2.set_item(ingredients[1], 1)
		ing2.visible = true
		plus2.visible = true
	else:
		ing2.visible = false
		plus2.visible = false

	# Ingredient 3
	if ingredients.size() >= 3:
		ing3.set_item(ingredients[2], 1)
		ing3.visible = true
		plus3.visible = true
	else:
		ing3.visible = false
		plus3.visible = false

	# Result
	result.set_item(recipe.result, 1)


func set_unknown(recipe: Recipe) -> void:
	var unknown_icon: Texture = load("res://assets/ui/unknown.png")
	var count: int = recipe.ingredients.size()

	# Ingredient 1
	ing1.set_item(null, 0)
	ing1.icon.texture = unknown_icon
	ing1.visible = true

	# Ingredient 2
	if count >= 2:
		ing2.set_item(null, 0)
		ing2.icon.texture = unknown_icon
		ing2.visible = true
		plus2.visible = true
	else:
		ing2.visible = false
		plus2.visible = false

	# Ingredient 3
	if count >= 3:
		ing3.set_item(null, 0)
		ing3.icon.texture = unknown_icon
		ing3.visible = true
		plus3.visible = true
	else:
		ing3.visible = false
		plus3.visible = false

	# Result
	result.set_item(null, 0)
	result.icon.texture = unknown_icon
