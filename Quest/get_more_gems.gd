class_name GetMoreGems extends QuestExtend


@export var needed_amount: int = 5
@export var quest_item : ItemData = preload("res://Items/gem.tres")

var amount_in_inventory: int


func start(_args: Dictionary = {}) -> void:
	pass


func update(_args: Dictionary = {}) -> void:
	amount_in_inventory = get_item_quantity( quest_item )
	print("app count: ", amount_in_inventory)
	if amount_in_inventory >= needed_amount:
		print( "need: ", quest_item, get_item_quantity( quest_item ) )
		#objective_completed = true
	#updated.emit()


func complete(_args: Dictionary = {}) -> void:
	##TODO: Reward system for items, xp
	PlayerManager.INVETORY_DATA.use_item( quest_item, needed_amount )
	print("COMPLETED")
	pass

	
func get_item_quantity( item : ItemData) -> int:
	return PlayerManager.INVETORY_DATA.get_item_held_quantity( item )
