class_name BlockIcon extends TextureRect

@onready var label = $Label as Label

func set_block(new_value:int):
	label.text = "%s" % new_value
	if new_value == 0:
		hide()
	else:
		show()
