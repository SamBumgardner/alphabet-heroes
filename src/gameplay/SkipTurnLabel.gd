extends Label

func _on_turn_skipped(duration:float):
	visible = true
	modulate = Color.WHITE
	
	var start_position = position
	var tween = create_tween()
	tween.tween_property(
		self, 
		"position", 
		start_position - Vector2(0, -50),
		duration
	)
	tween.parallel().tween_property(
		self,
		"modulate",
		Color.TRANSPARENT,
		duration
	)
	tween.tween_property(
		self,
		"visible",
		false,
		0
	)
	tween.parallel().tween_property(
		self,
		"position",
		start_position,
		0
	)
