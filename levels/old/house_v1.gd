extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Friends.visible = GameState.friends_upgrade
	GameState.got_upgrade.connect(upgrade)
	
func upgrade() -> void:
	#print(GameState.friends_upgrade)
	$Friends.visible = GameState.friends_upgrade
