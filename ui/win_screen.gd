extends Control

signal end_game


@onready var ui_click: AudioStreamPlayer = $UIClick


func _on_back_to_game_button_pressed() -> void:
	get_tree().paused = false
	self.hide()
	ui_click.play()


func _on_end_game_button_pressed() -> void:
	end_game.emit()
	ui_click.play()
