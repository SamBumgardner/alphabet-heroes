class_name IntroAnimation extends AnimationPlayer

signal intro_finished

func _ready():
	autoplay = "intro_animation"
	animation_finished.connect(_on_animation_finished)

func _unhandled_key_input(event):
	if event.is_pressed() and not event.is_echo():
		if current_animation == "intro_animation" and is_playing():
			seek(26)
			print(event.to_string())
		elif not is_playing():
			print(event.to_string())
			play("clean_up_intro")
	

func _on_animation_finished(anim_name:String = ""):
	if anim_name == "clean_up_intro":
		print("trying to clean up")
		intro_finished.emit()

