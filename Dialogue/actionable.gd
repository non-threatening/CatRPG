extends Area2D

const Bubble = preload("res://Dialogue/SpeachBubbles/speech_bubble/speach_bubble.tscn")
const Terminal = preload("res://Dialogue/SpeachBubbles/terminal_bubble/terminal_bubble.tscn")
const LOKTIN_BUBBLE = preload("uid://bym1e6q2jq1c2")

var speech_bubble : Node

@export_enum( "Speech",	"Terminal", "Loktin" ) var bubble: int = 0
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func action() -> void:
	match bubble:
		0:
			speech_bubble = Bubble.instantiate()
		1:
			speech_bubble = Terminal.instantiate()
		2:
			speech_bubble = LOKTIN_BUBBLE.instantiate()
		_:
			speech_bubble = Bubble.instantiate()
		
	get_tree().current_scene.add_child(speech_bubble)
	speech_bubble.start( dialogue_resource, dialogue_start )
