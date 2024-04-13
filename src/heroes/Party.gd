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
        for i in num_values:
            totals[i] += CombatValues[hero.job][i]
    
    return totals
