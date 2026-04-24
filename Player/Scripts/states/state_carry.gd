class_name State_Carry extends State

@export var move_speed : float = 300 # TODO: put a move_speed modifier option on the objects
@export var throw_audio : AudioStream

var walking : bool = false
var throwable : Throwable

@onready var idle: State_Idle = $"../Idle"
@onready var stun: State_Stun = $"../Stun"
@onready var held_item: Node2D = $"../../Sprite2D/HeldItem"


func enter() -> void:
	player.update_animation( "carry" )
	walking = false
	
	
func exit() -> void:
	if throwable:
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
		else:
			throwable.throw_direction = player.direction
			
		if state_machine.next_state == stun:
			throwable.throw_direction = throwable.throw_direction.rotated( PI )
			throwable.drop()
		else:
			AudioManager.play_effect( throw_audio )
			throwable.throw()
	
	
func process( _delta : float ) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.update_animation( "carry" )
	elif player.set_direction() or walking == false:
		player.update_animation( "carry_walk" )
		walking = true
	
	## Held Item
	match player.direction:
		Vector2.DOWN:
			held_item.position = Vector2( -1.0, -12.0 )
			held_item.rotation = 20.0
			held_item.show_behind_parent = false
		Vector2.UP:
			held_item.position = Vector2( 0.0, -20 )
			held_item.show_behind_parent = true
		Vector2.LEFT, Vector2.RIGHT:
			held_item.position = Vector2( 47, -18 )
			held_item.rotation = 0
			held_item.show_behind_parent = false
		_:
			pass
			
	player.velocity = player.direction * move_speed
	return null


func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed( "attack" ) or _event.is_action_pressed( "interact" ):
		return idle # triggers exit
	return null
