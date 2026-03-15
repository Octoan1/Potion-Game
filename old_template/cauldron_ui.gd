extends Control

signal craft_potion

@onready var label_2: Label = $Label2
var potions: Array[String] = [
	"love",
	"poison",
	"fart",
	"murder",
	"bird"
]

func _on_button_pressed() -> void:
	label_2.text = "you made %s potion!" % [potions[randi_range(0,4)]]
	craft_potion.emit()
