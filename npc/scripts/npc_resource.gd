class_name NPCResource extends Resource


@export var npc_name : String = ""
@export var sprite : Texture
#@export var portrait : Texture

@export var talk_blip : AudioStream
@export_range( 0.5, 1.8, 0.02 ) var pitch : float = 1.0
