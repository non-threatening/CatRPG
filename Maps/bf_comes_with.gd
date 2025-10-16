class_name BFComesWith extends Node2D

@onready var bf_comes_with: BFComesWith = $"."
@onready var persistant_data_handler: PersistantDataHandler = $BFComesWithNPC/PersistantDataHandler

var is_hidden : bool = false

func _ready() -> void:
	QuestSystem.quest_completed.connect( _remove_bird_friend )
	persistant_data_handler.data_loaded.connect( _set_bird_visibility )
	_set_bird_visibility()


func _set_bird_visibility() -> void:
	is_hidden = persistant_data_handler.value
	if is_hidden == false:
		bf_comes_with.show()
	else:
		bf_comes_with.queue_free()
	
	
func _remove_bird_friend( _q : Quest ) -> void:
	var completed_quests = QuestSystem.get_completed_quests()
	for cq: Quest in completed_quests:
		if cq.quest_name == "a_gimp_suit_for_bird_friend":
			bf_comes_with.queue_free()
			persistant_data_handler.set_value() # saves the filename, if it exists it's true
