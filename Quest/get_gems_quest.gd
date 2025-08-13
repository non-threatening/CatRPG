class_name GetGemsQuest extends QuestExtend


@export var needed_amount: int = 5
@export var quest_item : ItemData = preload("res://Items/a_gimp_suit.tres")

var amount_in_inventory: int

#hit_box.damaged.connect( damage_taken )

func start(_args: Dictionary = {}) -> void:
	PlayerManager.INVETORY_DATA.equipment_changed.connect( _on_equipment_changed )

	pass

func _on_equipment_changed() -> void:
	print("CHANGGD")
	update()


func update(_args: Dictionary = {}) -> void:
	amount_in_inventory = get_item_quantity( quest_item )
	print("app getgems quest: ", amount_in_inventory)
	if amount_in_inventory >= needed_amount:
		print( "need gems: ", quest_item, get_item_quantity( quest_item ) )

		get_quest_step(0).meets_condition()
		#objective_completed = true
	updated.emit()




func complete(_args: Dictionary = {}) -> void:
	##TODO: Reward system for items, xp
	PlayerManager.INVETORY_DATA.use_item( quest_item, needed_amount )
	print("COMPLETED")
	pass

	
func get_item_quantity( item : ItemData) -> int:
	return PlayerManager.INVETORY_DATA.get_item_held_quantity( item )
