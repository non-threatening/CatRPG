class_name PlayerAbilities extends Node

const BIRD = preload("res://Player/BirdFriend/bird_friend_flying.tscn")
const BOMB = preload( "res://interactables/bomb/bomb.tscn" )

var abilities : Array[ String ] = [
	"", "", "", "", "" ## "BIRD", "GRAPPLE", "BOW", "BOMB"
	]
var selected_ability = 0
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
	PlayerHud.update_arrow_count( player.arrow_count )
	PlayerHud.update_bomb_count( player.bomb_count )
	setup_abilities()
	SaveManager.game_loaded.connect( _on_game_loaded )
	PlayerManager.INVETORY_DATA.ability_acquired.connect( _on_ability_acquired )
	NpcManager.bf_away.connect( _fly_bird_friend )
	
func _fly_bird_friend() -> void:
	bird_leaving()
	
func setup_abilities( select_index : int = 0 ) -> void:
	PauseMenu.update_ability_items( abilities )
	PlayerHud.update_ability_items( abilities )
	selected_ability = select_index - 1
	toggle_ability()
	pass
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability"):
		match selected_ability:
			0:
				none_ability()
			1:
				bird_ability()
			2:
				grapple_ability()
			3:
				bow_ability()
			4:
				bomb_ability()
				
	elif event.is_action_pressed("switch_ability"):
		toggle_ability()
	pass


func toggle_ability() -> void:
	if abilities.count( "" ) == abilities.size():
		return
	selected_ability = wrapi( selected_ability + 1, 0, 5 )
	while abilities[ selected_ability ] == "":
		selected_ability = wrapi( selected_ability + 1, 0, 5 )
	PlayerHud.update_ability_ui( selected_ability )
	
	await get_tree().process_frame
	if selected_ability == 1:
		player.show_bird_friend()
	else:
		player.hide_bird_friend()
	pass

func none_ability() -> void:
	pass


func bird_leaving() -> void:
	if bird_instance != null:
		return
	var _b = BIRD.instantiate() as BirdFriendFlying
	player.add_sibling( _b ) # make it a sibling of the player node so its at the same Z
	_b.global_position = player.global_position + Vector2( 0, -200 )
	var throw_direction = Vector2( pow(-1, randi() % 2), randf() * -0.666 )
	_b.leave( throw_direction )
	bird_instance = _b


func bird_ability() -> void:
	if bird_instance != null:
		return
	var _b = BIRD.instantiate() as BirdFriendFlying
	player.add_sibling( _b ) # make it a sibling of the player node so its at the same Z
	_b.global_position = player.global_position + Vector2( 0, -100.0 )
	##TODO: aiming function
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.cardinal_direction
		
	_b.throw( throw_direction )
	bird_instance = _b
	pass


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
	var new_abilities = SaveManager.current_save.abilities
	abilities.clear()
	for i in new_abilities:
		abilities.append( i )
	setup_abilities()


func _on_ability_acquired( _ability : AbilityItemData ) -> void:
	print( "Give Ability: ",  _ability.type )
	#"NONE", "BIRD", "GRAPPLE", "BOW", "BOMB"
	match _ability.type:
		_ability.Type.NONE:
			abilities[0] = "NONE"
		_ability.Type.BIRD:
			abilities[1] = "BIRD"
		_ability.Type.GRAPPLE:
			abilities[2] = "GRAPPLE"
		_ability.Type.ARROW:
			abilities[3] = "ARROW"
		_ability.Type.BOMB:
			abilities[4] = "BOMB"
	setup_abilities( selected_ability )
