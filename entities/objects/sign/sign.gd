extends StaticBody2D

@export_multiline var message: String = "This is a sign."
@export var sign_ui_scene: PackedScene

var is_player_close := false

@onready var text_hint: Node2D = $Text # optional "Press E" sprite

func _ready() -> void:
	if text_hint:
		text_hint.hide()

func _process(_delta: float) -> void:
	if text_hint:
		text_hint.visible = is_player_close

func _on_collectable_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_close = true

func _on_collectable_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_close = false

func _on_interactable_interacted() -> void:
	if not is_player_close:
		return
	open_sign()

func open_sign() -> void:
	# prevent multiple signs stacking
	if get_tree().root.has_node("SignUI"):
		return
	
	var ui: Control = sign_ui_scene.instantiate()
	ui.name = "SignUI"
	
	get_tree().root.get_node("Main").get_node("CanvasLayer").add_child(ui)
	ui.show_text(message)
