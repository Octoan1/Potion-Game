extends Label


func _on_player_update_display(amount: int) -> void:
	self.text = "Ingredients:\n thing: %d" % amount
