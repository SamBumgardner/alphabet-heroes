extends AnimationPlayer

func _ready():
	autoplay = "intro_animation"

func _unhandled_key_input(event):
	if is_playing():
		advance(25)
