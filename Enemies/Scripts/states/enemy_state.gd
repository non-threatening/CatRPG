class_name EnemyState extends Node


## Stores a referance to the enmy that this state belongs to
var enemy : Enemy
var state_machine : EnemyStateMachine


## When we initiliaze this state
func init() -> void: 
	pass
	
	
## What happens when the player enters this state?
func enter() -> void:
	pass
	
	
## What happens when the player exits this state?
func exit() -> void:
	pass
		
		
## What happens during the _physics_process update in this State?
func process( _delta : float ) -> EnemyState:
	return null
	
	
## What happens during the _physics_process update in this state?
func physics( _delta : float ) -> EnemyState:
	return null
	
	
