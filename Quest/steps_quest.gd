extends Quest
class_name StepsQuest

@export_category("Gimp Suit")
@export var needed_amount: int = 1
@export var quest_item : ItemData = preload("res://Items/a_gimp_suit.tres")

@export_category("Steps")
@export var gimpsuit_got: bool = false
@export var gimpsuit_given: bool = false

@export var step_list: Array[ QuestStep ]


var amount_in_inventory: int = 0


func update(_args: Dictionary = {}) -> void:
	amount_in_inventory = get_item_quantity( quest_item )
	if amount_in_inventory >= needed_amount:
		if step_list[0].meets_condition() == true:
			gimpsuit_got = true

	if step_list[0].completed == true:
		print( step_list[0].completed )
		print("gimp suit got")
		print("gimp give: ", gimpsuit_given)
		if gimpsuit_given == true:
			PlayerManager.INVETORY_DATA.use_item( quest_item, needed_amount )
			print(_args)
		
		#objective_completed = true
	updated.emit()




func complete(_args: Dictionary = {}) -> void:
	##TODO: Reward system for items, xp
	PlayerManager.INVETORY_DATA.use_item( quest_item, needed_amount )
	print("COMPLETED")
	pass

	
func get_item_quantity( item : ItemData) -> int:
	return PlayerManager.INVETORY_DATA.get_item_held_quantity( item )
	
#func give_gimpsuit() -> void:
	#print("give the gimp")
	#PlayerManager.INVETORY_DATA.use_item( quest_item, needed_amount )
