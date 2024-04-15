extends VBoxContainer

@export var enemy : Enemy

@onready var portrait : TextureRect = $TextureRect
var portrait_start_position : Vector2

func _ready():
	enemy.enemy_reinitialized.connect(_on_enemy_reinitialized)
	$TextureRect.texture = enemy.enemy_data.graphic
	$Label.text = enemy.enemy_data.name

func _on_enemy_reinitialized():
	$TextureRect.texture = enemy.enemy_data.graphic
	$TextureRect.self_modulate = Color.WHITE
	$Label.text = enemy.enemy_data.name

func _on_enemy_enrage_changed(is_enraged:bool):
	var was_enraged : bool = $TextureRect.self_modulate != Color.WHITE
	$TextureRect.self_modulate = Color.PALE_VIOLET_RED if is_enraged else Color.WHITE

	if is_enraged and not was_enraged:
		portrait_start_position = portrait.position
		var text_shake_tween = create_tween()
		text_shake_tween.tween_method(shake, 0, 0, .1)
		text_shake_tween.tween_property(portrait, "position", portrait_start_position, 0)

func shake(_value : float):
	portrait.position = portrait_start_position + (Vector2.ONE.rotated(randf_range(0, 6.29)) * 2)
