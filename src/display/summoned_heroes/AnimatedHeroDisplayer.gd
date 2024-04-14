class_name AnimatedHeroDisplayer extends Node

@export var charge_destination : Vector2 = Vector2(0, 0)

@onready var animatable_heroes : Array = get_children()

var _current_party : Party

func _on_party_changed(new_party:Party):
	_current_party = new_party

func _on_summon_hero_positions(summon_positions:Array):
	if summon_positions.size() != _current_party.heroes.size():
		push_error("ERROR: summon position count and heroes in party do not match")
		return
	
	for i in range(animatable_heroes.size()):
		var animatable_hero = animatable_heroes[i] as SummonedHero
		if i < summon_positions.size():
			animatable_hero.show()
			animatable_hero.global_position = summon_positions[i]
			animatable_hero.switch_graphic(_current_party.heroes[i].job)
			animatable_hero.play("summon")
		else:
			animatable_hero.hide()

func _on_player_windup(duration:float):
	var summon_animation_duration = .34
	var remaining_duration = duration - summon_animation_duration
	var fade_out_duration = .25
	
	for summoned_hero in animatable_heroes:
		var charge_tween = create_tween()
		charge_tween.tween_interval(summon_animation_duration)
		charge_tween.tween_callback(summoned_hero.play.bind("run"))
		charge_tween.set_ease(Tween.EASE_IN)
		charge_tween.set_trans(Tween.TRANS_CUBIC)
		charge_tween.tween_property(
			summoned_hero, 
			"global_position", 
			charge_destination + _generate_random_vector(), 
			remaining_duration - fade_out_duration
		)
		charge_tween.tween_property(
			summoned_hero, 
			"modulate", 
			Color.TRANSPARENT, 
			fade_out_duration
		)

func _generate_random_vector():
	return Vector2.ONE.rotated(randf_range(0, 6.29)) * randf_range(0, 50)

func _on_player_impact(duration:float):
	for node in animatable_heroes:
		node.hide()
		node.modulate = Color.WHITE
