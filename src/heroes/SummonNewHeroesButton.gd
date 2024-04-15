extends Button

func _on_combat_started():
	disabled = true

func _on_combat_finished():
	disabled = false
