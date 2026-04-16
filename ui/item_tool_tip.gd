extends Control
class_name ItemTooltip

@onready var name_label: Label = $Panel/VBoxContainer/NameLabel
@onready var desc_label: Label = $Panel/VBoxContainer/DescLabel

func _process(_delta: float) -> void:
	if visible:
		global_position = get_global_mouse_position() + Vector2(5, 5)

func set_item(item: Item) -> void:
	if item:
		name_label.text = item.name
		desc_label.text = item.description
	else:
		name_label.text = ""
		desc_label.text = ""
