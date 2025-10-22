extends Area2D

const Bubble = preload("res://Dialogue/SpeachBubbles/speech_bubble/speach_bubble.tscn")
const Terminal = preload("res://Dialogue/SpeachBubbles/terminal_bubble/terminal_bubble.tscn")

var speech_bubble : Node

@export_enum( "Speech",	"Terminal" ) var bubble: int = 0
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func action() -> void:
	if bubble == 0:
		speech_bubble = Bubble.instantiate()
	else:
		speech_bubble = Terminal.instantiate()
	get_tree().current_scene.add_child(speech_bubble)
	speech_bubble.start( dialogue_resource, dialogue_start )
