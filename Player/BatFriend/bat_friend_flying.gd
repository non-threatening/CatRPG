class_name BatFriendFlying extends Node2D

enum State { THROW, RETURN, PERCHED, LEAVE, ARRIVE, ARRIVED }

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
const BAT_FRIEND = preload("uid://bymges7wbqeln")

var player : Player
var direction : Vector2
var flight_direction : Vector2
var speed : float = 0
var state
var frame_offest : int = 0
var anim_stop : bool = false
var _bf_position

var frame_rate : float = 0.08

var distance : int
var acceleration : float = 200.0
var max_speed : float = 450.0

var previous_position : Vector2 = Vector2.ZERO
var bf_radius : float = 0.0
var twirl_frequency : float = 2.5
var twirl_time : float = 0.0
var frame : int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var item_magnet: ItemMagnet = $ItemMagnet
@onready var line_2d: Line2D = $Sprite2D/Line2D

@onready var hurt_box: HurtBox = $Sprite2D/HurtBox
@onready var timer: Timer = $Timer

func _ready() -> void:
	hide()
	#set_distance()
	player = PlayerManager.player
	bf_radius = (sprite.texture.get_size().x / sprite.get_hframes()) * 0.5
	previous_position = global_position
	hurt_box.damage = 100
	timer.timeout.connect( flap_animation )
	

func _physics_process(delta: float) -> void:
	var drunk : int = int(pow(-1, randi() % 2))
	var rand = randf()
	match state:
		State.THROW:
			speed -= acceleration * delta
			if global_position.distance_to( player.global_position ) <= 200:
				position += direction * speed * delta
			else:
				if rand >= 0.666:
					position += direction * speed * delta
				else:
					position += ( ( Vector2( direction.x, drunk) ) * speed * delta )
			if speed <= 0:
				state = State.RETURN
				update_direction()
				
		State.RETURN:
			direction = global_position.direction_to( player.global_position + Vector2( 0, -100 ) )
			speed += acceleration * delta
			if rand >= 0.666:
				position += direction * speed * delta
			else:
				position += ( ( Vector2( direction.x, drunk) ) * speed * delta )
			if global_position.distance_to( player.global_position ) <= 110: 
				state = State.PERCHED
			#Stop flapping when close enough
			if global_position.distance_to( player.global_position ) <= 300: 
				position += direction * speed * delta
				anim_stop = true
				
		State.LEAVE:
			speed += 10 * delta
			var rando = randf()
			if rand >= 0.8:
				position += direction * speed * delta
			else:
				if rando <= 0.25:
					position += ( ( Vector2( direction.x, -1 ) ) * speed * delta )
				else:
					position += ( ( Vector2( direction.x, drunk) ) * speed * delta )
				
		State.ARRIVE:
			direction = global_position.direction_to( _bf_position )
			speed += acceleration * delta * 0.35
			if rand >= 0.666:
				position += direction * speed * delta
			else:
				position += ( ( Vector2( direction.x, drunk) ) * speed * delta )
			if global_position.distance_to( _bf_position ) <= 45: 
				state = State.ARRIVED
			if global_position.distance_to( _bf_position ) <= 200:
				position += direction * speed * delta
				anim_stop = true
				
		State.ARRIVED: # in tree
			arrived()
			
		State.PERCHED: # on cat
			perched()
		_:
			pass
	
	## Trail
	var rad : float = bf_radius * 0.125 ##=16
	var current_position = global_position + Vector2( 0, 15 )
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
	#audio.play()
	sprite.frame = 1 + frame_offest
	await get_tree().create_timer( frame_rate ).timeout
	sprite.frame = 0 + frame_offest
	await get_tree().create_timer( frame_rate ).timeout
	sprite.frame = 1 + frame_offest


func perched() -> void:
	player.show_bat_friend()
	sprite.self_modulate = Color( 1.0, 1.0, 1.0, 0.0 )
	EffectManager.landed( player.bat_friend_sprite.global_position )
	queue_free()


func arrived() -> void:
	NpcManager.bat_arrive.emit()
	sprite.self_modulate = Color( 1.0, 1.0, 1.0, 0.0 )
	EffectManager.landed( sprite.global_position + Vector2( 0, -150) )
	queue_free()


func back_to_cat( bf_position ) -> void:
	position = bf_position
	speed = 400
	visible = true
	update_direction()
	timer.start()
	state = State.RETURN


func leave( throw_direction : Vector2 ) -> void:
	direction = throw_direction
	speed = 450
	state = State.LEAVE
	update_direction()
	timer.start()
	visible = true
	toggle_item_magent()
	player.hide_bat_friend()
	await get_tree().create_timer( 6.66 ).timeout
	queue_free()
	
	
func throw( throw_direction : Vector2 ) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	update_direction()
	timer.start()
	visible = true
	player.hide_bat_friend()


func arrive( throw_direction : Vector2, bf_position ) -> void:
	direction = throw_direction
	speed = 450
	state = State.ARRIVE
	_bf_position = bf_position
	update_direction()
	timer.start()
	visible = true


func update_direction() -> void:
	# wait an extra frame to process Return state and change direction, from Throw
	await get_tree().create_timer( 0.05 ).timeout
	var direction_id : int = int( round( ( direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	flight_direction = DIR_4[ direction_id ]
	frame_offest = anim_direction()
	sprite.scale.x = sprite.scale.x * -1 if flight_direction == Vector2.LEFT else sprite.scale.x
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
