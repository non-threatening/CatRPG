extends Node

const SAVE_PATH = "user://save_files/"

signal game_loaded
signal game_saved

var master : float = 0.9
var music : float = 0.9
var talk_speed : float = 0.02

var current_save : Dictionary = {
	scene_path = "",
	time = {
		day = "",
		hour = "",
		minute = "",
		moon = "",
		#month = "",
		year = ""
	},
	player = {
		level = 1,
		xp = 0,
		hp = 1,
		max_hp = 1,
		electro_shell = 1,
		max_electro_shell = 1,
		attack = 1,
		defense = 1,
		pos_x = 0,
		pos_y = 0,
		arrow_count = 0,
		bomb_count = 0
	},
	items = [],
	persistance = [],
	quest_data = [],
	pool_state = [],
	abilities = [ "", "", "", "" ],
	options = {
		master = 0.5,
		music = 0.5,
		talk_speed = 0.01
	},
	stats = {}
}
var save_list : Dictionary = {"_1" : ""}



func _ready() -> void:
	if not DirAccess.dir_exists_absolute( SAVE_PATH ):
		DirAccess.make_dir_absolute( SAVE_PATH )
	var file := get_save_file( "list" )
	if file == null:
		var game_file := FileAccess.open( SAVE_PATH + "list_save.sav", FileAccess.WRITE )
		var save_list_json = JSON.stringify( save_list )
		game_file.store_line( save_list_json )
		file = get_save_file( "list" )	
	var json := JSON.new()
	json.parse( file.get_line() )
	var save_dict := json.get_data() as Dictionary
	save_list = save_dict
	if save_list.size() > 1:
		PlayerHud.active_save = save_list.active

	
func save_game( _number ) -> void:
	var formatted = TimeSystem.time_tick.get_formatted_time_padded(["hour", "minute"], ":")
	var day = TimeSystem.time_tick.get_time_unit("day")
	var thing : String = str( get_tree().get_current_scene().name.capitalize(), "[br]", "Day %d %s" % [day, formatted], "[br]", "Player Level: ", PlayerManager.player.level )
	save_list[ _number ] = thing
	save_list[ "active" ] = _number
	var game_file := FileAccess.open( SAVE_PATH + "list_save.sav", FileAccess.WRITE )
	var save_list_json = JSON.stringify( save_list )
	game_file.store_line( save_list_json )
	
	update_time()
	update_scene_path()
	update_player_data()
	update_item_data()
	update_quest_data()
	update_options_data()
	update_stats()
	
	var file := FileAccess.open( SAVE_PATH + _number + "_save.sav", FileAccess.WRITE )
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	
	game_saved.emit()
	PlayerHud.queue_notification( "GAME SAVED!", thing )



func get_save_file( _number ) -> FileAccess:
	return FileAccess.open( SAVE_PATH + _number + "_save.sav", FileAccess.READ )


func load_game( _number ) -> void:
	var file := get_save_file( _number )
	var json := JSON.new()
	json.parse( file.get_line() )
	var save_dict := json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position( Vector2( current_save.player.pos_x, current_save.player.pos_y ) )
	PlayerManager.set_health( current_save.player.hp, current_save.player.max_hp, current_save.electro_shell, current_save.max_electro_shell )

	var p : Player = PlayerManager.player
	p.level = current_save.player.level
	p.xp = current_save.player.xp
	p.attack = current_save.player.attack
	p.defense = current_save.player.defense
	p.arrow_count = current_save.player.arrow_count
	p.bomb_count = current_save.player.bomb_count
	
	var s : Dictionary = StatsManager.stats
	s.stats = current_save.stats
	
	# Options Menu
	master = current_save.options.master
	music = current_save.options.music
	talk_speed = current_save.options.talk_speed
	
	TimeSystem.time_tick.set_time_units({
		"day": current_save.time.day,
		"hour": current_save.time.hour,
		"minute": current_save.time.minute,
		"moon": current_save.time.moon,
		#"month": current_save.time.month,
		"year": current_save.time.year
	})
	
	## HUD clock
	var formatted = TimeSystem.time_tick.get_formatted_time_padded(["hour", "minute"], ":")
	var day = TimeSystem.time_tick.get_time_unit("day")
	PlayerHud.time_label.text = ("Day %d %s" % [day, formatted])
	
	
	PlayerManager.INVETORY_DATA.parse_save_data( current_save.items )
	
	QuestSystem.completed.reset()
	QuestSystem.active.reset()
	var quests: Array[Quest]
	for quest in DirAccess.get_files_at("res://Quests/quest_resources/"):
		var quest_path = "res://Quests/quest_resources/" + quest
		if ".tres.remap" in quest_path:
			quest_path = quest_path.trim_suffix('.remap')
		var quest_resource = load(quest_path)
		if quest_resource is Quest:
			quests.append(quest_resource)
		QuestSystem.restore_pool_state_from_dict(current_save["pool_state"], quests)
		QuestSystem.deserialize_quests(current_save["quest_data"])
	
	await LevelManager.level_loaded
	
	var load_active_quests = QuestSystem.get_active_quests()
	for q: Quest in load_active_quests:
		if q.quest_name:
			Shortcuts.update_quest( q.quest_name )
	game_loaded.emit()
	pass
	



func update_time() -> void:
	current_save.time.day =  TimeSystem.time_tick.get_time_unit("day")
	current_save.time.hour =  TimeSystem.time_tick.get_time_unit("hour")
	current_save.time.minute =  TimeSystem.time_tick.get_time_unit("minute")
	current_save.time.moon =  TimeSystem.time_tick.get_time_unit("moon")
	#current_save.time.month =  TimeSystem.time_tick.get_time_unit("month")
	current_save.time.year =  TimeSystem.time_tick.get_time_unit("year")


func update_options_data() -> void:
	current_save.options.master = master
	current_save.options.music = music
	current_save.options.talk_speed = talk_speed


func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.electro_shell = p.electro_shell
	current_save.max_electro_shell = p.max_electro_shell
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	current_save.player.level = p.level
	current_save.player.xp = p.xp
	current_save.player.attack = p.attack
	current_save.player.defense = p.defense
	current_save.player.arrow_count = p.arrow_count
	current_save.player.bomb_count = p.bomb_count
	current_save.abilities = p.player_abilities.abilities
	
	
func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level :
			p = c.scene_file_path
	current_save.scene_path = p


func update_item_data() -> void:
	current_save.items = PlayerManager.INVETORY_DATA.get_save_data()


func update_quest_data() -> void:
	var quest_data = QuestSystem.serialize_quests("Active")
	var pool_state = QuestSystem.pool_state_as_dict()
	current_save.quest_data = quest_data 
	current_save.pool_state = pool_state


func update_stats() -> void:
	current_save.stats = StatsManager.stats


func add_persistant_value( value : String ) -> void:
	if check_persistant_value( value ) == false:
		current_save.persistance.append( value )


func remove_persistant_value( value : String ) -> void:
	var p = current_save.persistance as Array
	p.erase( value )
	pass


func check_persistant_value( value : String ) -> bool: # if persistant value exists, it's open
	var p = current_save.persistance as Array
	return p.has( value ) ## .has is a bool if exisits in Array
