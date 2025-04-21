class_name State extends Node

## Stores a ref to the player that this State belongs to
static var player: Player
static var state_machine: PlayerStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	
# When the state is initialiazed
func init() -> void:
	pass

## What happens when the player enters this State?
func enter() -> void:
	pass
	
	
## When the player exits
func exit() -> void:
	pass
	
	
## What happens during the _process update in the State?	
func process( _delta : float ) -> State:
	return null
	
	
## What happens during the _physics_process update in the State?	
func physics( _delta : float ) -> State:
	return null
	
	
## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	return null
