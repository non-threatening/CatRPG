class_name ItemMagnet extends Area2D


var items : Array[ ItemPickup ] = []
var speeds : Array[ float ] = []


@export var magnet_strength : float = 3.0
@export var play_magnet_audio : bool = false

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	area_entered.connect( _on_area_entered )
	pass


func _process(delta: float) -> void:
	for i in range( items.size() - 1, -1, -1 ):
		var _item = items[i]
		if _item == null:
			items.remove_at( i ) # Take in range items out of the array, when got it becomes null
			speeds.remove_at( i )
		elif _item.global_position.distance_to( global_position ) > speeds[i]: # If it's close enough and the distance is greater than the speed (won't hit center of the magnet)
			speeds[i] += magnet_strength * delta
			_item.position += _item.global_position.direction_to( global_position ) * speeds[i]
		else: # if the item is close to the center of the magnet, set item position to magnet position. when it's in the center it can't escape
			_item.global_position = global_position # stick item to magnet
	pass

	

func _on_area_entered( _a : Area2D ) -> void:
	if _a.get_parent() is ItemPickup:
		var _new_item = _a.get_parent() as ItemPickup
		items.append( _new_item )
		speeds.append( magnet_strength )
		_new_item.set_physics_process( false ) ## eliminate _physics_process in item_pickup.gd so that the items can pass through walls
		if play_magnet_audio:
			audio.play(0)
		pass
	
	pass















	
	
	
