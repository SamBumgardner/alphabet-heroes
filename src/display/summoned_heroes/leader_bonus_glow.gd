extends Panel

func _ready():
	var original_color = modulate
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	tween.tween_property(self, "modulate", original_color, 1)
	tween.set_loops(0)
