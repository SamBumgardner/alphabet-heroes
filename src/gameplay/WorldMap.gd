class_name WorldMap extends TextureRect

const TRAVEL_TIME = 5

var travel_tween : Tween

func _ready():
	pass

func _set_new_travel_tween(target_position:Vector2):
	if travel_tween != null and travel_tween.is_valid():
		travel_tween.stop()
	
	travel_tween = create_tween()
	travel_tween.set_ease(Tween.EASE_IN_OUT)
	travel_tween.set_trans(Tween.TRANS_CUBIC)
	travel_tween.tween_property(self, "position", target_position, TRAVEL_TIME)

func reset_scale_tween():
	var scale_tween = create_tween()
	scale_tween.set_ease(Tween.EASE_IN_OUT)
	scale_tween.set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE, TRAVEL_TIME)

func add_travel_tween_steps(tween_to_modify:Tween, target_position:Vector2):
	tween_to_modify.set_ease(Tween.EASE_IN_OUT)
	tween_to_modify.set_trans(Tween.TRANS_CUBIC)
	tween_to_modify.tween_property(self, "position", target_position, TRAVEL_TIME)

func jump_to_destination(target_position:Vector2):
	scale = Vector2.ONE
	position = target_position
