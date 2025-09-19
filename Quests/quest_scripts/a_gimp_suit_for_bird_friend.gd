class_name AGimpSuitForBirdFriend extends BaseQuestResource

const A_GIMP_SUIT = preload("res://Quests/quest_resources/a_gimp_suit_for_bird_friend.tres")

signal bird_friend_comes_with

var quest_item : ItemData = preload("res://Items/a_gimp_suit.tres")
var have_suit : bool = false
var suit_given : bool = false


func update(_args: Dictionary = {}) -> void:
	if not Shortcuts.get_quest_property( 102, "steps" )[0].completed:
		if Shortcuts.get_item_quantity( quest_item ) >= 1:
			A_GIMP_SUIT.complete_step( 0 )
			have_suit = true
			PlayerHud.queue_notification( "", "You've found the second hand Gimp Suit!")
#	The suit is given in dialog
	elif suit_given == true:
		PlayerManager.INVETORY_DATA.use_item( quest_item, 1 )
		Shortcuts.complete_quest( "a_gimp_suit_for_bird_friend" )
		
		## remove Bird Friend from scene from here
		bird_friend_comes_with.emit()
		
	updated.emit()
