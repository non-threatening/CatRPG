extends Area2D

const Bubble = preload("res://Dialogue/SpeachBubbles/speach_bubble.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	var bubble: Node = Bubble.instantiate()
	get_tree().current_scene.add_child(bubble)
	bubble.start( dialogue_resource, dialogue_start )
