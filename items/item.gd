extends Resource
class_name Item

@export var name: String
@export var icon: Texture2D
@export var description: String
@export var type: ItemType

enum ItemType {
	INGREDIENT,
	POTION,
}
#@export var stackable: bool = true
#@export var max_stack: int = 99
