extends Node

static var alpha_regex = RegEx.create_from_string("[A-Za-z]")

@onready var viewport = get_viewport()

func _unhandled_key_input(event:InputEvent):
	if event.is_pressed() and not event.is_echo():
		var event_text = event.as_text()
		if event_text.length() == 1 and alpha_regex.search(event_text):
			print(event_text)
		if event_text == "Enter":
			print("Enter key was pressed!")
		if event_text == "Backspace":
			print("Backspace key was pressed!")
	viewport.set_input_as_handled()
