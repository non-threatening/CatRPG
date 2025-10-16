extends Node


func _init() -> void:
	print( "response: ", Steam.get_steam_init_result() )
	
	Steam.clearAchievement("ACH_MEET_BF")
	Steam.storeStats()


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
