extends Node2D

@onready var text: Sprite2D = $Text

@export var cauldron_ui_scene: PackedScene
var cauldron_ui: Control
@onready var enter_exit_cauldron: AudioStreamPlayer = $EnterExitCauldron


func activate_cauldron() -> void:
	#print("hia")
	open_ui()
	#enter_exit_cauldron.play()

func open_ui() -> void:
	var ui: Control = cauldron_ui_scene.instantiate()
	get_tree().current_scene.get_node("CanvasLayer").add_child(ui)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		text.hide()


func _on_interactable_interacted() -> void:
	activate_cauldron()
