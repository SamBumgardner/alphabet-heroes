extends TextureRect

@onready var start_position : Vector2 = position
var _animating_tween : Tween
var _bottom_margin : float = 0
var _right_margin : float = 0

func _ready():
	_animating_tween = _create_bounce_tween()
	visibility_changed.connect(_reset_tween)

func recalculate_margins(new_background : NinePatchRect):
	_bottom_margin = new_background.patch_margin_bottom
	_right_margin = new_background.patch_margin_right
	reset_margins()

func reset_margins():
	const MARGIN_COEFFICIENT = .5
	for side in range(4):
		var anchor_value : float
		var anchor_offset : int
		match side:
			SIDE_BOTTOM:
				anchor_offset = MARGIN_COEFFICIENT * -1 * _bottom_margin
				anchor_value = 1
			SIDE_RIGHT:
				anchor_offset = MARGIN_COEFFICIENT * -1 * _right_margin
				anchor_value = 1
			SIDE_LEFT:
				anchor_offset = 0
				anchor_value = 1
			SIDE_TOP:
				anchor_offset = 0
				anchor_value = 1
		set_anchor_and_offset(side, anchor_value, anchor_offset)
	
	_animating_tween = _create_bounce_tween()

func _reset_tween() -> void:
	position = start_position
	if _animating_tween:
		_animating_tween.stop()
		_animating_tween.play()

func _create_bounce_tween() -> Tween:
	const BOUNCE_DURATION = .5
	
	if _animating_tween:
		_animating_tween.kill()
	
	start_position = position
	var bounce_distance = Vector2(0, -1 * offset_bottom)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", start_position + bounce_distance, BOUNCE_DURATION)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", start_position, BOUNCE_DURATION)
	tween.set_loops(-1)
	return tween

func _set(property, value):
	if property == "texture":
		var new_size = value.get_size()
		texture = value
		size = value.get_size()
		reset_margins()
		return true
	return false

func _on_visibility_changed():
	if !visible and _animating_tween:
		_animating_tween.stop()
	else:
		_reset_tween()
