class_name QuestUI extends Control

const QUEST_SUMMARY : PackedScene = preload( "res://GUI/pause_menu/quest/quest_summary.tscn" )
const LIST_SUMMARY : PackedScene = preload( "res://GUI/pause_menu/quest/list_summary.tscn" )

@onready var quest_item_container: VBoxContainer = $ScrollContainer/QuestList/VBoxContainer
@onready var quest_list_container: VBoxContainer = $ScrollContainer2/QuestList/VBoxContainer


func _ready() -> void:
	clear_quest_details()	
	visibility_changed.connect( _on_visible_changed )
	QuestSystem.quest_accepted.connect( _update_gui )
	QuestSystem.quest_completed.connect( _update_gui )
	pass


func _update_gui( _q : Quest ) -> void:
	_on_visible_changed()


func _on_visible_changed() -> void:
	clear_quest_details()
	if visible == true:
		var quests = QuestSystem.get_active_quests()
		for q: Quest in quests:
			var new_q_item : QuestSummary = QUEST_SUMMARY.instantiate()
			quest_item_container.add_child( new_q_item )
			new_q_item.initialize( q.quest_objective, q.quest_description, false )
			new_q_item.focus_entered.connect( update_quest_details.bind( q.steps ) )
		
		var completed_quests = QuestSystem.get_completed_quests()
		for cq: Quest in completed_quests:
			var new_cq_item : QuestSummary = QUEST_SUMMARY.instantiate()
			quest_item_container.add_child( new_cq_item )
			new_cq_item.initialize( cq.quest_objective, cq.quest_description, true )
			new_cq_item.focus_entered.connect( update_quest_details.bind( cq.steps ))


func update_quest_details( thing) -> void:
	clear_list_details()
	for s in thing:
		var new_step : ListSummary = LIST_SUMMARY.instantiate()
		quest_list_container.add_child( new_step )
		new_step.initialize( s.title, s.completed )


func clear_quest_details() -> void:
	for c in quest_item_container.get_children():
		c.queue_free()
		for s in quest_list_container.get_children():
			if s is ListSummary:
				s.queue_free()
				

func clear_list_details() -> void:
	for c in quest_item_container.get_children():
		for s in quest_list_container.get_children():
			if s is ListSummary:
				s.queue_free()
	
