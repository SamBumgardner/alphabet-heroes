class_name TileTextDisplay extends HBoxContainer

@onready var letter_tiles : Array = get_children()

func _ready():
	_set_word("")

func _set_word(new_word:String):
	modulate = Color.WHITE
	
	var upper_cased_word = new_word.to_upper()
	var i = 0
	for tile : LetterTile in letter_tiles:
		if i < new_word.length():
			tile.set_letter(upper_cased_word[i])
		else:
			tile.set_letter("")
		i += 1

# Color the denied word red for user feedback.
func _color_denied_text() -> void:
	if modulate != Color.RED:
		modulate = Color.RED
