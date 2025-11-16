class_name QuestFlowerTest extends Area2D

const WALKING_QUEST = preload("res://Quests/quest_resources/walking_quest.tres")

@onready var area_2d: QuestFlowerTest = $"."


func _ready() -> void:
	area_2d.body_entered.connect( _on_body_entered )
	SaveManager.game_loaded.connect( _on_game_loaded )


func _on_game_loaded() -> void:
	var _completed : Array[bool]
	if QuestSystem.is_quest_active(WALKING_QUEST):
		for c in WALKING_QUEST.steps:
			_completed.append( c.completed )
	var total_sum = sum_bool_array( _completed )
	QuestVars.flower_count = total_sum

func sum_bool_array(bool_array: Array) -> int:
	var total = 0
	for value in bool_array:
		total += int(value)  # Convert boolean to integer
	return total


func _on_body_entered( _a ) -> void:
	if QuestSystem.is_quest_active(WALKING_QUEST) and QuestVars.flower_count <= 3:
		WALKING_QUEST.complete_step( QuestVars.flower_count )
		PlayerHud.queue_center_notificationUI( WALKING_QUEST.get_quest_step(
			QuestVars.flower_count ).title, "Passed!" 
			)
		area_2d.body_entered.disconnect( _on_body_entered )
		QuestVars.flower_count += 1
		Shortcuts.update_quest("walking_quest")
		
		if QuestVars.flower_count >= 4:
			Shortcuts.complete_quest("walking_quest")
