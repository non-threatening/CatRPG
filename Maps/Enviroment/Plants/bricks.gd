@tool
extends Sprite2D

@onready var sprite: Sprite2D = $"."

func _ready():
	set_notify_transform(true)

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		#get_material().set_shader_param("scale", scale)
		sprite.material.set_shader_parameter( "time_scale", scale )
