class_name DialogueDisplay
extends NinePatchRect
## Resizable UI element for dynamically displaying dialogue.
##
## Interprets metadata provided in [DialogueUnit] objects to determine the content, speed, and 
## timing to use when displaying text.
## 
## Emits signals to indicate when beginning the display of a new [DialogueUnit]. 
## Child [Dialogue] node emits signals to indicate when "talking" has started or stopped, as well as
## when non-whitespace, non-punctuation characters appear.

## Emitted when beginning the display of a new [DialogueUnit] (when starting the
## [member DialogueUnit.delay_before], to be specific)
signal starting_dialogue_unit(dialogue_unit_i, is_talking)

## Default text reveal speed.
const SEC_PER_CHAR : float = .05

var _current_dialogue_unit : int
var _text_appear_tween : Tween

@onready var dialogue_label : Dialogue = $Dialogue
@onready var advance_arrow : TextureRect = $DialogueAdvanceArrow

func _ready():
	dialogue_label.recalculate_margins(self)
	advance_arrow.recalculate_margins(self)

## Either accelerates dialogue (by skipping directly to the end) or returns [code]true[/code] 
## to indicate that the dialogue has successfully completed.
func attempt_dialogue_advance() -> bool:
	if _text_appear_tween != null and _text_appear_tween.is_running():
		_text_appear_tween.custom_step(1000)
		return false
	else:
		return true

## Begins the display of an array of [DialogueUnit]s. 
##
## Also handles clearing old content from the dialogue box.
func display_dialogue(dialogue_units : Array[DialogueUnit]) -> void:
	reset()
	_current_dialogue_unit = -1
	var text_to_show = ""
	dialogue_label.visible_characters = 0
	
	_text_appear_tween = create_tween()
	for i in dialogue_units.size():
		_text_appear_tween.tween_callback(_starting_new_dialogue_unit)
		var unit : DialogueUnit = dialogue_units[i]
		text_to_show += unit.text
		if unit.delay_before > 0:
			_text_appear_tween.tween_interval(unit.delay_before)
		_text_appear_tween.tween_property(
			dialogue_label, "visible_characters", text_to_show.length(), 
			unit.text.length() * SEC_PER_CHAR / unit.speed_mult)
		if unit.delay_after > 0:
			_text_appear_tween.tween_interval(unit.delay_after)
	
	_text_appear_tween.finished.connect(advance_arrow.show, CONNECT_ONE_SHOT)
	
	dialogue_label.text = text_to_show

## Resets display to be empty and not-yet-completed.
func reset() -> void:
	dialogue_label.text = ""
	advance_arrow.hide()

## Change texture and patch margins to match the provided example
func change_nine_patch_rect(example_nine_patch : NinePatchRect) -> void:
	texture = example_nine_patch.texture
		
	axis_stretch_horizontal = example_nine_patch.axis_stretch_horizontal
	axis_stretch_vertical = example_nine_patch.axis_stretch_vertical
	draw_center = example_nine_patch.draw_center
	mouse_filter = example_nine_patch.mouse_filter
	patch_margin_bottom = example_nine_patch.patch_margin_bottom
	patch_margin_left = example_nine_patch.patch_margin_left
	patch_margin_right = example_nine_patch.patch_margin_right
	patch_margin_top = example_nine_patch.patch_margin_top
	
	dialogue_label.recalculate_margins(self)
	advance_arrow.recalculate_margins(self)

func change_arrow_texture(new_texture : Texture2D) -> void:
	advance_arrow.texture = new_texture

## Triggered when via tween callback whenever beginning the display of a new [DialogueUnit]
## Responsible for accurately emitting [signal starting_dialogue_unit] events.
func _starting_new_dialogue_unit():
		_current_dialogue_unit += 1
		starting_dialogue_unit.emit(_current_dialogue_unit, dialogue_label.is_talking)

func _on_item_rect_changed():
	if is_node_ready():
		advance_arrow.recalculate_margins(self)
