class_name BeamNode extends Node2D

var distributed : bool = false
var beam_queue : Array

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func _ready() -> void:
	## Empty ainimation, just used for timing
	animation_player.animation_finished.connect( beam_animation_finished )
	count()


func count() -> void:
	for c in get_children():
		if c is Node2D:
			if distributed == false:
				add_beam_to_queue( c )
			else:
				if randf() < 0.01:
					c.beam_node()
	distributed = true
	await get_tree().create_timer( 2.3 ).timeout
	count()


func add_beam_to_queue( _c ) -> void:
	beam_queue.append( _c )
	if animation_player.is_playing():
		return
	drop_beam( _c )


func drop_beam( _c ) -> void:
	var _n = beam_queue.pop_front()
	if _n == null:
		return
	_n.beam_node()
	animation_player.play("wait")


func beam_animation_finished( _c ) -> void:
	drop_beam( _c )
