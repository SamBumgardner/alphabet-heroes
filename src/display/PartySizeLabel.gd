extends Label

@export var text_controller:TextController

func _ready():
	text_controller.max_letters_changed.connect(_on_max_letters_changed)
	initialize_text_controller.call_deferred()

func initialize_text_controller():
	_on_max_letters_changed(text_controller.max_letters)

func _on_max_letters_changed(new_max_letters:int):
	text = "Party Size Limit: %s" % new_max_letters
