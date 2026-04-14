extends Control
class_name InventorySlot

signal item_clicked(item: Item)

@export var show_item_count: bool = true

@onready var icon: TextureRect = $ItemIcon
@onready var amount: Label = $ItemAmount
@onready var item: Item = null

@onready var show_name_timer: Timer = $ShowNameTimer
@onready var item_name: Label = $ItemName

var mouse_hovering: bool = false

func _ready() -> void:
	$ItemAmount.visible = show_item_count
	item_name.hide()

func set_item(new_item: Item, count: int) -> void:
	if new_item == null:
		icon.texture = null
		amount.text = "-1"
	else:
		self.item = new_item
		icon.texture = new_item.icon
		amount.text = str(count)
		
func clear_item() -> void:
	self.item = null
	icon.texture = load("res://assets/inventory_slot_test.png")
	amount.text = "-1"

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if item != null:
			item_clicked.emit(item)
			
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		#print("Tried to use item: ", item)
		if item != null and PlayerInventory.drinking:
			PlayerInventory.use_item(item)
			
				


func _on_mouse_entered() -> void:
	#if item:
	$Highlight.show()
	show_name_timer.start()
	
	mouse_hovering = true

func _on_mouse_exited() -> void:
	$Highlight.hide()
	item_name.hide()
	show_name_timer.stop()
	
	mouse_hovering = false


func _on_show_name_timer_timeout() -> void:
	# show item name
	item_name.show()
	if item:
		item_name.text = item.name
	else:
		item_name.text = "Empty"
