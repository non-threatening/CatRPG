class_name CenterNotification extends Control

var notification_queue : Array

@onready var panel_container: PanelContainer = $PanelContainer
@onready var title_label: Label = $PanelContainer/VBoxContainer/Label
@onready var message_label: RichTextLabel = $PanelContainer/VBoxContainer/Label2
@onready var animation_player_center: AnimationPlayer = $AnimationPlayerCenter


func _ready() -> void:
	panel_container.visible = false
	animation_player_center.animation_finished.connect( notification_animation_finished )


func add_notification_to_queue( _title : String, _message : String ) -> void:
	notification_queue.append({
		title = _title,
		message = _message 
	})
	if animation_player_center.is_playing():
		return
	display_notification()
	pass


func display_notification() -> void:
	var _n = notification_queue.pop_front()
	if _n == null:
		return
	title_label.text = _n.title
	message_label.text = _n.message
	animation_player_center.play("display_notification")
	pass
	
	
func notification_animation_finished( _a : String ) -> void:
	display_notification()
	pass
