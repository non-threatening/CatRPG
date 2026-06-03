class_name PlayerCamera extends Camera2D

@export_range( 0, 2, 0.05, "or_greater" ) var shake_power : float = 1.0 # how quick it starts
@export var shake_max_offset : float = 32.0 # max shake in pixels
@export var shake_decay : float = 6.66 # how quick it stops
var shake_trauma : float = 1.0


func _ready() -> void:
	LevelManager.TileMapBoundsChanged.connect( _updateLimits )
	_updateLimits( LevelManager.current_tilemap_bounds )
	EffectManager.camera_shook.connect( add_camera_shake )


func _physics_process( delta : float ) -> void:
	if shake_trauma > 0:
		shake_trauma = max( shake_trauma - shake_decay * delta, 0 ) 
		shake()

	
func add_camera_shake( val : float) -> void:
	shake_trauma = val
	
	
func shake() -> void:
	var amount : float = pow( shake_trauma * shake_power, 2 )
	offset = Vector2( randf_range( -1, 1), randf_range( -1, 1) ) * shake_max_offset * amount


func _updateLimits( bounds : Array[ Vector2 ] ) -> void:
	if bounds == []:
		return
	limit_left = int( bounds[0].x ) 
	limit_top = int( bounds[0].y ) 
	limit_right = int( bounds[1].x ) 
	limit_bottom = int( bounds[1].y ) 
