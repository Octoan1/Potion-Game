extends Node2D

signal cauldron_activate
signal cauldron_deactivate

@onready var label: Label = $Label
@onready var color_rect: ColorRect = $ColorRect
var active: bool = false
var player_next_to: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		label.show()
		color_rect.show()
		player_next_to = true
		
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		label.hide()
		color_rect.hide()
		player_next_to = false
		
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_F and not active and player_next_to:
			print("used cauldron")
			cauldron_activate.emit()
			active = true
		elif event.is_pressed() and (event.keycode == KEY_F or event.keycode == KEY_ESCAPE) and active:
			cauldron_deactivate.emit()
			active = false
			
