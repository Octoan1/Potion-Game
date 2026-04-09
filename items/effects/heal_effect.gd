extends PotionEffect
class_name HealEffect

@export var amount: int = 25

func apply(instigator: Node = null) -> void:
	var tree = Engine.get_main_loop() as SceneTree

	var hb = null
	if tree.current_scene and tree.current_scene.has_node("CanvasLayer/HealthBar"):
		hb = tree.current_scene.get_node("CanvasLayer/HealthBar")
	if hb:
		hb.value += amount
	else:
		var players = tree.get_nodes_in_group("Player")
		if players.size() > 0 and players[0].has_method("heal"):
			players[0].heal(amount)
