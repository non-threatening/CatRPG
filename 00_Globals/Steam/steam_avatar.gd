extends TextureRect

#var icon_handle: int = Steam.getAchievementIcon("ACH_MEET_BF")
#var icon_size: Dictionary = Steam.getImageSize(icon_handle)
#var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)

func _ready() -> void:
	Steam.avatar_loaded.connect( _on_achievment_loaded )
	Steam.getPlayerAvatar( Steam.AVATAR_MEDIUM, Steam.getSteamID() )


func _on_achievment_loaded() -> void:
	# Get the image's handle
	var icon_handle: int = Steam.getAchievementIcon("ACH_MEET_BF")

	# Get the image data
	var icon_size: Dictionary = Steam.getImageSize(icon_handle)
	var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)

	# Create the image for loading
	var icon_image: Image = Image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])

	# Create a texture from the image
	var icon_texture: ImageTexture = ImageTexture.create_from_image(icon_image)

	# Display the texture on a sprite node
	texture = icon_texture


func _on_avatar_loaded( user_id : int, avatar_size : int, avatar_buffer : PackedByteArray ) -> void:
	var image : Image = Image.create_from_data( avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer )
	var image_tex : ImageTexture = ImageTexture.create_from_image( image )
	texture = image_tex
