extends Node


var stats = {
	friends_made = 0,
	enemies_defeated = 0,
	pixquitoes_killed = 0,
	
	main_quests_completed = 0,
}


func _ready() -> void:
	SaveManager.game_loaded.connect( _on_game_loaded )

func _on_game_loaded() -> void:
	stats = SaveManager.current_save.stats


func enemy_stat_count( _victim ) -> void:
	stats.enemies_defeated += 1
	match _victim:
		"pixquitoe":
			stats.pixquitoes_killed += 1
		_:
			pass
