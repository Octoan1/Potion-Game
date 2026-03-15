extends Node2D

@onready var cauldron_ui: Control = $CanvasLayer/CauldronUI

func _on_cauldron_cauldron_activate() -> void:
	get_tree().paused = true
	cauldron_ui.show()

func _on_cauldron_cauldron_deactivate() -> void:
	get_tree().paused = false
	cauldron_ui.hide()
