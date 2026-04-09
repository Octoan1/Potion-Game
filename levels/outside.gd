extends Node2D

@onready var walls: TileMapLayer = $Walls
@onready var floor_tiles: TileMapLayer = $Floor

@export var debug: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.bridge_upgrade or debug:
		# remove water
		for i in range(4):
			for j in range(3):
				walls.set_cell(Vector2(-6+i,15+j), -1)
		# put in bridge
		for i in range(4):
			for j in range(6):
				floor_tiles.set_cell(Vector2(-6+i,14+j), 0, Vector2(0,1))
	
