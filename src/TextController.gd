class_name TextController extends Node

signal word_changed(new_word)
signal word_activated(word)
signal word_consumed(word)

static var alpha_regex = RegEx.create_from_string("[A-Z]")

@onready var viewport = get_viewport()

@export var max_letters:int = 5
@export var current_word:String = "":
	set(value):
		current_word = value
		if is_inside_tree():
			word_changed.emit(current_word)

func _unhandled_key_input(event:InputEvent):
	if event.is_pressed():
		var event_text_with_modifiers = event.as_text().split("+")
		var event_text = event_text_with_modifiers[event_text_with_modifiers.size() - 1]
		if event_text == "Backspace":
			try_backspace_letter()
			viewport.set_input_as_handled()
		elif not event.is_echo():
			if event_text.length() == 1 and alpha_regex.search(event_text):
				try_append_letter(event_text)
				viewport.set_input_as_handled()
			elif event_text == "Enter":
				send_word()
				viewport.set_input_as_handled()

func try_append_letter(char_to_append : String) -> String:
	if current_word.length() < max_letters:
		current_word += char_to_append
	return current_word

func send_word():
	if TextValidator.is_valid(current_word):
		print("sending word %s to battle!" % current_word)
		word_activated.emit(current_word)
		word_consumed.emit(current_word)
		current_word = ""
	else:
		print("tried to start the battle, but %s is not a valid word" % current_word)

func try_backspace_letter():
	current_word = current_word.substr(0, current_word.length() - 1)
