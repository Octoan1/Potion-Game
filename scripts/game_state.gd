extends Node
#class_name Game

signal update_gold(curr_gold: int)
signal got_upgrade

var gold: int = 0

var friends_upgrade: bool = false

func give_gold(amount: int = 1) -> void:
	gold += amount
	update_gold.emit(gold)
	
func remove_gold(amount: int = 1) -> void:
	gold -= amount
	update_gold.emit(gold)
	
