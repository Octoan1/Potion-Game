extends PotionEffect
class_name LightEffect

@export var grant_upgrade: bool = true

func apply(instigator: Node = null) -> void:
	var tree = Engine.get_main_loop() as SceneTree
		
	# Enable global upgrade flag
	if Engine.has_singleton("GameState"):
		GameState.cave_no_dark_upgrade = true
		GameState.got_upgrade.emit()
	GameState.cave_no_dark_upgrade = true
	GameState.got_upgrade.emit()
	#else:
		# fallback if autoload not available as singleton variable
		
		#var gs = get_node_or_null("/root/GameState")
		#if gs:
			#gs.cave_no_dark_upgrade = true
			#gs.got_upgrade.emit()

	# If player is currently in the cave scene, hide the cave darkness ColorRect
	if tree.current_scene and tree.current_scene.name == "Cave":
		var cr = tree.current_scene.get_node_or_null("LevelManager/Cave/CanvasLayer/Darkness")
		if cr:
			cr.visible = false
