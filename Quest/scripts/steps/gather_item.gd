extends QuestStep
class_name GatherItemsQuestStep

@export var quest_item : ItemData
@export var needed_amount: int = 1

var amount_in_inventory: int



func ready() -> void:
	meets_condition()
	update()
	#PlayerManager.INVETORY_DATA.changed.connect( meets_condition )
	#PlayerManager.INVETORY_DATA.equipment_changed.connect( meets_condition )
	PlayerManager.INVETORY_DATA.equipment_changed.connect( _on_equipment_changed )


func _on_equipment_changed() -> void:
	print("CHANGGD")
	meets_condition()

func meets_condition() -> bool:
	print("meets condition triggered")
	if amount_in_inventory >= needed_amount:
		print("meets!")
		completed = true
		return true
	print("no meats")
	return false


## this is the only thing
func update(_args: Dictionary = {}) -> void:
	amount_in_inventory = get_item_quantity( quest_item )
	print("app count: ", amount_in_inventory)
	if amount_in_inventory >= needed_amount:
		print( "need: ", quest_item, get_item_quantity( quest_item ) )
		completed = true
	updated.emit()


	
func get_item_quantity( item : ItemData) -> int:
	print("get quantity")
	return PlayerManager.INVETORY_DATA.get_item_held_quantity( item )
	
#@export var item: Item
#@export var quantity: int = 1
#var gathered: int


#func ready() -> void:
	#Globals.inventory.item_added.connect(_on_item_added)
	#Globals.inventory.item_removed.connect(_on_item_removed)
	#gathered = Globals.inventory.get_item_count(item)
	#meets_condition()

#func meets_condition() -> bool:
	#if gathered >= quantity:
		#completed = true
		#return true
	#return false

#func _on_item_added(gathered_item: Item, _index: int) -> void:
	#if gathered_item._id == item._id and not completed:
		#gathered += 1
		#updated.emit()
	#meets_condition()

#func _on_item_removed(gathered_item: Item, _index: int) -> void:
	#if gathered_item._id == item._id and not completed:
		#gathered -= 1
		#updated.emit()
	#meets_condition()
