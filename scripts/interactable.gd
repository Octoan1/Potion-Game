extends Node
class_name Interactable


signal interacted


func interact() -> void:
	interacted.emit()
	#print("Interactable Component: interacted with ", self.get_parent().name)
