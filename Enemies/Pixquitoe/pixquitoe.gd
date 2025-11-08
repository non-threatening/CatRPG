class_name Pixquitoe extends Enemy

@onready var hurt_b : HurtBox = $HurtBox
@onready var destroy: EnemyStateDestroy = $EnemyStateMachine/Destroy


func initialize() -> void:
	position.x = (randi_range( 1, 32 ) -16 ) * 128
	position.y = (randi_range( 1, 10 ) -5 ) * 128
	
	hurt_b.did_damage.connect( _kamikaze )
	
	await get_tree().create_timer( 30 ).timeout
	queue_free()


func _kamikaze() -> void:
	state_machine.change_state( destroy )


## Damages, or Destroys the enmey. Can access any vars in hurt_box.gd
func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	hp -= hurt_box.damage
	PlayerManager.shake_camera()
	EffectManager.damage_text( hurt_box.damage, global_position + Vector2( 0, -50 ) )
	if hp > 0:
		enemy_damaged.emit( hurt_box )
	else:
		enemy_destroyed.emit( hurt_box )
