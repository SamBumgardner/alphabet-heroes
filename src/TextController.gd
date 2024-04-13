class_name TextController extends Node

static var alpha_regex = RegEx.create_from_string("[A-Z]")

@onready var viewport = get_viewport()

@export var max_letters:int = 5
@export var current_word:String = ""

func _unhandled_key_input(event:InputEvent):
	if event.is_pressed():
		var event_text = event.as_text()
		if event_text == "Backspace":
			print("Backspace key was pressed!")
			try_pop_letter()
			print(current_word)
		elif not event.is_echo():
			if event_text.length() == 1 and alpha_regex.search(event_text):
				try_append_letter(event_text)
				print(current_word)
			if event_text == "Enter":
				print("Enter key was pressed!")
				send_word()
	viewport.set_input_as_handled()

func try_append_letter(char_to_append : String) -> String:
	if current_word.length() < max_letters:
		current_word += char_to_append
	return current_word

func send_word():
	if TextValidator.is_valid(current_word):
		print("sending word %s to battle" % current_word)
		current_word = ""
	else:
		print("tried to send, but %s is not a valid word" % current_word)

func try_pop_letter():
	current_word = current_word.substr(0, current_word.length() - 1)
