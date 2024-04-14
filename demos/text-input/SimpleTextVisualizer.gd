class_name SimpleTextVisualizer extends Label

func _on_word_changed(new_word:String):
	text = new_word.to_pascal_case()
	modulate = Color.from_hsv(randf(), randf(), randf())

func _on_text_controller_word_denied(word):
	_color_denied_text()

# Color the denied word red for user feedback.
func _color_denied_text() -> void:
	if modulate != Color.RED:
		modulate = Color.RED
