class_name AnimatedHeroDisplayer extends Node

@onready var animatable_heroes : Array = get_children()

var _current_party : Party

func _on_party_changed(new_party:Party):
	_current_party = new_party

func _on_summon_hero_positions(summon_positions:Array):
	if summon_positions.size() != _current_party.heroes.size():
		push_error("ERROR: summon position count and heroes in party do not match")
		return
	
	for i in range(animatable_heroes.size()):
		var animatable_hero = animatable_heroes[i] as AnimatedSprite2D
		if i < summon_positions.size():
			animatable_hero.show()
			animatable_hero.global_position = summon_positions[i]
			animatable_hero.play("summon")
		else:
			animatable_hero.hide()

func _on_player_windup(duration:float):
	pass # set up tweening logic here

func _on_player_impact(duration:float):
	for node in animatable_heroes:
		node.hide()
		
