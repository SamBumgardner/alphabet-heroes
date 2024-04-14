class_name LetterTile extends TextureRect

@onready var label = $Label as Label

func set_letter(new_value:String):
	label.text = "%s" % new_value
	if new_value == "":
		hide()
	else:
		show()
