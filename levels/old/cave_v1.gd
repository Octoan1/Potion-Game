extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.got_upgrade.connect(_on_cave_upgrade)
	if GameState.cave_no_dark_upgrade:
		$CanvasLayer/Darkness.visible = false
		
func _on_cave_upgrade() -> void:
	$CanvasLayer/Darkness.visible = false
