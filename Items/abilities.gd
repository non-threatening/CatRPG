class_name PlayerAbilities extends Node

const BOOMERANG = preload("res://Player/boomerang.tscn")
const BIRD = preload("res://Player/bird_friend.tscn")

var abilities : Array[ String ] = [
	"BOOMERANG", "BIRD", "BOW", "BOMB"
	]

var selected_ability = 0
var player : Player
var boomerang_instance : Boomerang = null
var bird_instance : BirdFriend = null



func _ready() -> void:
	player = PlayerManager.player
	PlayerHud.update_arrow_count( player.arrow_count )
	PlayerHud.update_bomb_count( player.bomb_count )
	
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability"):
		match selected_ability:
			0:
				boomerang_ability()
			1:
				bird_ability()
			2:
				print("Bow")
			3:
				print("Bomb")
				
	elif event.is_action_pressed("switch_ability"):
		toggle_ability()
	pass

func toggle_ability() -> void:
	selected_ability = wrapi( selected_ability + 1, 0, 4 )
	PlayerHud.update_ability_ui( selected_ability )
	pass
	
func bird_ability() -> void:
	if bird_instance != null: # Do we have a boomerang? Limits number of boomerangs to 1
		return
	
	var _b = BIRD.instantiate() as BirdFriend
	player.add_sibling( _b ) # make it a sibling of the player node so its at the same Z
	_b.global_position = player.global_position
	
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.cardinal_direction
		
	_b.throw( throw_direction )
	bird_instance = _b
	pass




func boomerang_ability() -> void:
	if boomerang_instance != null: # Do we have a boomerang? Limits number of boomerangs to 1
		return
	
	var _b = BOOMERANG.instantiate() as Boomerang
	player.add_sibling( _b ) # make it a sibling of the player node so its at the same Z
	_b.global_position = player.global_position
	
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.cardinal_direction
		
	_b.throw( throw_direction )
	boomerang_instance = _b
	pass
