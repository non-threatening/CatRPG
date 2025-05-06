class_name State_Carry extends State

@export var move_speed : float = 300 # TODO: put a move_speed modifier option on the objects
@export var throw_audio : AudioStream

var walking : bool = false
var throwable : Throwable

@onready var idle: State_Idle = $"../Idle"
@onready var stun: State_Stun = $"../Stun"


	
func init() -> void:
	pass


func enter() -> void:
	player.update_animation( "carry" )
	walking = false
	pass
	
	
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
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()
		pass
	pass
	
	
func process( _delta : float ) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.update_animation( "carry" )
	elif player.set_direction() or walking == false:
		player.update_animation( "carry_walk" )
		walking = true
		
	player.velocity = player.direction * move_speed
	return null
	
	
func physics( _delta : float ) -> State:
	return null
	
	
func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed( "attack" ) or _event.is_action_pressed( "interact" ):
		return idle # triggers exit
	return null






	
