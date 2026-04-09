extends HBoxContainer
class_name RecipeRow

@onready var ing1: TextureRect = $Ingredient1
@onready var ing2: TextureRect = $Ingredient2
@onready var ing3: TextureRect = $Ingredient3
@onready var result: TextureRect = $Result

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
		ing1.texture = ingredients[0].icon

	# Ingredient 2
	if ingredients.size() >= 2:
		ing2.texture = ingredients[1].icon
		ing2.visible = true
		plus2.visible = true
	else:
		ing2.visible = false
		plus2.visible = false

	# Ingredient 3
	if ingredients.size() >= 3:
		ing3.texture = ingredients[2].icon
		ing3.visible = true
		plus3.visible = true
	else:
		ing3.visible = false
		plus3.visible = false

	# Result
	result.texture = recipe.result.icon


func set_unknown(recipe: Recipe) -> void:
	var unknown_icon: Texture = load("res://assets/ui/unknown.png")

	var count: int = recipe.ingredients.size()

	# Ingredient 1
	ing1.texture = unknown_icon
	ing1.visible = true

	# Ingredient 2
	if count >= 2:
		ing2.texture = unknown_icon
		ing2.visible = true
		plus2.visible = true
	else:
		ing2.visible = false
		plus2.visible = false

	# Ingredient 3
	if count >= 3:
		ing3.texture = unknown_icon
		ing3.visible = true
		plus3.visible = true
	else:
		ing3.visible = false
		plus3.visible = false

	# Result
	result.texture = unknown_icon
