extends Node


var stats = {
	friends_made = 0,
	enemies_defeated = 0,
	quests_completed = 0,
	pixquitoes_killed = 0,
	steam_achievements = 0,
	butts_sniffed = 0,
}

var achievements = {
	have_bird_friend = 0
}


func _ready() -> void:
	SaveManager.game_loaded.connect( _on_game_loaded )

func _on_game_loaded() -> void:
	stats = SaveManager.current_save.stats
	achievements = SaveManager.current_save.achievements


func enemy_stat_count( victim ) -> void:
	stats.enemies_defeated += 1
	match victim:
		"pixquitoe":
			stats.pixquitoes_killed += 1
		_:
			pass
