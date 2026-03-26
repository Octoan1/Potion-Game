extends Label


func _ready() -> void:
	GameState.update_gold.connect(update_label)
	
func update_label(gold_amount: int) -> void:
	self.text = "Gold: %d" % gold_amount
	
