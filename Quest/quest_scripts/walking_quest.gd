class_name QuestFlowerTest extends Area2D

const WALKING_QUEST = preload("res://Quest/walking_quest.tres")

@onready var area_2d: QuestFlowerTest = $"."


func _ready() -> void:
	area_2d.body_entered.connect( _on_body_entered )
	pass


func _on_body_entered( _a ) -> void:
	if QuestSystem.is_quest_active(WALKING_QUEST) and QuestVars.flower_count <= 3:
		WALKING_QUEST.complete_step( QuestVars.flower_count )
		PlayerHud.queue_stacked_notification( WALKING_QUEST.get_quest_step( QuestVars.flower_count ).title, "Passed!" )
		area_2d.body_entered.disconnect( _on_body_entered )
		QuestVars.flower_count += 1
		
		if QuestVars.flower_count >= 4:
			Shortcuts.complete_quest("walking_quest")

	Shortcuts.update_quest("walking_quest")
