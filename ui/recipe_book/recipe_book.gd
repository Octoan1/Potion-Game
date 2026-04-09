extends Control

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("recipe_book") and GameState.recipe_book_unlock:
		#self.visible = not self.visible
