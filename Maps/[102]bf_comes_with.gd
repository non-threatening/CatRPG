@icon( "res://npc/icons/npc.svg" )
class_name BFComesWith extends Node2D

const BIRD = preload("uid://ck03ewqnm1nrh")

var bird_instance : BirdFriendFlying = null
var is_hidden : bool = false

@onready var bird_friend_sprite: Sprite2D = $BFComesWithNPC/BirdFriendSprite
@onready var persistant_data_handler: PersistantDataHandler = $BFComesWithNPC/PersistantDataHandler


func _ready() -> void:
	QuestSystem.quest_completed.connect( _remove_bird_friend )
	persistant_data_handler.data_loaded.connect( _set_bird_visibility )
	_set_bird_visibility()


func _set_bird_visibility() -> void:
	is_hidden = persistant_data_handler.value
	if is_hidden == false:
		show()
	else:
		queue_free()
	
	
func _remove_bird_friend( _q : Quest ) -> void:
	var completed_quests = QuestSystem.get_completed_quests()
	for cq: Quest in completed_quests:
		if cq.quest_name == "[102]a_gimp_suit_for_bird_friend":
			persistant_data_handler.set_value()
			EffectManager.landed( bird_friend_sprite.global_position )
			queue_free()
			var _b = BIRD.instantiate() as BirdFriendFlying
			var bf_position = Vector2( 1452, 1413 )
			add_sibling( _b )
			_b.toggle_item_magent()
			_b.back_to_cat( bf_position )
