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
			new_q_item.initialize( q.quest_objective, q.quest_description )
			
			new_q_item.focus_entered.connect( update_quest_details.bind( q.step_list ) )
		
		
		var completed_quests = QuestSystem.get_completed_quests()
		print("comp ",completed_quests)
		for cq: Quest in completed_quests:
			print("cq ", cq)
			var new_cq_item : QuestSummary = QUEST_SUMMARY.instantiate()
			quest_item_container.add_child( new_cq_item )
			new_cq_item.initialize( cq.quest_objective, cq.quest_description )



func update_quest_details( thing ) -> void:
	for s in thing:
		var new_step : ListSummary = LIST_SUMMARY.instantiate()
		quest_list_container.add_child( new_step )
		new_step.initialize( s.title, s.completed )



func clear_quest_details() -> void:
	for c in quest_item_container.get_children():
		if c is QuestSummary:
			c.queue_free()
		for s in quest_list_container.get_children():
			if s is ListSummary:
				s.queue_free()
	
	
	
	
#func _on_visible_changed() -> void:
	#
	#for i in quest_item_container.get_children():
		#i.queue_free()
	#
	#clear_quest_details()
	#
	#if visible == true:
		##var names := []
		##rich_text_label.text = "Current quests:\n[color=red]{quests}[/color]".format({"quests": "\n".join(names)})
		#
		#QuestManager.sort_quests()
		#for q in QuestManager.current_quests:
			#var quest_data : Quest = QuestManager.find_quest_by_title( q.title )
			#if quest_data == null:
				#continue
			#var new_q_item : QuestItem = QUEST_ITEM.instantiate()
			#quest_item_container.add_child( new_q_item )
			#new_q_item.initialize( quest_data, q )
			#new_q_item.focus_entered.connect( update_quest_details.bind( new_q_item.quest ) )
	#
	#pass

#
#func update_quest_details( q : Quest ) -> void:
	### clear quest details
	#clear_quest_details()
	#
	#title_label.text = q.title
	#description_label.text = q.description
	#
	#var quest_save = QuestManager.find_quest( q )
	#
	#for step in q.steps:
		#var new_step : QuestStepItem = QUEST_STEP_ITEM.instantiate()
		#var step_is_complete : bool = false
		#if quest_save.title != "not found":
			#step_is_complete = quest_save.completed_steps.has( step.to_lower() )
		#details_container.add_child( new_step )
		#new_step.initialize( step, step_is_complete )
	#
	#pass
	#
