extends CanvasLayer
## A basic dialogue bubble for use with Dialogue Manager.

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"


## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []


## See if we are waiting for the player
var is_waiting_for_input: bool = false:
	set( value ):
		is_waiting_for_input = value
	get:
		return is_waiting_for_input


## See if we are running a long mutation and should hide the bubble
var will_hide_bubble: bool = false

## A dictionary to store any ephemeral variables
var locals: Dictionary = {}

var _locale: String = TranslationServer.get_locale()

## The current line
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			queue_free()
	get:
		return dialogue_line

## A cooldown timer for delaying the bubble hide when encountering a mutation.
var mutation_cooldown: Timer = Timer.new()

var got_dude
var pitch : float = 1.0
var audio_file : AudioStream
var has_pending_responses: bool = false


## The base bubble anchor
@onready var bubble: Control = %Bubble

## The label showing the currently spoken dialogue
@onready var dialogue_label: DialogueLabel = %DialogueLabel

## The menu of responses
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

@onready var panel: Panel = $Bubble/Panel
@onready var panel_responses: Panel = $Bubble/PanelResponses
@onready var bubble_pointer: Sprite2D = $Bubble/Panel/MarginContainerBubble/VBoxContainer/Sprite2D
@onready var bubble_pointer_responses: Sprite2D = $Bubble/PanelResponses/MarginContainerBubbleResp/VBoxContainer/Sprite2D
@onready var margin_container_bubble: MarginContainer = $Bubble/Panel/MarginContainerBubble
@onready var margin_container_bubble_resp: MarginContainer = $Bubble/PanelResponses/MarginContainerBubbleResp

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	bubble.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action
	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)
	
	dialogue_label.spoke.connect( _spoke )
	dialogue_label.seconds_per_step = SaveManager.talk_speed
	
	## pause / unpause
	get_tree().paused = true
	TimeSystem.time_tick.pause()
	DialogueManager.dialogue_ended.connect( _unpause )


func _spoke( letter: String, letter_index: int, speed: float = pitch ) -> void:
	##TODO: try every other vowel
	#if 'aeiouyäöü1234567890'.contains( letter ):
	if letter_index == 0:
		audio_stream_player.stream = audio_file
		audio_stream_player.set_pitch_scale( pitch * randf_range( 0.9, 1.1 ) )
		audio_stream_player.play()		
	if ' '.contains( letter ):
		choose_audio_file()
		audio_stream_player.stream = audio_file
		audio_stream_player.set_pitch_scale( pitch * randf_range( 0.9, 1.1 ) )
		audio_stream_player.play()


func _unpause( _t ) -> void:
	get_tree().paused = false
	TimeSystem.time_tick.resume()


func _unhandled_input(_event: InputEvent) -> void:
	# Only the bubble is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	## Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio = dialogue_label.visible_ratio
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


func choose_audio_file() -> void:
	var character : Resource
	var character_path : String = "res://npc/resources/%s.tres" % ( dialogue_line.character.to_snake_case() )
	if ResourceLoader.exists( character_path ):
		character = load( character_path )
		if character.talk_blips:
			var r : int = randi() % character.talk_blips.size()
			audio_file = load( character.talk_blips[ r ].resource_path )
			pitch = character.pitch


## Apply any changes to the bubble given a new [DialogueLine].
func apply_dialogue_line() -> void:
	var character : Resource
	var character_path : String = "res://npc/resources/%s.tres" % ( dialogue_line.character.to_snake_case() )
	var bubble_offset_x : float = 0
	var bubble_offset_y : float = 0
	if ResourceLoader.exists( character_path ):
		character = load( character_path )
		bubble_offset_x = character.bubble_offset_x
		bubble_offset_y = character.bubble_offset_y
		bubble_pointer.scale.x = 1
		
		var dude = dialogue_line.character.to_pascal_case()
		if dialogue_line.get_tag_value("location") == "cat":
			# if it's on the cat, we use the bird_friend_sprite
			got_dude = PlayerManager.player.bird_friend_sprite
			var pos : Vector2 =  got_dude.get_global_transform_with_canvas().get_origin()
			panel.position = Vector2( pos ) + Vector2( -345, -270 )
			bubble_pointer.scale.x = -1
		else:
			if character_path == "res://npc/resources/player.tres":
				var player_dir = PlayerManager.player.cardinal_direction
				match player_dir:
					Vector2.LEFT:
						bubble_offset_x = -75
						bubble_pointer.scale.x = -1
					Vector2.RIGHT:
						bubble_offset_x = 75
						bubble_pointer.scale.x = 1
					Vector2.UP, Vector2.DOWN:
						bubble_offset_x = 0
				got_dude = PlayerManager.player
			else:
				# if it's not the player or on the cat, get the dude from the tree
				if get_parent().get_node( dude ):
					got_dude = get_parent().get_node( dude )
			var pos : Vector2 =  got_dude.get_global_transform_with_canvas().get_origin()
			var v_frames : float = got_dude.sprite.vframes
			var sprite_height : float = got_dude.sprite.texture.get_height()
			var sprite_scale : float = got_dude.sprite.scale.y
			panel.position =  Vector2( pos ) + Vector2( -320 + bubble_offset_x, -210 - ( ( sprite_height / v_frames ) * sprite_scale ) + bubble_offset_y )
		
	var text_length :  float = dialogue_line.text.length()
	match true:
		##TODO: subtract BBCode text from length
		_ when text_length < 52:
			panel.size.y = 132
			panel.position.y = panel.position.y + 28
			margin_container_bubble.size.y = 110
			bubble_pointer.position.y = 118
			dialogue_label.custom_minimum_size.y = 62
		_ when text_length > 53 && text_length < 104:
			panel.size.y = 160
			margin_container_bubble.size.y = 138
			bubble_pointer.position.y = 146
			dialogue_label.custom_minimum_size.y = 92
		_:
			##text_length > 156 && < 208
			panel.size.y = 188
			panel.position.y = panel.position.y - 28
			margin_container_bubble.size.y = 166
			bubble_pointer.position.y = 176
			dialogue_label.custom_minimum_size.y = 122

	mutation_cooldown.stop()
	is_waiting_for_input = false
	bubble.focus_mode = Control.FOCUS_ALL
	bubble.grab_focus()
	
	choose_audio_file()

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	responses_menu.hide()
	panel_responses.hide()
	responses_menu.responses = dialogue_line.responses

	# Show our bubble
	bubble.show()
	will_hide_bubble = false

	dialogue_label.show()
	if not dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing

	# Wait for input
	if dialogue_line.responses.size() > 0:
		var got_response_dude = PlayerManager.player
		var player_dir = got_response_dude.cardinal_direction
		match player_dir:
			Vector2.LEFT:
				bubble_offset_x = 40
				bubble_pointer_responses.scale.x = 1
			Vector2.RIGHT:
				bubble_offset_x = 75
				bubble_pointer_responses.scale.x = -1
			Vector2.UP, Vector2.DOWN:
				bubble_offset_x = 0
		var pos : Vector2 =  got_response_dude.get_global_transform_with_canvas().get_origin()
		var v_frames : float = got_response_dude.sprite.vframes
		var sprite_height : float = got_response_dude.sprite.texture.get_height()
		var sprite_scale : float = got_response_dude.sprite.scale.y
		panel_responses.position = Vector2( pos ) + Vector2( -380 + bubble_offset_x, -200 - ( ( sprite_height / v_frames ) * sprite_scale ) )

		var lines : int = dialogue_line.responses.size()
		match lines:
			1:
				panel_responses.size.y = 132
				panel_responses.position.y = panel_responses.position.y + 28
				margin_container_bubble_resp.size.y = 110
				bubble_pointer_responses.position.y = 128
				dialogue_label.custom_minimum_size.y = 62
			2:
				panel_responses.size.y = 160
				margin_container_bubble_resp.size.y = 138
				bubble_pointer_responses.position.y = 156
				responses_menu.custom_minimum_size.y = 92
			3:
				panel_responses.size.y = 188
				panel_responses.position.y = panel_responses.position.y - 28
				margin_container_bubble_resp.size.y = 166
				bubble_pointer_responses.position.y = 186
				responses_menu.custom_minimum_size.y = 122
			4:
				panel_responses.size.y = 216
				panel_responses.position.y = panel_responses.position.y - 56
				margin_container_bubble_resp.size.y = 194
				bubble_pointer_responses.position.y = 216
				responses_menu.custom_minimum_size.y = 152
			5:
				panel_responses.size.y = 244
				panel_responses.position.y = panel_responses.position.y - 84
				margin_container_bubble_resp.size.y = 222
				bubble_pointer_responses.position.y = 246
				responses_menu.custom_minimum_size.y = 182

		has_pending_responses = true  
		is_waiting_for_input = true  
		bubble.focus_mode = Control.FOCUS_ALL  
		bubble.grab_focus()
		
		
	elif dialogue_line.time != "":
		var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)
	else:
		is_waiting_for_input = true
		bubble.focus_mode = Control.FOCUS_ALL
		bubble.grab_focus()


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_bubble:
		will_hide_bubble = false
		bubble.hide()


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_bubble = true
	mutation_cooldown.start(0.1)


func _on_bubble_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	
	if has_pending_responses:  
		has_pending_responses = false  
		bubble.focus_mode = Control.FOCUS_NONE  
		responses_menu.show()
		panel_responses.show()
		panel.hide()
		return
	
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the bubble itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == bubble:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)
	panel.show()


#endregion
