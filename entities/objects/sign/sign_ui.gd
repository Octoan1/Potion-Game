extends Control

@onready var label: Label = $Panel/Label

func show_text(text: String) -> void:
	label.text = text
	visible = true
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()


func close() -> void:
	visible = false
	get_tree().paused = false
