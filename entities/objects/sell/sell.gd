extends Node2D

@onready var text: Sprite2D = $Text

@export var sell_ui_scene: PackedScene

func activate_sell() -> void:
	open_ui()

func open_ui() -> void:
	var ui: Control = sell_ui_scene.instantiate()
	get_tree().current_scene.get_node("CanvasLayer").add_child(ui)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.hide()
