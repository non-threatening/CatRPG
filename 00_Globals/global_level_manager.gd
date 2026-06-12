extends Node

signal level_load_started
signal level_loaded
signal TileMapBoundsChanged( bounds : Array[ Vector2 ] )

var current_tilemap_bounds : Array[ Vector2 ]
var target_transition : String
var position_offset : Vector2
var previous_world_type : String = ""

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit() # Need to send level_loaded to turn on moitoring in level_transtion _ready

## Get the tilemap bounds to limit the tracking camera to the scene and
func change_tilemap_bounds( bounds : Array[ Vector2 ] ) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )


func change_worlds(
	 level_path : String, 
	_target_transition : String = "LevelTransition", 
	_position_offset : Vector2 = Vector2( 0, 0 )
) -> void:
	load_new_level( level_path, _target_transition, _position_offset)
	## Check for and remove friends
	PlayerManager.player.hide_bird_friend()



func load_new_level( level_path : String, _target_transition : String, _position_offset : Vector2 ) -> void:
	
	get_tree().paused = true
	TimeSystem.time_tick.pause()
	target_transition = _target_transition
	position_offset = _position_offset

	# record previous scene's world_type if present
	var cur_scene = get_tree().get_current_scene()
	previous_world_type = ""
	if cur_scene != null:
		var wt = null
		# try to safely get a world_type variable from the current scene
		wt = cur_scene.get("world_type")
		if wt != null:
			previous_world_type = str(wt)
	
	await SceneTransition.fade_out()
	level_load_started.emit()
	
	await get_tree().process_frame
	get_tree().change_scene_to_file( level_path )
	
	SceneTransition.fade_in()
	get_tree().paused = false
	TimeSystem.time_tick.resume()
	
	await get_tree().process_frame
	level_loaded.emit()
