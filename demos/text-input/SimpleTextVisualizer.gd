class_name SimpleTextVisualizer extends Label

func _on_word_changed(new_word:String):
	text = new_word.to_pascal_case()
	modulate = Color.from_hsv(randf(), randf(), randf())
