class_name BeamNode extends Node2D

var distributed : bool = false

func _ready() -> void:
	count()

func count() -> void:
	for c in get_children():
		if c is Node2D:
			if distributed == false:
				c.beam_node()

			if randf() < 0.01:
				c.beam_node()
	distributed = true
	await get_tree().create_timer( 2.3 ).timeout
	count()
