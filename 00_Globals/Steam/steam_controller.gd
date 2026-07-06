extends Node


func _init() -> void:
	#if Steam.isSteamRunning():
		print( "response: ", Steam.get_steam_init_result() )
		Steam.clearAchievement("ACH_MEET_BF")
		Steam.clearAchievement("ACH_MEET_BAT")
		Steam.storeStats()


func _ready() -> void:
	Steam.user_stats_received.connect(_on_user_stats_received)
	var steam_id : int = Steam.getSteamID()
	prints( "steam id:", steam_id )
	Steam.requestUserStats( steam_id )
	other()
	load_steam_stats()


func _on_user_stats_received(game_id: int, result: int, user_id: int) -> void:
	prints("stats received:", game_id, result, user_id)
	print( "getStatInt: ", Steam.getStatInt( "Q_COMPLETE" ))


func load_steam_stats() -> void:
	for this_stat in StatsManager.stats.keys():
		var stat_value: int = Steam.getStatInt(this_stat)
		prints("Retrieved stat:", this_stat, stat_value)

		# Store the value in our dictionary
		StatsManager.stats[this_stat] = stat_value
	print("Steam statistics loaded")



func other() -> void:
		var username : String = Steam.getPersonaName()
		print( "username: ", username )
		
		#var steam_id : int = Steam.getSteamID()
		#print( "Steam ID", steam_id )
		
		
		#var app_installed_depots: Array = Steam.getInstalledDepots( steam_id )
		#var app_languages: String = Steam.getAvailableGameLanguages()
		#var app_owner: int = Steam.getAppOwner()
		#print(app_owner)
		#var build_id: int = Steam.getAppBuildId()
		#var game_language: String = Steam.getCurrentGameLanguage()
		##var install_dir : Dictionary = Steam.getAppInstallDir( steam_id )
		#var is_on_steam_deck: bool = Steam.isSteamRunningOnSteamDeck()
		#print( "is steamdeck: ", is_on_steam_deck )
		#var is_on_vr: bool = Steam.isSteamRunningInVR()
		#var is_online: bool = Steam.loggedOn()
		#var is_owned: bool = Steam.isSubscribed()
		#var launch_command_line: String = Steam.getLaunchCommandLine()
		#var ui_language: String = Steam.getSteamUILanguage()
		#
		#print( ui_language, " ", game_language )
