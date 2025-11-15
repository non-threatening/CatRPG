class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://Items/item_pickup/ItemPickup.tscn")

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelrate_speed : float = 10.0

@export_category( "AI" )

@export_category("Item Drops")
@export var drops: Array[ DropData ]

var _damage_position : Vector2
var _direction : Vector2

## When we initiliaze this state
func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )
	pass
	
	
##
func enter() -> void:
	enemy.invulnerable = true
	_direction = enemy.global_position.direction_to( _damage_position )
	enemy.set_direction( _direction )
	enemy.velocity = _direction * -knockback_speed
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	disable_hurt_box()
	drop_items()
	PlayerManager.reward_xp( enemy.xp_reward )
	
	var victim : String = (
		get_parent().get_parent().get_script().get_global_name().to_lower()
	)
	StatsManager.enemy_stat_count( str( victim ) )
	pass
	

func exit() -> void:
	pass
		
		
## What happens during the process update in this State?
func process( _delta : float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelrate_speed * _delta
	return null
	
	
	
## What happens during the _physics_process update in this state?
func physics( _delta : float ) -> EnemyState:
	return null
	
	
func _on_enemy_destroyed( hurt_box : HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state( self )
	
	
	
func _on_animation_finished( _0 : String ) -> void:
	enemy.queue_free()


func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		set_deferred( "hurt_box.monitoring", false)
	
	


func drop_items() -> void:
	if drops.size() == 0:
		return
	
	for i in drops.size():
		if drops[ i ] == null or drops[ i ].item == null:
			continue
		var drop_count : int = drops[ i ].get_drop_count() #get rand number from drop_data.gd
		for j in drop_count:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup	
			drop.item_data = drops[ i ].item
			enemy.get_parent().call_deferred( "add_child", drop ) #Needs parent in scene to appear. deffer call because can't add an area2D to the scene i the same call as an area2D; it happens when the destroy state is called
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5,  ) ) * randf_range( 0.9, 1.8 ) ## in randians - 1.5rad = 85.9437deg
	pass
 	
	
	
	
	
		
	
