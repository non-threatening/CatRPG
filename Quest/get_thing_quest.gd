class_name GetThingQuest extends QuestExtend

@export var needed_apple: int = 5


var apple_count: int
var quest_item : ItemData = preload("res://Items/apple.tres")


func start(_args: Dictionary = {}) -> void:
	pass


func update(_args: Dictionary = {}) -> void:
	apple_count = get_item_quantity( quest_item )
	print("app count: ", apple_count)
	if apple_count >= needed_apple:
		print( "need: ", quest_item, get_item_quantity( quest_item ) )
		#objective_completed = true
	#updated.emit()


func complete(_args: Dictionary = {}) -> void:
	##TODO: Reward system for items, xp
	PlayerManager.INVETORY_DATA.use_item( quest_item, needed_apple )
	print("COMPLETED")
	pass

	
func get_item_quantity( item : ItemData) -> int:
	return PlayerManager.INVETORY_DATA.get_item_held_quantity( item )
