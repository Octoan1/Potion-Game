extends PotionEffect
class_name SpeedEffect

@export var multiplier: float = 3.0
@export var duration: float = 5.0

func apply(instigator: Node = null) -> void:
	var tree = Engine.get_main_loop() as SceneTree
	
	var players = tree.get_nodes_in_group("Player")
	if players.size() == 0:
		return
	var player = players[0]
	if not player:
		return
	var original_max = 1.0
	var original_friction = 1.0
	#if player.has_variable("max_speed"):
	original_max = player.max_speed
	player.max_speed *= multiplier
	#if player.has_variable("friction"):
	original_friction = player.friction
	player.friction *= multiplier

	await tree.create_timer(duration).timeout

	if player and player.is_inside_tree():
		#if player.has_variable("max_speed"):
		player.max_speed = original_max
		#if player.has_variable("friction"):
		player.friction = original_friction
