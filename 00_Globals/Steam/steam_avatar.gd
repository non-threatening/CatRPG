extends TextureRect
#
#func _ready() -> void:
	#if Steam.isSteamRunning():
		#Steam.avatar_loaded.connect( _on_avatar_loaded )
		#Steam.getPlayerAvatar( Steam.AVATAR_MEDIUM, Steam.getSteamID() )
#
#
#func _on_avatar_loaded( user_id : int, avatar_size : int, avatar_buffer : PackedByteArray ) -> void:
	#var image : Image = Image.create_from_data( avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer )
	#var image_tex : ImageTexture = ImageTexture.create_from_image( image )
	#texture = image_tex
