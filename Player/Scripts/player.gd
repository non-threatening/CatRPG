class_name Player extends CharacterBody2D

signal DirectionChanged( new_direction: Vector2 )
signal player_damaged( hurt_box : HurtBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6
var spoons : int = 3
var max_capacity : int = 6
var electro_shell : int = 0
var max_electro_shell : int = 2

var level : int = 1
var xp : int = 0

var attack : int = 1 :
	set( v ): 
		attack = v
		update_damage_values()
		
var defense : int = 1
var defense_bonus : int = 0

var arrow_count : int = 25 : set = _set_arrow_count
var bomb_count : int = 10 : set = _set_bomb_count


@onready var player_shape_vert: CollisionShape2D = $PlayerShapeVert
@onready var player_shape_hor: CollisionShape2D = $PlayerShapeHor

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box: HitBox = $Collisions/HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var audio: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D
@onready var lift: State_Lift = $StateMachine/Lift
@onready var held_item: Node2D = $Sprite2D/HeldItem
@onready var carry: State_Carry = $StateMachine/Carry
@onready var idle: State_Idle = $StateMachine/Idle
@onready var player_abilities: PlayerAbilities = $Abilities
@onready var state_electro_shell: StateElectroShell = $StateMachine/ElectroShell
@onready var state_freq: State_Freq = $StateMachine/freq

@onready var bird_friend_sprite: Sprite2D = $Sprite2D/BirdFriendSprite
@onready var actionable_finder: Area2D = $Direction/ActionableFinder


func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.damaged.connect( _take_damage )
	update_hp(99)
	update_electro_shell( 0 )
	update_spoons( 0 )
	update_damage_values()
	hide_bird_friend()
	PlayerManager.player_leveled_up.connect( _on_player_leveled_up )
	PlayerManager.INVETORY_DATA.equipment_changed.connect( _on_equipment_changed )
	PlayerManager.INVETORY_DATA.item_added_to_inventory.connect( _item_added )
	PlayerManager.interact_pressed.connect( _interact_pressed )
	pass

var wait_time: float = 1.0
var time: float = 0.0


# Quest trigger
func _item_added() -> void:
	var quests = QuestSystem.get_active_quests()
	for q: Quest in quests:
		if q.quest_name:
			Shortcuts.update_quest( q.quest_name )



func _process( _delta: float ) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()

	## Bird Friend Head
	if bird_friend_sprite.visible == true:
		time += _delta
		if time >= wait_time:
			time -= wait_time
			bird_friend_sprite.frame = randi() % 2
			wait_time = randi_range( 1, 5 )
	pass


func _physics_process( _delta: float ) -> void:
	move_and_slide()


##	Dialog actionable
func _interact_pressed() -> void:
	var actionables = actionable_finder.get_overlapping_areas()
	if actionables.size() > 0:
		actionables[0].action()
		prints("ation:", actionables )
		return


func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#PlayerManager.shake_camera()
	if Input.is_action_pressed("test"): 
		state_machine.change_state( state_electro_shell ) ## this should be in the respective states



func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true


func update_animation( state : String) -> void:
	animation_player.play( state + "_" + anim_direction() )
	pass


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func show_bird_friend() -> void:
	bird_friend_sprite.show()
func hide_bird_friend() -> void:
	bird_friend_sprite.hide()		


func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	if hp > 0:
		var dmg : int = hurt_box.damage
		if dmg > 0:
			dmg = clampi( dmg - defense - defense_bonus, 1, dmg )
		update_hp( -dmg )
		player_damaged.emit( hurt_box )
		
	pass
	
	
func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp( hp, max_hp )


func update_electro_shell( delta : int ) -> void:
	electro_shell = clampi( electro_shell + delta, 0, max_electro_shell)
	PlayerHud.update_shell( electro_shell, max_electro_shell )


func update_spoons( delta : int ) -> void:
	spoons = clampi( spoons + delta, 0, max_capacity )
	PlayerHud.update_spoons( spoons, max_capacity )


func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer( _duration ).timeout
	invulnerable = false
	hit_box.monitoring = true
	pass


func start_freq() -> void:
	state_machine.change_state( state_freq )

	
func pickup_item( _t : Throwable ) -> void:
	state_machine.change_state( lift )
	carry.throwable = _t
	pass
	
	
func revive_player() -> void:
	print("revived")
	update_hp( 99 )
	state_machine.change_state( idle )


func update_damage_values() -> void:
	var damage_value : int = attack + PlayerManager.INVETORY_DATA.get_attack_bonus()
	%AttackHurtBox.damage = damage_value
	%ChargeAttackHurtBox.damage = damage_value * 2


func _on_player_leveled_up() -> void:
	effect_animation_player.play( "level_up" )
	update_hp( max_hp )
	pass


func _on_equipment_changed() -> void:
	update_damage_values()
	defense_bonus = PlayerManager.INVETORY_DATA.get_defense_bonus()


func _set_arrow_count( value : int ) -> void:
	arrow_count = value
	PlayerHud.update_arrow_count( value )
	pass


func _set_bomb_count( value : int ) -> void:
	bomb_count = value
	PlayerHud.update_bomb_count( value )
	pass
	
	
