extends Control

signal end_game

@onready var ask_win: Control = $AskWin
@onready var full_win: Control = $FullWin


@onready var discover_label: Label = $FullWin/Panel/DiscoverLabel
@onready var time_label: Label = $FullWin/Panel/TimeLabel

@onready var ui_click: AudioStreamPlayer = $UIClick
@export var recipe_database: RecipeDatabase

var total_time: float = 0.0

func _process(delta: float) -> void:
	total_time += delta

func get_time_string() -> String:
	var total := int(total_time)
	@warning_ignore("integer_division")
	var minutes := total / 60
	var seconds := total % 60
	return "%02d:%02d" % [minutes, seconds]

func _on_back_to_game_button_pressed() -> void:
	get_tree().paused = false
	self.hide()
	ui_click.play()


func _on_end_game_button_pressed() -> void:
	end_game.emit()
	ui_click.play()
	
	ask_win.hide()
	full_win.show()
	
	var discovered := GameState.get_discovered_count()
	var total := GameState.get_total_recipes(recipe_database)

	discover_label.text = "Potions Discovered: %d/%d" % [discovered, total]
	
	time_label.text = "Time: " + get_time_string()
