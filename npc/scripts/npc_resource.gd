class_name NPCResource extends Resource


@export var npc_name : String = ""
@export var sprite : Texture
@export var h_frames : int = 3
@export var v_frames : int = 3
#@export var portrait : Texture

@export var talk_blips : Array[ AudioStream ]
@export_range( 0.5, 1.8, 0.02 ) var pitch : float = 1.0

@export var friends : Dictionary[ String, int ]

@export_enum( "Forest",	"Terminal" ) var friend_type: int = 0
