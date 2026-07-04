#@tool
@icon( "res://npc/icons/npc.svg" )
class_name NPC extends CharacterBody2D

#signal do_behavior_enabled

#var state : String = "idle"
#var direction : Vector2 = Vector2.DOWN
#var direction_name : String = "down"
#var do_behavior : bool = true

@export var npc_resource : NPCResource : set = _set_npc_resourse ## npc .tres file

#@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var actual_size : Vector2 = Vector2.ZERO


func _ready() -> void:
	setup_npc()


func _physics_process( _delta: float ) -> void:
	move_and_slide()


func setup_npc() -> void:
	if npc_resource:
		prints("npc resource", npc_resource.friend_type )
		if sprite and sprite.texture:
			var image_w : float = sprite.texture.get_width()
			var image_h : float = sprite.texture.get_height()
			prints( "size:", image_w, image_h )
			actual_size = Vector2( image_w / sprite.hframes, image_h / sprite.vframes )
			prints( "actual", actual_size )
		
		


func _set_npc_resourse( _npc : NPCResource ) -> void:
	npc_resource = _npc
	setup_npc()

#func _on_player_interacted() -> void:
	#update_direction( PlayerManager.player.global_position )
	#state = "idle"
	#velocity = Vector2.ZERO
	#update_animation()
	#do_behavior = false
	#prints("on player interacted")


#func _on_interaction_finished() -> void:
	#state = "idle"
	#update_animation()
	#do_behavior = true
	#do_behavior_enabled.emit()
	#prints("on player interaction")


#func update_animation() -> void:
	#animation.play( state + "_" + direction_name )
	#prints("update ani:", state, direction_name )


## use for animation... in extended
#func update_direction( target_position : Vector2 ) -> void:
	#prints("update direction:", target_position)
	#direction = global_position.direction_to( target_position )
	#update_direction_name()
	#if direction_name == "side" and direction.x < 0:
		#sprite.flip_h = true
	#else:
		#sprite.flip_h = false
	
	
#func update_direction_name() -> void:
	#prints("up dir name")
	#var threshold : float = 0.45
	#if direction.y < -threshold:
		#direction_name = "up"
	#elif direction.y > threshold:
		#direction_name = "down"
	#elif direction.x > threshold || direction.x < -threshold:
		#direction_name = "side"
	
