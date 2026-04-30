extends Control
class_name InventorySlot

signal item_clicked(item: Item)

@export var show_item_count: bool = true

@onready var icon: TextureRect = $ItemIcon
@onready var amount: Label = $ItemAmount
@onready var item: Item = null

# cauldron stuff
@onready var cauldron_icon: Texture = preload("res://assets/cauldron_slot.png")
@export var for_cauldron: bool = false
@onready var disabled_overlay: TextureRect = $DisabledOverlay # red X image
var disabled: bool = false

# hotbar stuff
@onready var empty_icon: Texture = preload("res://assets/empty.png")
@export var for_hotbar: bool = false
var in_hotbar: bool = false # only can drink in hotbar

# drink potion stuff
@onready var drink_cd_visual: TextureProgressBar = $PotionDrinkCooldownVisual
@onready var drink_cd_timer: Timer = $PotionDrinkCooldownTimer
var is_drink_on_cd: bool = false

#@onready var show_name_timer: Timer = $ShowNameTimer
#@onready var item_name: Label = $ItemName
var tooltip: ItemTooltip

var mouse_hovering: bool = false

@onready var ui_click: AudioStreamPlayer = $UIClick
@onready var use_potion: AudioStreamPlayer = $UsePotion
@onready var ui_error: AudioStreamPlayer = $UIError


func _ready() -> void:
	if for_cauldron:
		icon.texture = cauldron_icon
	$ItemAmount.visible = show_item_count
	#item_name.hide()
	tooltip = get_tree().get_first_node_in_group("tooltip")

func _process(_delta: float) -> void:
	if is_drink_on_cd:
		var _curr_time: float = drink_cd_timer.wait_time - drink_cd_timer.time_left
		var progress: float = (drink_cd_timer.time_left / drink_cd_timer.wait_time) * 100
		drink_cd_visual.value = progress

func set_item(new_item: Item, count: int) -> void:
	$ItemAmount.visible = show_item_count
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
	if for_cauldron:
		icon.texture = cauldron_icon
	if for_hotbar:
		icon.texture = empty_icon
	amount.text = "-1"

func _gui_input(event: InputEvent) -> void:
	if disabled:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if item != null:
			ui_click.play(0.23)
			item_clicked.emit(item)
			
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		#print("Tried to use item: ", item)
		if in_hotbar and item != null and PlayerInventory.drinking:
			if item.type == item.ItemType.POTION and is_drink_on_cd == false:
				drink_potion()
			else: 
				ui_error.play()
			#PlayerInventory.use_item(item)
			
func try_drink_potion() -> void:
	if item == null:
		return
	
	if item.type == item.ItemType.POTION and is_drink_on_cd == false:
		drink_potion()

func drink_potion() -> void:
	use_potion.play()
	is_drink_on_cd = true
	drink_cd_timer.start()
	drink_cd_visual.show()
	PlayerInventory.use_item(item)

func _on_potion_drink_cooldown_timer_timeout() -> void:
	print("timer")
	is_drink_on_cd = false
	drink_cd_visual.hide()

func _on_mouse_entered() -> void:
	#if item:
	$Highlight.show()
	#show_name_timer.start()
	if tooltip and item:
		tooltip.set_item(item)
		tooltip.show()
	
	mouse_hovering = true

func _on_mouse_exited() -> void:
	$Highlight.hide()
	#item_name.hide()
	#show_name_timer.stop()
	if tooltip:
		tooltip.hide()
	
	mouse_hovering = false


func _on_show_name_timer_timeout() -> void:
	pass
	# show item name
	#item_name.show()
	#if item:
		#item_name.text = item.name
	#else:
		#item_name.text = "Empty"
		
func set_disabled(value: bool) -> void:
	disabled = value
	disabled_overlay.visible = value
	
	# optional: dim icon
	if value:
		modulate = Color(1, 0.5, 0.5)
	else:
		modulate = Color.WHITE
