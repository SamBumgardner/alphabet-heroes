class_name DialogueCutscene
extends Control

# ======= #
# Signals #
# ======= #
## Emitted when the cutscene is completed
## Typically when attempting to advance the cutscene while on the final script page.
signal cutscene_finished

# ========= #
# Constants #
# ========= #
## Time to pause after displaying punctuation (in seconds)
## Used when parsing script pages into arrays of [DialogueUnit]
const END_OF_SENTENCE_PAUSE : float = .15

## Duration of fade visual effect (in seconds) when displaying / hiding cutscene resources
const FADE_DURATION : float = .25

# ============== #
# Public Members #
# ============== #
## Currently loaded cutscene. 
## Set value to load data, then call [method fade_in)] to reveal nodes & begin the cutscene
var cutscene : DialogueCutsceneData:
	set = init_cutscene

## Set this to change the Dialogue Box's background and dynamically adjust margins to match.
var dialogue_box_background : NinePatchRect:
	set = _set_dialogue_box_background

var name_tag_background : NinePatchRect:
	set = _set_name_tag_box_background

## Set this to override the default text-advance arrow texture.
var dialogue_arrow_texture : Texture2D:
	set = _set_dialogue_arrow

# =============== #
# Private Members #
# =============== #
## Contains all [DialogueCharacter]s needed in the current [member cutscene]
var _characters : Dictionary

var _current_script_page : int
## Array of [DialogueUnit] parsed from the cutscene's current script "page"
## Content generated via [method _parse_script_page] when advancing the scene via [method _attempt_scene_advance]
var _dialogue_units : Array[DialogueUnit]

## index of [DialogueUnit] currently being revealed in the subordinate [DialogueDisplay].
## Used to coordinate animations with progression of [DialogueUnits] while displaying script pages.
var _current_unit_i = 0

## tracks if the cutscene is in the process of "closing" and fading out.
## Used to prevent interruptions / issues caused by repeated attempts to close the cutscene.
var _is_closing : bool = false

# ================ #
# On-Ready Members #
# ================ #
@onready var audio_stream_randomizer : AudioStreamRandomizer = $AudioStreamPlayer.stream
@onready var dialogue_display : DialogueDisplay = $DialogueContainer/DialogueDisplay
@onready var character_portrait : AnimatedSprite2D = $Characters/Portrait
@onready var character_mouth : AnimatedSprite2D = $Characters/Portrait/AnimatedMouth
@onready var name_tag_nine_patch : NinePatchRect = $DialogueContainer/NameTag/NinePatchRect
@onready var name_tag_margin_container : MarginContainer = $DialogueContainer/NameTag/MarginContainer

# ======================== #
# Built-in Virtual Methods # 
# ======================== #
## Constructor
## Optionally sets [member cutscene] to [param starting_cutscene], initializing it in the process.
func _init(starting_cutscene : DialogueCutsceneData = null):
	cutscene = starting_cutscene

## Connects events needed to coordinate timing of text reveal and audio / visual actions
## If [member cutscene] has a non-null value, initializes data to prepare to play that cutscene.
func _ready():
	dialogue_display.dialogue_label.non_whitespace_char_revealed.connect(_on_text_revealed, CONNECT_DEFERRED)
	dialogue_display.dialogue_label.is_talking_changed.connect(_on_is_talking_changed, CONNECT_DEFERRED)
	dialogue_display.starting_dialogue_unit.connect(_on_starting_dialogue_unit)
	
	if dialogue_box_background != null:
		_set_dialogue_box_background(dialogue_box_background)
	if dialogue_arrow_texture != null:
		_set_dialogue_arrow(dialogue_arrow_texture)
	if name_tag_background != null:
		_set_name_tag_box_background(name_tag_background)
	
	init_cutscene(cutscene)

## Consumes "ui_accept pressed" input events.
## Attempts to advance the scene. See [method _attempt_scene_advance] for further information.
func _input(event):
	if event.is_action_pressed("ui_accept"):
		_attempt_scene_advance()

# ============== #
# Public Methods #
# ============== #
## 
func set_graphic_overrides(
		dialogue_bg : NinePatchRect = null, 
		name_tag_bg : NinePatchRect = null, 
		arrow_texture : Texture2D = null):
	if dialogue_bg:
		dialogue_box_background = dialogue_bg
	if name_tag_bg:
		name_tag_background = name_tag_bg
	if arrow_texture:
		dialogue_arrow_texture = arrow_texture
	

## Uses provided [param cutscene_data] to set internal variables.
## Must be called (explicitly or implicitly via set [member cutscene]) before attempting [method open_cutscene]
func init_cutscene(cutscene_data : DialogueCutsceneData):
	cutscene = cutscene_data
	_characters.clear()
	if cutscene != null:
		for character in cutscene.characters:
			_characters[character.name] = character
	
	_current_script_page = -1

## Prepares this [DialogueCutscene] and child nodes for display, then reveals them.
## After nodes are fully revealed, begins to display the first page of the scene.
## Must have already set / initialized [member cutscene] data before calling.
func open_cutscene():
	if cutscene == null:
		push_error("Attempted to call open_cutscene without setting cutscene data"
			+ " first. Cannot open, emitting cutscene_finished event instead")
		cutscene_finished.emit()
		return

	_is_closing = false
	visible = true
	modulate = Color.TRANSPARENT
	$Characters.modulate = Color.TRANSPARENT
	$DialogueContainer/NameTag.modulate = Color.TRANSPARENT
	_change_displayed_character(cutscene.dialogue_script[0].speaker_name)
	_dialogue_units = cutscene.dialogue_script[0].dialogue_units
	_on_starting_dialogue_unit(0, false)
	dialogue_display.reset()
	

	var fade_in_tween = create_tween() 
	fade_in_tween.tween_property(self, "modulate", Color.WHITE, FADE_DURATION)
	fade_in_tween.tween_property($Characters, "modulate", Color.WHITE, FADE_DURATION / 2)
	fade_in_tween.tween_property($DialogueContainer/NameTag, "modulate", Color.WHITE, FADE_DURATION / 2)
	fade_in_tween.tween_callback(_attempt_scene_advance)

## Hides this [DialogueCutscene] and child nodes, then emits the [signal cutscene_finished] signal to indicate the scene is complete.
func close_cutscene():
	_is_closing = true
	visible = true
	modulate = Color.WHITE
	$Characters.modulate = Color.WHITE
	$DialogueContainer/NameTag.modulate = Color.WHITE
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property($DialogueContainer/NameTag, "modulate", Color.TRANSPARENT, FADE_DURATION / 2)
	fade_out_tween.tween_property($Characters, "modulate", Color.TRANSPARENT, FADE_DURATION / 2)
	fade_out_tween.tween_property(self, "modulate", Color.TRANSPARENT, FADE_DURATION) 
	fade_out_tween.tween_property(self, "visible", false, 0) 
	fade_out_tween.tween_callback(emit_signal.bind("cutscene_finished"))

# =============== #
# Private Methods #
# =============== #
func _animate_talking(animation_name : String, speed : float) -> void:
	$Characters/Portrait/AnimatedMouth.play(animation_name, speed)

# Can only advance the scene if the cutscene has content available and all relevant children are ready.
# The idea is that attempting to advance the dialogue serves as a status check and (if necessary) an
# instruction to advance the scene.
func _attempt_scene_advance() -> void:
	var can_start_next_page : bool = \
		cutscene != null \
		and !_is_closing \
		and dialogue_display.attempt_dialogue_advance()
	
	if can_start_next_page:
		_current_script_page += 1
		if _current_script_page < cutscene.dialogue_script.size():
			_current_unit_i = -1
			_change_displayed_character(cutscene.dialogue_script[_current_script_page].speaker_name)
			_dialogue_units = cutscene.dialogue_script[_current_script_page].dialogue_units
			dialogue_display.display_dialogue(_dialogue_units)
		elif visible:
			close_cutscene()

# Changes expression, mouth graphic, name tag, and "talking" audio noise.
func _change_displayed_character(character_name : String) -> void:
	$DialogueContainer/NameTag/MarginContainer/CharacterName.text = character_name
	character_portrait.sprite_frames = _characters[character_name].expressions
	character_portrait.offset.y = -1 * character_portrait.sprite_frames.get_frame_texture("default", 0).get_height()
	character_mouth.sprite_frames = _characters[character_name].mouth_frames
	character_mouth.offset.y = -1 * character_mouth.sprite_frames.get_frame_texture("default", 0).get_height()
	
	if audio_stream_randomizer.streams_count > 0:
		audio_stream_randomizer.remove_stream(0)
	audio_stream_randomizer.add_stream(0, _characters[character_name].voice, 1)

func _set_dialogue_box_background(new_graphic : NinePatchRect):
	if dialogue_display != null:
		dialogue_display.change_nine_patch_rect(new_graphic)

func _set_name_tag_box_background(new_graphic : NinePatchRect):
	if name_tag_nine_patch != null and name_tag_margin_container != null:
		name_tag_nine_patch.texture = new_graphic.texture
			
		name_tag_nine_patch.axis_stretch_horizontal = new_graphic.axis_stretch_horizontal
		name_tag_nine_patch.axis_stretch_vertical = new_graphic.axis_stretch_vertical
		name_tag_nine_patch.draw_center = new_graphic.draw_center
		name_tag_nine_patch.mouse_filter = new_graphic.mouse_filter
		name_tag_nine_patch.patch_margin_bottom = new_graphic.patch_margin_bottom
		name_tag_nine_patch.patch_margin_left = new_graphic.patch_margin_left
		name_tag_nine_patch.patch_margin_right = new_graphic.patch_margin_right
		name_tag_nine_patch.patch_margin_top = new_graphic.patch_margin_top

		name_tag_margin_container.add_theme_constant_override("margin_top", new_graphic.patch_margin_top / 2)
		name_tag_margin_container.add_theme_constant_override("margin_bottom", new_graphic.patch_margin_bottom / 2)
		name_tag_margin_container.add_theme_constant_override("margin_left", new_graphic.patch_margin_left)
		name_tag_margin_container.add_theme_constant_override("margin_right", new_graphic.patch_margin_right)

func _set_dialogue_arrow(new_texture : Texture2D):
	if dialogue_display != null:
		dialogue_display.change_arrow_texture(new_texture)

# ============== #
# Event Handling #
# ============== #
func _on_text_revealed():
	$AudioStreamPlayer.play()

func _on_starting_dialogue_unit(starting_unit_i : int, is_talking : bool) -> void:
	_current_unit_i = starting_unit_i
	$Characters/Portrait.play(_dialogue_units[_current_unit_i].expression_name)
	_on_is_talking_changed(is_talking)

func _on_is_talking_changed(is_talking : bool) -> void:
	if !is_talking:
		_animate_talking(_dialogue_units[_current_unit_i].resting_animation, _dialogue_units[_current_unit_i].speed_mult)
	else:
		_animate_talking(_dialogue_units[_current_unit_i].talking_animation, _dialogue_units[_current_unit_i].speed_mult)
