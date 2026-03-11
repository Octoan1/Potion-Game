extends Node2D

signal harvest

@onready var label: Label = $Label
@onready var color_rect: ColorRect = $ColorRect
var can_harvest: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		label.show()
		color_rect.show()
		can_harvest = true
		
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		label.hide()
		color_rect.hide()
		can_harvest = false
		
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_F and can_harvest:
			print("harvested: ", self.name)
			harvest.emit()
