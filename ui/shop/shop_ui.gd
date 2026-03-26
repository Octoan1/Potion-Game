extends Control


func _ready() -> void:
	get_tree().paused = true
	PlayerInventory.drinking = false
	
	$/root/Main/CanvasLayer/InventoryUI.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func close() -> void:
	get_tree().paused = false
	queue_free()
	PlayerInventory.drinking = true
	


func _on_house_upgrade_pressed() -> void:
	GameState.friends_upgrade = true
	GameState.got_upgrade.emit()
