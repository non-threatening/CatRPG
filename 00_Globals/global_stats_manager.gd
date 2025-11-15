extends Node


var stats = {
	quests_completed = 0,
	friends_made = 0,
	enemies_defeated = 0,
	pixquitoes_killed = 0,
	poops_taken = 0,
	butts_sniffed = 0,
}


func _ready() -> void:
	SaveManager.game_loaded.connect( _on_game_loaded )

func _on_game_loaded() -> void:
	#######
	stats = SaveManager.current_save.stats


func enemy_stat_count( victim ) -> void:
	stats.enemies_defeated += 1
	match victim:
		"pixquitoe":
			stats.pixquitoes_killed += 1
		_:
			pass
