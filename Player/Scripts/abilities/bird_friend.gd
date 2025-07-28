class_name BirdFriend extends Node2D

enum State { INACTIVE, THROW, RETURN, PERCHED }

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var player : Player
var direction : Vector2
var flight_direction : Vector2
var speed : float = 0
var state

@export var acceleration : float = 500.0
@export var max_speed : float = 666.0
@export var catch_audio : AudioStream
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	visible = false
	state = State.INACTIVE
	player = PlayerManager.player


func _physics_process(delta: float) -> void:
	if state == State.THROW:
		speed -= acceleration * delta
		position += direction * speed * delta
		if speed <= 0:
			state = State.RETURN
			update_animation()
			## TODO: only update animation when it changes
		pass
	elif state == State.RETURN:
		direction = global_position.direction_to( player.global_position + Vector2( 0, -40 ) )
		speed += acceleration * delta
		position += direction * speed * delta
		if global_position.distance_to( player.global_position ) <= 45: # Remove it when it's close to the player, it's caught
			PlayerManager.play_audio( catch_audio )
			state = State.PERCHED	
		pass
		
	elif state == State.PERCHED:
		perched()
		pass
	
	var speed_ratio = speed / max_speed
	audio.pitch_scale = speed_ratio * 0.85 + 1.0
	animation_player.speed_scale = 1 + ( speed_ratio * 0.25 )
	pass


func perched() -> void:
	print("perched")
	queue_free() 

	
func throw( throw_direction : Vector2 ) -> void:
	#print(throw_direction)
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	update_animation()
	PlayerManager.play_audio( catch_audio ) ## Plays in PlayerManager node
	visible = true
	pass


func update_animation() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame # wait an extra frame to process Return state and change direction
	var direction_id : int = int( round( ( direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	flight_direction = DIR_4[ direction_id ]
	sprite.scale.x = -1 if flight_direction == Vector2.LEFT else 1
	
	animation_player.play( "fly_" + anim_direction() )
	

func anim_direction() -> String:
	if flight_direction == Vector2.DOWN:
		return "down"
	elif flight_direction == Vector2.UP:
		return "up"
	else:
		return "side"
