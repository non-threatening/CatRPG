class_name HurtBox extends Area2D
## Passes all vars through hit_box to enemy/plant or whatever 


@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect( _area_entered )
	pass

	
func _area_entered( a : Area2D ) -> void:
	if a is HitBox:
		a.take_damage( self ) ## This cause damage every enter...
		pass
