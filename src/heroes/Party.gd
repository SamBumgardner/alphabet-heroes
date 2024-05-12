class_name Party extends RefCounted

static var use_new_combat_total_logic : bool = true

var heroes : Array:
	set(value):
		heroes = value
		combat_totals = calculate_combat_totals(heroes)

var combat_totals : Array

func _init(hero_input):
	heroes = hero_input

func calculate_combat_totals(input_heroes) -> Array:
	if !use_new_combat_total_logic:
		return combat_totals_old(input_heroes)
	else:
		return combat_totals_new(input_heroes)

func combat_totals_old(input_heroes) -> Array:
	var num_values = CombatValues.Values.size()
	var totals = Array()
	totals.resize(num_values)
	totals.fill(0)
	
	var leader_job = -1
	if input_heroes.size() > 0:
		leader_job = input_heroes[0].job
	for hero in input_heroes:
		var multiplier = 2 if leader_job == hero.job && hero.job != Hero.Job.PEASANT else 1
		for i in range(num_values):
			totals[i] += Database.JOB_VALUES[hero.job][i] * multiplier
	
	return totals

func combat_totals_new(input_heroes):
	return [1*input_heroes.size(), 2*input_heroes.size(), 0, 0]

func _to_string():
	var result_string = "Party:\n"
	for hero in heroes:
		result_string += "  %s\n" % hero
	return result_string
