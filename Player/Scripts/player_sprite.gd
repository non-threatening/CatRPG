extends Sprite2D

const FRAME_COUNT : int = 128
const PLAYER = preload("uid://b4d5u50y4e3og")
const PLAYER_LOKTIN = preload("uid://b3iybtj0bph5k")

@onready var weapon_below: Sprite2D = $Sprite2D_Weapon_Below
@onready var weapon_above: Sprite2D = $Sprite2D_Weapon_Above
@onready var sprite: Sprite2D = $"."


func _ready() -> void:
	PlayerManager.INVETORY_DATA.equipment_changed.connect( _on_equipment_changed )
	LevelManager.level_loaded.connect( _check_level )
	
	
func _check_level() -> void:
	var thing = get_tree().get_current_scene().name
	if thing == "TheLobby":
		sprite.material.shader = PLAYER_LOKTIN
	else:
		sprite.material.shader = PLAYER
		#sprite.material.set_shader_parameter( "alpha_threshold", 0 )
		#sprite.material.set_shader_parameter( "cover_color", PlayerManager.player_color )


func _process( _delta: float ) -> void:
	## This syncs when the weapon sprites match the player sprites
	# TODO: change this to collar. Also, use this method to add tail!!
	weapon_below.frame = frame
	weapon_above.frame = frame + FRAME_COUNT
	pass
	
	

func _on_equipment_changed() -> void:
	var equipment : Array[ SlotData ] = PlayerManager.INVETORY_DATA.equipment_slots()
	await get_tree().process_frame
	
	texture = equipment[ 0 ].item_data.sprite_texture
	weapon_below.texture = equipment[ 2 ].item_data.sprite_texture
	weapon_above.texture = equipment[ 2 ].item_data.sprite_texture
	pass
