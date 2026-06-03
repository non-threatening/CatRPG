class_name DustEffect extends Sprite2D

enum TYPE { LANDED, LAND, POOF }
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func start( type : TYPE ) -> void:
	var anim_name : String = "landed"
	match type:
		TYPE.LANDED:
			position.y -= 0
		TYPE.LAND:
			anim_name = "land"
			position.y += -14
			position.x += 10
		TYPE.POOF:
			anim_name = "poof"
			rotation_degrees = randi_range( 0, 3 ) * 90
	
	animation_player.play( anim_name )
	await animation_player.animation_finished
	queue_free()
