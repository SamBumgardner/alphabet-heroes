class_name EnemyAction extends Resource

@export var attack : int = 0;
@export var block : int = 0;
@export var magic : int = 0;
@export var heal : int = 0;

# get the above data in the standard "combat_totals" format used by player party.
func get_combat_totals() -> Array:
	return [
		attack,
		block,
		magic,
		heal
	]

func _to_string():
	var combat_totals = get_combat_totals()
	var result = "Enemy Action:\n"
	for i in range(combat_totals.size()):
		result += "%s: %s,\n" % [CombatValues.Values.keys()[i], combat_totals[i]]
	return result
