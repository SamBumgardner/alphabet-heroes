extends Label
func _on_action_changed(new_action:EnemyAction):
	text = new_action.to_string()
	#modulate = Color.from_hsv(randf(), randf(), randf())
