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
	_b.position = Vector2( pow(-1, randi() % 2) * 1250, -400 ) + bf_position
	var direction = _b.global_position.direction_to( bf_position )
	_b.arrive( direction, bf_position )
	bird_instance = _b
