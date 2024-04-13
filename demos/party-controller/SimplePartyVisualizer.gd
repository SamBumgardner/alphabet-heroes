extends Label

func _on_party_changed(new_party:Party):
	text = new_party.to_string()
	modulate = Color.from_hsv(randf(), randf(), randf())
