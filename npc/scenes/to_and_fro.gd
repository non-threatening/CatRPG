class_name ToAndFrom extends Node

const BIRD = preload("res://Player/BirdFriend/bird_friend_flying.tscn")

var bird_instance : BirdFriendFlying = null

@onready var bird_friend: BirdFriend = $".."


func bird_leaving_to_and_fro() -> void:
	if bird_instance != null:
		return
	var _b = BIRD.instantiate() as BirdFriendFlying
	bird_friend.add_sibling( _b ) # make it a sibling so its at the same Z
	_b.toggle_item_magent()
	_b.global_position = bird_friend.global_position + Vector2( 0, -10.0 )
	var throw_direction : Vector2
	throw_direction = Vector2( pow(-1, randi() % 2), randf() * -0.666 )
	_b.leave( throw_direction )
	bird_instance = _b


func bird_arriving() -> void:
	if bird_instance != null:
		return
	var _b = BIRD.instantiate() as BirdFriendFlying
	bird_friend.add_sibling( _b ) # make it a sibling so its at the same Z
	_b.toggle_item_magent()
	var bf_position = bird_friend.global_position
	var randy : float =  bf_position.y - ( randi() % 500 + 1000 )
	var dims : Array[ Vector2 ] = LevelManager.current_tilemap_bounds
	prints("dims", dims[1], dims[1][0], bf_position.y, randy )
	
	var l_or_r : int = randi() % 2
	match l_or_r:
		0:
			_b.position = Vector2( -150, randy )
		_:
			_b.position = Vector2( dims[1][0] + 150, randy )
	var direction = _b.global_position.direction_to( bf_position )
	_b.arrive( direction, bf_position )
	bird_instance = _b


func to_and_fro_back_to_cat() -> void:
	if bird_instance != null:
		return
	var _b = BIRD.instantiate() as BirdFriendFlying
	var bf_position = bird_friend.global_position
	bird_friend.add_sibling( _b ) # make it a sibling so its at the same Z
	_b.toggle_item_magent()	
	EffectManager.landed( bf_position )
	_b.back_to_cat( bf_position )
	bird_instance = _b
