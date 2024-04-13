class_name TextValidator extends RefCounted

const DICTIONARY_FILEPATH : String = "res://assets/data/enable1.txt"

static var valid_words : Dictionary

static func _static_init():
	valid_words = create_dictionary()

static func create_dictionary() -> Dictionary:
	var file = FileAccess.open(DICTIONARY_FILEPATH, FileAccess.READ)
	if file == null: 
		push_error(FileAccess.get_open_error())
	
	var word_dict = {}
	while file.get_position() < file.get_length():
		var next_line = file.get_line()
		word_dict[next_line.strip_edges().to_lower()] = true
	
	return word_dict

static func is_valid(word:String) -> bool:
	return valid_words.has(word.to_lower()) 
