class_name FriendAbilities extends Node

const BIRD = preload("res://Player/BirdFriend/bird_friend_flying.tscn")
const BOMB = preload( "res://interactables/bomb/bomb.tscn" )

var friends : Array[ String ] = [
	"", "", "", "", "" ## "NONE", BIRD", "GRAPPLE", "BOW", "BOMB"
	]

 # For NONE ability press duration
var _ability_press_time := 0.0
var _ability_pressing := false
var _ability_long_press_fired := false
const LONG_PRESS_THRESHOLD := 0.4

var selected_friend : int = 0
var player : Player
var bird_instance : BirdFriendFlying = null

@onready var state_machine: PlayerStateMachine = $"../StateMachine"
@onready var lift: State_Lift = $"../StateMachine/Lift"
@onready var idle: State_Idle = $"../StateMachine/Idle"
@onready var walk: State_Walk = $"../StateMachine/Walk"
@onready var bow: State_Bow = $"../StateMachine/Bow"
@onready var grapple: State_Grapple = $"../StateMachine/Grapple"


func _ready() -> void:
	player = PlayerManager.player
	setup_friends()
	set_friend_number( 0 )
	SaveManager.game_loaded.connect( _on_game_loaded )
	PlayerManager.INVETORY_DATA.friend_acquired.connect( _on_friend_acquired )
	NpcManager.bf_away.connect( _bird_leaving )
	
	
func setup_friends( select_index : int = 0 ) -> void:
	PauseMenu.update_friend_items( friends ) ## this in npcManager
	selected_friend = select_index - 1
	toggle_friend()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability"):
		_ability_press_time = 0.0
		_ability_pressing = true
		_ability_long_press_fired = false

	elif event.is_action_released("ability"):
		if _ability_pressing:
			if not _ability_long_press_fired:
				match selected_friend:
					0:
						none_ability( false ) # short press only if long wasn't fired
					1:
						bird_ability( false )
					2:
						grapple_ability()
					3:
						bow_ability()
					4:
						bomb_ability()
				_ability_pressing = false
				_ability_long_press_fired = false
				
	elif event.is_action_pressed("switch_ability"):
		toggle_friend()

	
func _process(delta: float) -> void:
	if _ability_pressing:
		_ability_press_time += delta
		## trigger the long press events
		if not _ability_long_press_fired and _ability_press_time >= LONG_PRESS_THRESHOLD:
			match selected_friend:
				0:
					none_ability(true)
				1:
					bird_ability( true )
			_ability_long_press_fired = true



func toggle_friend() -> void:
	if friends.count( "" ) == friends.size():
		return
	selected_friend = wrapi( selected_friend + 1, 0, 5 )
	while friends[ selected_friend ] == "":
		selected_friend = wrapi( selected_friend + 1, 0, 5 )
	
	await get_tree().process_frame
	if selected_friend == 1:
		player.show_bird_friend()
	else:
		player.hide_bird_friend()


func set_friend_number( a : int ) -> void:
	selected_friend = a


func none_ability(is_long_press := false) -> void:
	if is_long_press:
	   # TODO: Play long meow mewwwwwwwwwwww
		print("Long press: long meow")
	else:
		# TODO: Play short meow
		print("Short press: short meow")


func bird_ability( is_long_press : bool = false ) -> void:
	if bird_instance != null:
		return
	if is_long_press:
		prints("long bird")
	else:
		var _b = BIRD.instantiate() as BirdFriendFlying
		player.add_sibling( _b ) # make it a sibling of the player node so its at the same Z
		_b.global_position = player.global_position + Vector2( 0, -100.0 )
		var throw_direction = player.direction
		if throw_direction == Vector2.ZERO:
			throw_direction = player.cardinal_direction
		_b.throw( throw_direction )
		bird_instance = _b


func _bird_leaving() -> void:
	if bird_instance != null:
		return
	var _b = BIRD.instantiate() as BirdFriendFlying
	player.add_sibling( _b ) # make it a sibling of the player node so its at the same Z
	_b.global_position = player.global_position + Vector2( 0, -200 )
	var throw_direction = Vector2( pow(-1, randi() % 2), randf() * -0.666 )
	_b.leave( throw_direction )
	bird_instance = _b


func bow_ability() -> void:
	if player.arrow_count <= 0:
		return
	elif  state_machine.current_state == idle or state_machine.current_state == walk:
		player.arrow_count -= 1
		player.state_machine.change_state( bow )
		pass


func bomb_ability() -> void:
	if player.bomb_count <= 0:
		return
	elif  state_machine.current_state == idle or state_machine.current_state == walk:
		player.bomb_count -= 1

		lift.start_anim_late = true
		var bomb : Node2D = BOMB.instantiate()
		player.add_sibling( bomb )
		bomb.global_position = player.global_position
		
		PlayerManager.interact_handled = false
		var throwable : ThrowableBomb = bomb.find_child("Throwable")
		throwable.player_interact() ## func that's usually called when player picks something up, runs the pickup animation and all that
	

func grapple_ability() -> void:
	if  state_machine.current_state == idle or state_machine.current_state == walk:
		player.state_machine.change_state( grapple )


func _on_game_loaded() -> void:
	var new_friends = SaveManager.current_save.friends
	friends.clear()
	for i in new_friends:
		friends.append( i )
	setup_friends()


func _on_friend_acquired( _friend : FriendItemData ) -> void:
	#"NONE", "BIRD", "GRAPPLE", "BOW", "BOMB"
	match _friend.type:
		_friend.Type.NONE:
			friends[0] = "NONE"
		_friend.Type.BIRD:
			if StatsManager.achievements.have_bird_friend:
				friends[1] = "BIRD"
			else:
				await get_tree().create_timer( 1.2 ).timeout
				friends[1] = "BIRD"
		_friend.Type.GRAPPLE:
			friends[2] = "GRAPPLE"
		_friend.Type.ARROW:
			friends[3] = "ARROW"
		_friend.Type.BOMB:
			friends[4] = "BOMB"
	setup_friends( selected_friend )
