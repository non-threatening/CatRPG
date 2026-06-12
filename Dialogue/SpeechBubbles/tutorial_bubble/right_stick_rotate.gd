class_name RightStickRotate extends Node2D

#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var frame : int = 0

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	var drunk = pow(-1, randi() % 2)
	frame = clampi( int(drunk) + frame, 0, 6 )
	sprite_2d.frame = frame
