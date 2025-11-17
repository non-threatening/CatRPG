class_name ChaseDetect extends Area2D

@onready var enemy_state_machine: EnemyStateMachine = $"../EnemyStateMachine"
@onready var chase: PixquitoeStateChase = $"../EnemyStateMachine/Chase"


func _ready() -> void:
	body_entered.connect( _on_body_enter )


func _on_body_enter( _b : Node2D ) -> void:
	if _b is Enemy:
		enemy_state_machine.change_state( chase )
