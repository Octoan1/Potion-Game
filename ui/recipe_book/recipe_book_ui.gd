extends Control

@export var recipe_list: Array[Recipe]
@export var recipe_row_scene: PackedScene

@onready var list: VBoxContainer = $ScrollContainer/RecipeList


func _ready() -> void:
	load_recipes()


func load_recipes() -> void:
	for child: Node in list.get_children():
		child.queue_free()

	for recipe: Recipe in recipe_list:
		var row: RecipeRow = recipe_row_scene.instantiate() as RecipeRow
		list.add_child(row)

		var discovered: bool = GameState.is_recipe_discovered(recipe)
		row.setup(recipe, discovered)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("recipe_book"):
		load_recipes()
		self.visible = not self.visible
