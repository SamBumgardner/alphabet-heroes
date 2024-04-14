extends MarginContainer

@export var icon_graphic : Texture

@onready var label = $Label

func _ready():
	$TextureRect.texture = icon_graphic

func set_combat_value(new_value:int):
	label.text = "%s" % new_value
	if new_value == 0:
		hide()
	else:
		show()
