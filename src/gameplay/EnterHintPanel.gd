extends PanelContainer

var already_shown = false

func _on_text_controller_word_changed(new_word):
	if not already_shown and new_word != "":
		show()
		already_shown = true

func _on_text_controller_word_consumed(word):
	hide()
