class_name BirdFriendFlying extends Node2D

enum State { INACTIVE, THROW, RETURN, PERCHED, LEAVE }

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var player : Player
var direction : Vector2
var flight_direction : Vector2
var speed : float = 0
var state
var frame_offest : int = 0
var anim_stop : bool = false

@export var frame_rate : float = 0.09
@export var acceleration : float = 666.0
@export var max_speed : float = 1000.0
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	hide()
	state = State.INACTIVE
	player = PlayerManager.player
	visible_on_screen_notifier_2d.screen_exited.connect( _exit_screen )


func _physics_process(delta: float) -> void:
	if state == State.THROW:
		speed -= acceleration * delta
		position += direction * speed * delta
		if speed <= 0:
			state = State.RETURN
			update_animation()
			## TODO: only update animation after state changes
	elif state == State.RETURN:
		direction = global_position.direction_to( player.global_position + Vector2( 0, -40 ) )
		speed += acceleration * delta
		position += direction * speed * delta
		if global_position.distance_to( player.global_position ) <= 45: 
			state = State.PERCHED
		#Stop flapping when close enough
		if global_position.distance_to( player.global_position ) <= 400: 
			anim_stop = true
	elif state == State.LEAVE:
		speed += 10 * delta
		position += direction * speed * delta
	elif state == State.PERCHED:
		perched()

func _exit_screen() -> void:
	if state == State.LEAVE:
		queue_free()
	

func flap_animation() -> void:
	sprite.frame = 2 + frame_offest
	await get_tree().create_timer( frame_rate ).timeout
	audio.play()
	sprite.frame = 1 + frame_offest
	await get_tree().create_timer( frame_rate ).timeout
	sprite.frame = 0 + frame_offest
	await get_tree().create_timer( frame_rate ).timeout
	sprite.frame = 1 + frame_offest
	await get_tree().create_timer( frame_rate * randf_range( 3.8, 8.5 ) ).timeout
	
	if anim_stop == false:
		flap_animation()
	pass


func perched() -> void:
	player.show_bird_friend()
	queue_free() 


func leave( throw_direction : Vector2 ) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.LEAVE
	update_animation()
	flap_animation()
	visible = true
	player.hide_bird_friend()
	
func throw( throw_direction : Vector2 ) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	update_animation()
	flap_animation()
	visible = true
	player.hide_bird_friend()


func update_animation() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame # wait an extra frame to process Return state and change direction
	var direction_id : int = int( round( ( direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	flight_direction = DIR_4[ direction_id ]
	frame_offest = anim_direction()
	sprite.scale.x = -1 if flight_direction == Vector2.LEFT else 1


func anim_direction() -> int:
	if flight_direction == Vector2.UP:
		return 3
	elif flight_direction == Vector2.DOWN:
		return 6
	else:
		return 0
