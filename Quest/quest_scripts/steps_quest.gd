extends Quest
class_name StepsQuest

@export_category("Gimp Suit")
@export var needed_amount: int = 1
@export var quest_item : ItemData = preload("res://Items/a_gimp_suit.tres")

@export_category("Steps")
@export var gimpsuit_got: bool = false
@export var gimpsuit_given: bool = false

@export var steps: Array[ QuestStep ]


var amount_in_inventory: int = 0


func update(_args: Dictionary = {}) -> void:
	
	## Step 1: When we have it
	amount_in_inventory = Shortcuts.get_item_quantity( quest_item )
	if amount_in_inventory >= needed_amount:
		if steps[0].meets_condition() == true:
			gimpsuit_got = true
	else:
		return
	
	## Step 2: After it's been given
	if steps[0].completed == true:
		if gimpsuit_given == true:	##in dialogue
			if steps[1].meets_condition() == true:
				PlayerManager.INVETORY_DATA.use_item( quest_item, needed_amount )
				Shortcuts.complete_quest( "steps_quest" )
	else:
		return
		
	updated.emit()


func complete(_args: Dictionary = {}) -> void:
	##TODO: Reward system for items, xp
	#PlayerManager.INVETORY_DATA.use_item( quest_item, needed_amount )
	print("COMPLETED in .gd")
	#completed.emit()
	pass
