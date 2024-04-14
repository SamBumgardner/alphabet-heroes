extends Label

const TEXT_TEMPLATE = "Health: %s"

func _on_hurt(_previous_health:int, new_health:int):
	text = TEXT_TEMPLATE % new_health
	modulate = Color.RED

func _on_healed(_previous_health:int, new_health:int):
	text = TEXT_TEMPLATE % new_health
	modulate = Color.WHITE
