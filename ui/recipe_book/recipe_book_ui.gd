extends Control

@export var recipe_database: RecipeDatabase
@export var recipe_row_scene: PackedScene

@onready var list: VBoxContainer = $ScrollContainer/RecipeList


func _ready() -> void:
	load_recipes()


func load_recipes() -> void:
	for child: Node in list.get_children():
		child.queue_free()

	for recipe: Recipe in recipe_database.recipe_list:
		var row: RecipeRow = recipe_row_scene.instantiate() as RecipeRow
		list.add_child(row)

		var discovered: bool = GameState.is_recipe_discovered(recipe)
		row.setup(recipe, discovered)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("recipe_book"):
		move_to_front()
		load_recipes()
		self.visible = not self.visible
	if event.is_action_pressed("ui_cancel"):
		self.visible = false
