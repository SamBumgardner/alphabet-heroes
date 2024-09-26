@tool
extends EditorImportPlugin

enum Presets { DEFAULT }

func _get_importer_name():
	return "dialogue_cutscene_data_importer"

func _get_visible_name():
	return "Dialogue Cutscene"

func _get_import_order() -> int:
	return -1000

## If we don't override this it won't realize it's a valid 
## importer for the recognized_extensions defined below.
func _get_priority() -> float:
	return 1000.0

func _get_recognized_extensions():
	return ["dc"]

func _get_save_extension():
	return "tres"

func _get_resource_type():
	return "Resource"

func _get_preset_count() -> int:
	return 1

func _get_preset_name(preset_index) -> String:
	var name = ""
	match preset_index:
		Presets.DEFAULT:
			name = "default"
		_:
			name = "unknown"
	return name

func _get_import_options(path, preset_index) -> Array:
	var import_options:Array

	match preset_index:
		Presets.DEFAULT:
			import_options = [
				{
					"name": "character_data_path",
					"default_value": "res://data/dialogue_cutscene/characters",
					"property_hint": PROPERTY_HINT_DIR,
					"hint_string": "Path to directory storing DialogueCharacter resources"
				}
			]

	return import_options

func _get_option_visibility(path, option_name, options) -> bool:
	return true

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	
	var parsed_cutscene = DialogueCutsceneData.new()
	
	var next_line : String = ""
	while file.get_position() < file.get_length() or next_line != "":
		if next_line == "":
			next_line = file.get_line()
		
		if next_line.substr(0,1) == "!":
			var new_section = next_line.get_slice("!", 1).strip_edges()
			match new_section:
				"characters":
					next_line = _parse_characters(file, options, parsed_cutscene)
				"script":
					next_line = _parse_script(file, options, parsed_cutscene)
				_:
					push_warning("dialogue_cutscene_import.gd - unrecognized !-delimited section: %s" % [new_section])
					next_line = ""
		else:
			next_line = ""

	return ResourceSaver.save(parsed_cutscene, "%s.%s" % [save_path, _get_save_extension()])

func _parse_characters(file, options, parsed_cutscene) -> String:
	var unprocessed_line : String

	while file.get_position() < file.get_length():
		unprocessed_line = file.get_line()
		if unprocessed_line.substr(0,1) == "!":
			break
		
		var character_name = unprocessed_line.strip_edges()
		var expected_filename = "%s/DialogueCharacter_%s.tres" % [options.character_data_path, character_name]
		if FileAccess.file_exists(expected_filename):
			var character_resource = load(expected_filename)
			parsed_cutscene.characters.append(character_resource)
		elif !character_name.is_empty():
			push_warning("dialogue_cutscene_import.gd - could not find file %s to load character resource" % [expected_filename])
	
	return unprocessed_line

func _parse_script(file, _options, parsed_cutscene) -> String:
	var unprocessed_line : String = ""
	var speaker_name = ""
	var raw_script_text : String = ""
	var full_script : Array[DialogueScriptPage] = []

	while file.get_position() < file.get_length():
		unprocessed_line = file.get_line()

		if speaker_name.is_empty():
			speaker_name = _get_next_speaker_name(unprocessed_line)
		else:
			var cleaned_line = unprocessed_line.strip_edges()
			raw_script_text += cleaned_line
			if raw_script_text.ends_with("|"): # end of current page
				var finished_page = DialogueScriptPage.new()
				finished_page.speaker_name = speaker_name
				finished_page.dialogue_units = _parse_script_page(raw_script_text)
				full_script.append(finished_page)

				speaker_name = ""
				raw_script_text = ""

			elif raw_script_text != "":
				raw_script_text += "\n"

	parsed_cutscene.dialogue_script = full_script

	return unprocessed_line

func _get_next_speaker_name(line_to_check) -> String:
	if line_to_check.contains(":"):
		return line_to_check.get_slice(":", 0).strip_edges()
	else:
		return ""

func _parse_script_page(text : String) -> Array[DialogueUnit]:
	var units : Array[DialogueUnit] = []
	var meta_and_text : PackedStringArray = text.split("|", false)
	for i in range(0, meta_and_text.size(), 2):
		var regex = RegEx.new()
		regex.compile("[^.!?,]*[.!?,]+")
		var whitespace_regex = RegEx.new()
		whitespace_regex.compile("\\s")
		var sentences = regex.search_all(meta_and_text[i + 1])
		var starting_point = 0
		var sentence_i = 0
		while starting_point < meta_and_text[i + 1].length() - 1:
			var end_index = sentences[sentence_i].get_end() if sentences.size() != sentence_i else meta_and_text[i + 1].length()
			var unit = DialogueUnit.new()
			unit.initialize(meta_and_text[i + 1].substr(starting_point, end_index - starting_point), meta_and_text[i])
			if starting_point > 0:
				unit.delay_before = 0
			var last_char =  meta_and_text[i + 1].substr(end_index - 1, 1)
			if ",.!?".contains(last_char):
				if end_index >= meta_and_text[i + 1].length() - 1:
					unit.delay_after = max(DialogueCutscene.END_OF_SENTENCE_PAUSE, unit.delay_after)
				elif whitespace_regex.search(meta_and_text[i + 1].substr(end_index, 1)) == null:
					unit.delay_after = 0 # don't pause if the punctuation isn't followed by whitespace.
				else:
					unit.delay_after = DialogueCutscene.END_OF_SENTENCE_PAUSE
			units.append(unit)
			starting_point = end_index
			sentence_i += 1
	return units
