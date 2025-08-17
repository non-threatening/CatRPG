extends Node

const SAVE_PATH = "user://"


signal game_loaded
signal game_saved


var current_save : Dictionary = {
	scene_path = "",
	player = {
		level = 1,
		xp = 0,
		hp = 1,
		max_hp = 1,
		attack = 1,
		defense = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistance = [],
	#quests = [ #{ title = "not found ", is_complete = false, completed_steps = ['']  } 
	#],
	quest_data = [],
	pool_state = []
}




func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	update_quest_data()
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE )
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()
	print("save_game")
	pass


func get_save_file() -> FileAccess:
	return FileAccess.open( SAVE_PATH + "save.sav", FileAccess.READ )


func load_game() -> void:
	var file := get_save_file()
	var json := JSON.new()
	json.parse( file.get_line() )
	var save_dict := json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position( Vector2( current_save.player.pos_x, current_save.player.pos_y ) )
	PlayerManager.set_health( current_save.player.hp, current_save.player.max_hp )

	var p : Player = PlayerManager.player
	p.level = current_save.player.level
	p.xp = current_save.player.xp
	p.attack = current_save.player.attack
	p.defense = current_save.player.defense
	
	PlayerManager.INVETORY_DATA.parse_save_data( current_save.items )
	
	var quests: Array[Quest]
	for quest in DirAccess.get_files_at("res://Quest/"):
		var quest_path = "res://Quest/" + quest
		var quest_resource = load(quest_path)
		if quest_resource is Quest:
			quests.append(quest_resource)
		QuestSystem.restore_pool_state_from_dict(current_save["pool_state"], quests)
		QuestSystem.deserialize_quests(current_save["quest_data"])
	
	
	
	
	await  LevelManager.level_loaded
	
	game_loaded.emit()
	
	pass


func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	current_save.player.level = p.level
	current_save.player.xp = p.xp
	current_save.player.attack = p.attack
	current_save.player.defense = p.defense
	
	
	
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
	

	
func add_persistant_value( value : String ) -> void:
	if check_persistant_value( value ) == false:
		current_save.persistance.append( value )
	pass
	
	
func remove_persistant_value( value : String ) -> void:
	var p = current_save.persistance as Array
	p.erase( value )
	pass
	
	

func check_persistant_value( value : String ) -> bool: # if persistant value exists, it's open
	var p = current_save.persistance as Array
	return p.has( value ) ## .has is a bool if exisits in Array











	
	
