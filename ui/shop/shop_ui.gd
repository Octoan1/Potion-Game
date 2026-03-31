extends Control

@onready var result_label: Label = $ResultLabel


func _ready() -> void:
	get_tree().paused = true
	PlayerInventory.drinking = false
	
	$/root/Main/CanvasLayer/PlayerInventoryUI.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func close() -> void:
	get_tree().paused = false
	queue_free()
	PlayerInventory.drinking = true
	


func _on_house_upgrade_pressed() -> void:
	if GameState.friends_upgrade:
		result_label.text = "Already bought"
	elif GameState.gold < 1:
		result_label.text = "Not enough gold"
	else:
		GameState.remove_gold(1)
		GameState.friends_upgrade = true
		GameState.got_upgrade.emit()
		result_label.text = "Bought house upgrade"
	


func _on_recipe_book_pressed() -> void:
	if GameState.recipe_book_unlock:
		result_label.text = "Already bought"
	elif GameState.gold < 2:
		result_label.text = "Not enough gold"
	else:
		GameState.remove_gold(2)
		GameState.recipe_book_unlock = true
		GameState.got_upgrade.emit()
		result_label.text = "Unlocked Recipe Book"


func _on_cauldron_craft_slot_pressed() -> void:
	if GameState.cauldron_3_slot:
		result_label.text = "Already bought"
	elif GameState.gold < 3:
		result_label.text = "Not enough gold"
	else:
		GameState.remove_gold(3)
		GameState.cauldron_3_slot = true
		GameState.got_upgrade.emit()
		result_label.text = "Unlocked 3rd Slot"
