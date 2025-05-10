extends PanelContainer

func _on_text_controller_word_changed(new_word):
	if new_word != "":
		hide()
