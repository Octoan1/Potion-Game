extends Control

@export var recipe_database: RecipeDatabase
@export var recipe_row_scene: PackedScene

@export var hotbar: Hotbar

@onready var list: VBoxContainer = $ScrollContainer/RecipeList

@onready var tooltip: ItemTooltip = preload("res://ui/item_tool_tip.tscn").instantiate()

func _ready() -> void:
	#add_child(tooltip)
	tooltip.hide()
	tooltip.add_to_group("tooltip")
	
	load_recipes()
	
	


func load_recipes() -> void:
	for child: Node in list.get_children():
		child.queue_free()

	for recipe: Recipe in recipe_database.recipe_list:
		var row: RecipeRow = recipe_row_scene.instantiate() as RecipeRow
		list.add_child(row)

		var discovered: bool = GameState.is_recipe_discovered(recipe)
		if GameState.has_discover_all_recipes:
			discovered = true
		row.setup(recipe, discovered)
		
		row.add_hotbar.connect(_on_add_hotbar)

func _on_add_hotbar(item: Item) -> void:
	# remove if exists
	for i in range(hotbar.slots.size()):
		if hotbar.slots[i] == item:
			hotbar.slots[i] = null
			hotbar.container.get_child(i).clear_item()
			return
	
	# add to first empty
	for i in range(hotbar.slots.size()):
		if hotbar.slots[i] == null:
			hotbar.set_slot(i, item)
			return
	
	print("hotbar full")
func get_first_empty_index() -> int:
	for i in range(hotbar.slots.size()):
		if hotbar.slots[i] == null:
			return i
	return hotbar.slots.size()

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("recipe_book"):
		#tooltip.show()
		move_to_front()
		#grab_focus()
		#grab_click_focus()
		load_recipes()
		self.visible = not self.visible
	if event.is_action_pressed("ui_cancel"):
		self.visible = false
