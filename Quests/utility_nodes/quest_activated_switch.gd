@tool
@icon("res://Quests/utility_nodes/icons/quest_switch.png")
class_name QuestActivatedSwitch  extends QuestNode

## node functions in four different ways depending on which one we pick
enum CheckType { 
		HAS_QUEST, 
		QUEST_STEP_COMPLETE, 
		ON_CURRENT_STEP, 
		QUEST_COMPLETE 
		}

signal is_activated_changed( v : bool )

@export var check_type : CheckType = CheckType.HAS_QUEST : set = _set_check_type
@export var remove_when_activaed : bool = false
@export var free_on_remove : bool = false
@export var react_to_global_signal : bool = false # Update quest things in real time

var is_activated : bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if has_node("Sprite2D"):
		$Sprite2D.queue_free()
	if react_to_global_signal == true:
		QuestManager.quest_updated.connect( _on_quest_updated )
	check_is_activated()
	pass	
		
		
func check_is_activated() -> void:
	# Get the saved quest
	var _q : Dictionary = QuestManager.find_quest( linked_quest )
	
	if _q.title != "not found":
		
		match check_type:
			CheckType.HAS_QUEST:
				set_is_activated( true ) ## Show/activate if it has the quest
				
			CheckType.QUEST_COMPLETE: ## Show/activate when quest is complete
				var is_complete : bool = false
				if _q.is_complete is bool:
					is_complete = _q.is_complete
				set_is_activated( is_complete )
				
			CheckType.QUEST_STEP_COMPLETE:
				if quest_step > 0:
					if _q.completed_steps.has( get_step() ) == true:
						set_is_activated( true )
					else:
						set_is_activated( false )
				else:
					set_is_activated( false )
			
			CheckType.ON_CURRENT_STEP: ## Show/activate during current step
				var step : String = get_step()
				if step == "N/A":
					set_is_activated( false )
				else:
					if _q.completed_steps.has( step ):
						set_is_activated( false )
					else:
						var prev_step : String = get_previous_step()
						if prev_step == "N/A":
							set_is_activated( true )
						elif _q.completed_steps.has( prev_step.to_lower() ):
							set_is_activated( true )
						else:
							set_is_activated( false )
	else:
		set_is_activated( false )
	pass
	
	
func set_is_activated( _v :bool ) -> void:
	is_activated = _v
	is_activated_changed.emit( _v )
	if is_activated == true:
		if remove_when_activaed == true:
			hide_children()
		else: 
			show_children()
	else:
		if remove_when_activaed == true:
			show_children()
		else: 
			hide_children()
	pass

	
func show_children() -> void:
	for c in get_children():
			c.visible = true
			c.process_mode = Node.PROCESS_MODE_INHERIT
			

func hide_children() -> void:
	for c in get_children():
			c.set_deferred( "visible", false )
			c.set_deferred( "process_mode", Node.PROCESS_MODE_DISABLED )
			if free_on_remove:
				c.queue_free()


func _on_quest_updated( _q : Dictionary ) -> void:
	check_is_activated()
	pass


func _set_check_type( v : CheckType) -> void:
	check_type = v
	update_summary()
	pass
	

func update_summary() -> void:
	if linked_quest == null:
		settings_summary = "Select a quest"
		return
	settings_summary = "UPDATE QUEST:\nQuest: " + linked_quest.title + "\n"
	match check_type:
		CheckType.HAS_QUEST:
			settings_summary += "Checking if player has quest"
		CheckType.QUEST_STEP_COMPLETE:
			settings_summary += "Checking if player has completed step: " + get_step()
		CheckType.ON_CURRENT_STEP:
			settings_summary += "Check if player is on step: " + get_step()
		CheckType.QUEST_COMPLETE:
			settings_summary += "Checking if quest is complete"	
	pass
