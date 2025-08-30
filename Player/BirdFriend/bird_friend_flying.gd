class_name BirdFriend extends Node2D

enum State { INACTIVE, THROW, RETURN, PERCHED }

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var player : Player
var direction : Vector2
var flight_direction : Vector2
var speed : float = 0
var state

@export var frame_rate : float = 0.09
@export var acceleration : float = 500.0
@export var max_speed : float = 666.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	hide()
	state = State.INACTIVE
	player = PlayerManager.player


func _physics_process(delta: float) -> void:
	if state == State.THROW:
		speed -= acceleration * delta
		position += direction * speed * delta
		if speed <= 0:
			state = State.RETURN
			update_animation()
			## TODO: only update animation after state changes
		pass
	elif state == State.RETURN:
		direction = global_position.direction_to( player.global_position + Vector2( 0, -40 ) )
		speed += acceleration * delta
		position += direction * speed * delta
		if global_position.distance_to( player.global_position ) <= 45: 
			state = State.PERCHED		
	elif state == State.PERCHED:
		perched()
		pass


func flap_animation() -> void:
	sprite.frame = 2
	await get_tree().create_timer( frame_rate ).timeout
	audio.play()
	sprite.frame = 1
	await get_tree().create_timer( frame_rate ).timeout
	sprite.frame = 0
	await get_tree().create_timer( frame_rate ).timeout
	sprite.frame = 1
	await get_tree().create_timer( frame_rate * randf_range( 3.8, 8.5 ) ).timeout
	flap_animation()
	pass


func perched() -> void:
	player.show_bird_friend()
	queue_free() 

	
func throw( throw_direction : Vector2 ) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	update_animation()
	flap_animation()
	visible = true
	player.hide_bird_friend()
	pass


func update_animation() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame # wait an extra frame to process Return state and change direction
	var direction_id : int = int( round( ( direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	flight_direction = DIR_4[ direction_id ]
	sprite.scale.x = -1 if flight_direction == Vector2.LEFT else 1


func anim_direction() -> String:
	if flight_direction == Vector2.DOWN:
		return "down"
	elif flight_direction == Vector2.UP:
		return "up"
	else:
		return "side"
