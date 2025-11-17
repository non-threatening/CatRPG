class_name AGimpSuitForBirdFriend extends BaseQuestResource

var quest_item : ItemData = preload("res://Items/a_gimp_suit.tres")
var have_suit : bool = false
var suit_given : bool = false
	

func update(_args: Dictionary = {}) -> void:
	## When loading from save and have a gimpsuit
	if Shortcuts.get_quest_property( 102, "steps" )[0].completed and suit_given == false:
		have_suit = true

	
	
	if not Shortcuts.get_quest_property( 102, "steps" )[0].completed:
		if Shortcuts.get_item_quantity( quest_item ) >= 1:
			complete_step( 0 )
			have_suit = true
			PlayerHud.queue_center_notificationUI( "Quest step complete!", "Bring the second hand gimp suit back to Bird Friend")
##	The suit is given in dialog
	elif suit_given == true:
		PlayerManager.INVETORY_DATA.use_item( quest_item, 1 )
		Shortcuts.complete_quest( "[102]a_gimp_suit_for_bird_friend" )
		StatsManager.stats.friends_made += 1
		
	updated.emit()
