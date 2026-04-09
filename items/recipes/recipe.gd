extends Resource
class_name Recipe

@export var recipe_name: String
@export var recipe_id: String 

#@export_category("Ingredients Needed")
@export var ingredients: Array[Item]
@export var result: Item
