class_name Level extends Node2D

@export var music : AudioStream
@export var ambients : Array[ AudioStream ]
@export var ambients_night : Array[ AudioStream ]
@export var track_amount : int = 0
@export var ambient_track_interval : int = 2
@export_range(0, 23, 1) var night_start_hour : int = 18
@export_range(0, 23, 1) var night_end_hour : int = 6

var pending_ambient_queue : Array = []
var active_ambient_players : Array = []
var _ambient_tick_connected : bool = false

func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level )
	AudioManager.play_music( music )
	_init_ambient_track_scheduler()

func _init_ambient_track_scheduler() -> void:
	if _get_time_based_ambients().size() == 0 or track_amount <= 0:
		return
	_reload_ambient_queue()

	# Decide behavior based on previous world's type
	var prev_world : String = ""
	if LevelManager and LevelManager.previous_world_type:
		prev_world = LevelManager.previous_world_type

	var my_world : String = ""
	var wt = null
	wt = self.get("world_type")
	if wt != null:
		my_world = str(wt)

	if prev_world != "" and prev_world != my_world:
		await AudioManager.remove_all_ambients()
		active_ambient_players.clear()
		add_ambient_track()
	else:
		# same world type: use current ambient players as the active replacement pool
		if AudioManager.ambient_players.size() > 0:
			active_ambient_players = AudioManager.ambient_players.duplicate()
		# if no existing ambients, start them immediately
		elif AudioManager.ambient_players.size() == 0:
			for _t in track_amount:
				add_ambient_track()


	# connect to minute ticks to add/rotate tracks over time
	if TimeSystem.time_tick and not _ambient_tick_connected:
		TimeSystem.time_tick.time_unit_changed.connect(_on_level_time_unit_changed)
		_ambient_tick_connected = true

func _reload_ambient_queue() -> void:
	pending_ambient_queue.clear()
	for ambient in _get_time_based_ambients():
		pending_ambient_queue.append( ambient )
	pending_ambient_queue.shuffle()

func _get_time_based_ambients() -> Array:
	var current_ambients : Array = _get_day_ambients()
	if _is_night_time():
		if ambients_night.size() > 0:
			current_ambients = ambients_night
		else:
			current_ambients = ambients
	var _time_name : String = "day"
	if _is_night_time():
		_time_name = "night"
	return current_ambients

func _get_day_ambients() -> Array:
	return ambients

func _is_night_time() -> bool:
	var hour : int = 0
	if TimeSystem.time_tick:
		hour = TimeSystem.time_tick.get_time_unit("hour")
	elif TimeSystem.has_method("get_time_unit"):
		hour = TimeSystem.get_time_unit("hour")
	elif typeof(TimeSystem.hour) == TYPE_INT:
		hour = TimeSystem.hour
	if night_start_hour <= night_end_hour:
		return hour >= night_start_hour and hour < night_end_hour
	return hour >= night_start_hour or hour < night_end_hour

func _next_ambient() -> AudioStream:
	while pending_ambient_queue.size() > 0:
		var candidate : AudioStream = pending_ambient_queue.pop_back()
		if not _is_ambient_playing(candidate):
			return candidate
	# no unique candidate remains; refill and try one more time
	_reload_ambient_queue()
	while pending_ambient_queue.size() > 0:
		var candidate : AudioStream = pending_ambient_queue.pop_back()
		if not _is_ambient_playing(candidate):
			return candidate
	return null

func _is_ambient_playing(_audio : AudioStream) -> bool:
	for player in AudioManager.ambient_players:
		if player.playing and player.stream == _audio:
			return true
	return false

func add_ambient_track() -> void:
	if _get_time_based_ambients().size() == 0 or track_amount <= 0:
		return
	if active_ambient_players.size() >= track_amount:
		var oldest = active_ambient_players.pop_front()
		AudioManager.remove_ambient( oldest )
	var next_ambient = _next_ambient()
	if next_ambient == null:
		return
	var player = AudioManager.add_ambient( next_ambient )
	if player:
		active_ambient_players.append( player )

func _on_level_time_unit_changed(unit_name: String, new_value: int, old_value: int) -> void:
	if unit_name == "hour" and new_value % ambient_track_interval == 0:
		add_ambient_track()

func _exit_tree() -> void:
	if _ambient_tick_connected and TimeSystem.time_tick:
		TimeSystem.time_tick.time_unit_changed.disconnect(_on_level_time_unit_changed)
		_ambient_tick_connected = false

func _free_level() -> void:
	PlayerManager.unparent_player( self ) #unparent Player so it's not part of the level when it gets removed!
	queue_free()
