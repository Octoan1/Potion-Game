extends Control

@onready var icon: TextureRect = $ItemIcon
@onready var amount: Label = $ItemAmount

func set_item(item: Item, count: int) -> void:
	if item == null:
		icon.texture = null
		amount.text = "-1"
	else:
		icon.texture = item.icon
		amount.text = str(count)
