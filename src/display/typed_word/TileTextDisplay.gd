class_name TileTextDisplay extends HBoxContainer

@onready var letter_tiles : Array = get_children()

var text_shake_tween : Tween
var start_position : Vector2

var sides = [
	SIDE_BOTTOM,
	SIDE_LEFT,
	SIDE_RIGHT,
	SIDE_TOP
]
var saved_anchors = [
	0.0,
	0.0,
	0.0,
	0.0
]

func _ready():
	_set_word("")
	_save_anchors()

func _set_word(new_word:String):
	var upper_cased_word = new_word.to_upper()
	var i = 0
	for tile : LetterTile in letter_tiles:
		if i < new_word.length():
			tile.set_letter(upper_cased_word[i])
		else:
			tile.set_letter("")
		tile.label.modulate = Color.WHITE
		i += 1

# Color accepted word green to signal start of combat
func _word_submitted_reaction(_word:String):
	for tile : LetterTile in letter_tiles:
		tile.label.modulate = Color.GREEN

# Color the denied word red for user feedback.
func _color_denied_text(_word:String):
	for tile : LetterTile in letter_tiles:
		tile.label.modulate = Color.RED
	_reset_shake_tween()

func _reset_shake_tween():
	if text_shake_tween != null and text_shake_tween.is_valid():
		text_shake_tween.stop()
	start_position = position
	text_shake_tween = create_tween()
	text_shake_tween.tween_method(_shake, 0, 0, .1)
	text_shake_tween.tween_callback(_reset_anchors)

func _shake(_value : float):
	position = start_position + (Vector2.ONE.rotated(randf_range(0, 6.29)) * 2)

func _save_anchors():
	saved_anchors[0] = anchor_bottom
	saved_anchors[1] = anchor_left
	saved_anchors[2] = anchor_right
	saved_anchors[3] = anchor_top

func _reset_anchors():
	for i in range(sides.size()):
		set_anchor_and_offset(sides[i], saved_anchors[i], 0, true) 
