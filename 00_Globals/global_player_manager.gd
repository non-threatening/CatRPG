extends Node

const PLAYER = preload("res://Player/player.tscn")
const INVETORY_DATA : InventoryData = preload("res://GUI/pause_menu/inventory/player_inventory.tres")

signal camera_shook( trauma : float )
@warning_ignore("unused_signal")
signal interact_pressed ##(x) Only want dectection button to work when idle or walking, and within the area of interactables, activated from interactables
signal player_leveled_up

var interact_handled : bool = true # currently interacting with something
var player : Player
var player_spawned : bool = false

var level_requirments = [ 0, 50, 100, 200, 400, 800, 1500, 3000, 6000, 12000, 25000 ]



func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true
	pass
	
	
func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )
	pass

func set_health( hp: int, max_hp: int) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp( 0 )


func reward_xp( _xp : int ) -> void:
	player.xp += _xp
	## do a chekc for level advancement
	if player.xp >= level_requirments[ player.level ]:
		player.level += 1
		player.attack += 1
		player.defense += 1
		player_leveled_up.emit()
	pass


func set_player_position( _new_pos : Vector2 ) -> void:
	player.global_position = _new_pos
	pass
	
	
	
func set_as_parent( _p : Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )
	pass	
		

## Unparent the player from whatever node it's in
func unparent_player( _p : Node2D ) -> void:
	_p.remove_child( player )
	pass
	
	
	
func play_audio( _audio : AudioStream ) -> void:
	player.audio.stream = _audio
	player.audio.play()
	

## will emit this signal if in state that allows interactio
func interact() -> void:
	interact_handled = false
	interact_pressed.emit() 
	
	
func shake_camera( trauma : float = 1 ) -> void:
	camera_shook.emit( clampi( trauma, 0, 3) )
