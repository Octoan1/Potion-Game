extends Node2D

signal light_boost_ended

@onready var light: PointLight2D = $PointLight2D
@onready var potion_duration: Timer = $PotionDuration

var base_scale: float
var curr_base_scale: float

var flicker_time: float = 0.0
var flicker_strength: float = 0.02
var flicker_speed: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_scale = light.texture_scale
	curr_base_scale = light.texture_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not light.visible:
		return

	flicker_time += delta * flicker_speed
	var smooth: float = sin(flicker_time) * flicker_strength
	
	light.texture_scale = curr_base_scale + smooth

func boost(new_texture_scale: float, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(light, "texture_scale", new_texture_scale, 2)
	await tween.finished
	
	curr_base_scale = new_texture_scale 
	
	potion_duration.wait_time = duration
	potion_duration.start()
	

func _on_potion_duration_timeout() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(light, "texture_scale", base_scale, 2)
	
	curr_base_scale = base_scale
	light_boost_ended.emit()
