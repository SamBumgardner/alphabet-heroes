extends Button

const password = "HARD"

static var alpha_regex = RegEx.create_from_string("[A-Z]")
var remembered_letters = ""

@onready var viewport = get_viewport()

func _unhandled_key_input(event:InputEvent):
	if event.is_pressed():
		var event_text_with_modifiers = event.as_text().split("+")
		var event_text = event_text_with_modifiers[event_text_with_modifiers.size() - 1]
		if not event.is_echo():
			if event_text.length() == 1 and alpha_regex.search(event_text):
				try_append_letter(event_text)
				viewport.set_input_as_handled()

func try_append_letter(letter:String):
	remembered_letters += letter
	
	if password == remembered_letters and !visible:
		show()
	elif !password.begins_with(remembered_letters):
		remembered_letters = ""
	
