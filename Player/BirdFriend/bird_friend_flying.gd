class_name BirdFriendFlying extends Node2D

enum State { INACTIVE, THROW, RETURN, PERCHED, LEAVE, ARRIVE, ARRIVED }

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var player : Player
var direction : Vector2
var flight_direction : Vector2
var speed : float = 0
var state
var frame_offest : int = 0
var anim_stop : bool = false
var _bf_position

var frame_rate : float = 0.09
var acceleration : float = 400.0
var max_speed : float = 666.0

var previous_position : Vector2 = Vector2.ZERO
var bf_radius : float = 0.0
var twirl_frequency : float = 2.5
var twirl_time : float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var item_magnet: ItemMagnet = $ItemMagnet
@onready var line_2d: Line2D = $Sprite2D/Line2D


func _ready() -> void:
	hide()
	state = State.INACTIVE
	player = PlayerManager.player
	bf_radius = (sprite.texture.get_size().x / sprite.get_hframes()) * 0.5
	previous_position = global_position


func _physics_process(delta: float) -> void:
	if state == State.THROW:
		speed -= acceleration * delta
		position += direction * speed * delta
		if speed <= 0:
			state = State.RETURN
			update_animation()
	elif state == State.RETURN:
		direction = global_position.direction_to( player.global_position + Vector2( 0, -100 ) )
		speed += acceleration * delta
		position += direction * speed * delta
		if global_position.distance_to( player.global_position ) <= 110: 
			state = State.PERCHED
		#Stop flapping when close enough
		if global_position.distance_to( player.global_position ) <= 500: 
			anim_stop = true
			
	elif state == State.LEAVE:
		speed += 10 * delta
		position += direction * speed * delta
		
	elif state == State.ARRIVE:
		direction = global_position.direction_to( _bf_position )
		speed += acceleration * delta * 0.35
		position += direction * speed * delta
		if global_position.distance_to( _bf_position ) <= 45: 
			state = State.ARRIVED
		if global_position.distance_to( _bf_position ) <= 200: 
			anim_stop = true
	elif state == State.ARRIVED: # in tree
		arrived()
	elif state == State.PERCHED: # on cat
		perched()
	
	## Trail
	var rad : float = bf_radius * 0.125 ##=16
	var current_position = global_position + Vector2( 0, -5 )
	var trail_dir = ( current_position - previous_position ).normalized()
	twirl_time += delta * twirl_frequency
	var twirl_offset = Vector2( cos( twirl_time ) * rad, sin( twirl_time ) * rad )
	line_2d.add_point( ( current_position - bf_radius * trail_dir ) + twirl_offset )
	if line_2d.points.size() > 32:
		line_2d.remove_point( 0 )
		
	previous_position = current_position


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


func perched() -> void:
	player.show_bird_friend()
	sprite.self_modulate = Color( 1.0, 1.0, 1.0, 0.0 )
	await get_tree().create_timer( 0.666 ).timeout
	queue_free()
	
func arrived() -> void:
	NpcManager.bf_arrive.emit()
	sprite.self_modulate = Color( 1.0, 1.0, 1.0, 0.0 )
	await get_tree().create_timer( 0.666 ).timeout
	queue_free()


func back_to_cat( bf_position ) -> void:
	position = bf_position
	speed = max_speed
	visible = true
	update_animation()
	flap_animation()
	state = State.RETURN


func leave( throw_direction : Vector2 ) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.LEAVE
	update_animation()
	flap_animation()
	visible = true
	toggle_item_magent()
	player.hide_bird_friend()
	
	##Queue free, when it leaves unseen
	await get_tree().create_timer( 6.66 ).timeout
	queue_free()
	
	
func throw( throw_direction : Vector2 ) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	update_animation()
	flap_animation()
	visible = true
	player.hide_bird_friend()


func arrive( throw_direction : Vector2, bf_position ) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.ARRIVE
	_bf_position = bf_position
	update_animation()
	flap_animation()
	visible = true


func update_animation() -> void:
	# wait an extra frame to process Return state and change direction, from Throw
	await get_tree().create_timer( 0.05 ).timeout
	var direction_id : int = int( round( ( direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	flight_direction = DIR_4[ direction_id ]
	frame_offest = anim_direction()
	sprite.scale.x = -1 if flight_direction == Vector2.LEFT else 1
	line_2d.clear_points()


func anim_direction() -> int:
	if flight_direction == Vector2.UP:
		return 3
	elif flight_direction == Vector2.DOWN:
		return 6
	else:
		return 0


func toggle_item_magent() -> void:
	item_magnet.monitoring = false
