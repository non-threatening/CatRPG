extends CanvasLayer
## A basic dialogue bubble for use with Dialogue Manager.

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

@onready var panel_container: TextureRect = $Bubble/MarginContainer/PanelContainer

@onready var portrait: TextureRect = %Portrait


## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []


## See if we are waiting for the player
var is_waiting_for_input: bool = false:
	set( value ):
		is_waiting_for_input = value
		label.visible = value
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


var pitch : float = 1.0


## The base bubble anchor
@onready var bubble: Control = %Bubble

## The label showing the name of the currently speaking character
@onready var character_label: RichTextLabel = %CharacterLabel

## The label showing the currently spoken dialogue
@onready var dialogue_label: DialogueLabel = %DialogueLabel

## The menu of responses
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu


@onready var margin_container: MarginContainer = $Bubble/MarginContainer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var label: Label = $Bubble/Label


func _ready() -> void:
	bubble.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action
	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)
	
	dialogue_label.spoke.connect( _spoke )
	
	## pause / unpause
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect( _unpause )


func _spoke( letter: String, letter_index: int, speed: float ) -> void:
	if 'aeiouy1234567890'.contains( letter ):
		audio_stream_player.set_pitch_scale( pitch * randf_range( 0.85, 1.15 ))
		audio_stream_player.play()


func _unpause( _t ) -> void:
	get_tree().paused = false


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
	  

## Apply any changes to the bubble given a new [DialogueLine].
func apply_dialogue_line() -> void:
	mutation_cooldown.stop()

	is_waiting_for_input = false
	bubble.focus_mode = Control.FOCUS_ALL
	bubble.grab_focus()
	
	
	var character : Resource
	var character_path : String = "res://npc/00_npcs/%s.tres" % ( dialogue_line.character.to_snake_case() )
	if ResourceLoader.exists( character_path ):
		character = load( character_path )
		pitch = character.dialog_audio_pitch
	elif dialogue_line.character.to_snake_case() == "cat":
		pitch = 1.0


	character_label.visible = not dialogue_line.character.is_empty()
	character_label.text = tr(dialogue_line.character, "dialogue")

	#only change charactr when a new character appears ???
	# Or use tags, maybe better.. if cat use [1]
	var emotion : String = ""
	if not dialogue_line.tags.is_empty():
		emotion = ( "_" + dialogue_line.tags[0] )
		
		
	var portrait_path : String = "res://Dialogue/SpeachBubbles/portraits/%s.png" % ( dialogue_line.character.to_snake_case() + emotion )
	print( "pp ", portrait_path)
	if ResourceLoader.exists( portrait_path ):
		portrait.texture = load( portrait_path )
	else:
		portrait.texture = null

	#resource.get_next_dialogue_line(next_id, temporary_game_states)

#	Narrator or not
	if not dialogue_line.character.to_lower() == "narrator":
		margin_container.position.y = 428
		%DialogueLabel.horizontal_alignment = 0
	else:
		margin_container.position.y = 128
		character_label.text = ""
		%DialogueLabel.horizontal_alignment = 1
		

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	responses_menu.hide()
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
		bubble.focus_mode = Control.FOCUS_NONE
		responses_menu.show()
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
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the bubble itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == bubble:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)


#endregion
