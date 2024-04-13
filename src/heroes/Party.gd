class_name Party extends RefCounted

var heroes : Array:
	set(value):
		heroes = value
		combat_totals = calculate_combat_totals(heroes)

var combat_totals : Array

func _init(hero_input):
	heroes = hero_input

func calculate_combat_totals(input_heroes) -> Array:
	var num_values = CombatValues.Values.size()
	var totals = Array()
	totals.resize(num_values)
	totals.fill(0)

	for hero in input_heroes:
		for i in range(num_values):
			totals[i] += CombatValues.JOB_VALUES[hero.job][i]
	
	return totals

func _to_string():
	var result_string = "Party:\n"
	for hero in heroes:
		result_string += "  %s\n" % hero
	return result_string
