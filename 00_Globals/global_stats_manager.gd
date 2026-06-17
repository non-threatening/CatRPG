extends Node


var achievements = {
	have_bird_friend = 0,
	five_forest_friends = 0
}

var npcs_stats = {
	bf_level = 1,
	bf_distance = 0
}

var stats = {
	friends_made = 0,
	quests_completed = 0,
	enemies_defeated = 0,
	pixquitoes_killed = 0,
	steam_achievements = 0,
	butts_sniffed = 0,
}



var knowledge = {
	has_knowledge = 0,
	tutorial_1 = 0,
	tutorials = {
		frequency_game_1 = 0
	}
	##use player knowledge state to control tings like what npc's say
	##	use checks in dialogs for different npc's
	##		if has_knowledge_of_comrade
	##				exists
	##				location
	##				times availible
	
	##	Whenever we need knowledge about something use this system so that npc's can always provide new info and not repeat the same info. No way to control who they talk to first. especially uncovering the main story. 
	
	
	##Sound game - sync the buton presses with the sounds of the failing machinery.. would be cool to reset the beats so that they sync up. Like, starts with the beats out of sync, and they sync up with the button presses. Once it's synced up and a sick jam, the mini game is won.
}


func _ready() -> void:
	SaveManager.game_loaded.connect( _on_game_loaded )


func _on_game_loaded() -> void:
	achievements = SaveManager.current_save.achievements
	stats = SaveManager.current_save.stats
	npcs_stats = SaveManager.current_save.npcs_stats
	#knowledge = SaveManager.current_save.knowledge


func enemy_stat_count( victim ) -> void:
	stats.enemies_defeated += 1
	match victim:
		"pixquitoe":
			stats.pixquitoes_killed += 1
		_:
			pass
