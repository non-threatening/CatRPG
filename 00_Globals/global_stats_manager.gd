extends Node

# steam
var achievements : Dictionary = {
	have_bird_friend = 0,
	have_bat_friend = 0,
	five_forest_friends = 0,
}

var npcs_stats : Dictionary = {
	bf_level = 1,
	bf_distance = 0,
}

var stats : Dictionary = {
	friends_made = 666,
	quests_completed = 0,
	enemies_defeated = 86,
	pixquitoes_killed = 0,
	steam_achievements = 0,
}

var knowledge : Dictionary = {
	has_knowledge = 0,
	tutorials = {
		sunset_tutorial = 0,
		frequency_game_1 = 0,
	}
}


func _ready() -> void:
	SaveManager.game_loaded.connect( _on_game_loaded )

func _on_game_loaded() -> void:
	achievements = SaveManager.current_save.achievements
	stats = SaveManager.current_save.stats
	npcs_stats = SaveManager.current_save.npcs_stats
	knowledge = SaveManager.current_save.knowledge


func enemy_stat_count( victim ) -> void:
	stats.enemies_defeated += 1
	match victim:
		"pixquitoe":
			stats.pixquitoes_killed += 1
		_:
			pass
