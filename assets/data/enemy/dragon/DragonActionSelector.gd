extends EnemyActionSelector

var actions = [
	preload("dragon_small_attack.tres"),
	preload("dragon_small_magic.tres"),
	preload("dragon_medium_attack_and_magic.tres"),
	preload("dragon_big_magic.tres")
]

const dragon_flying_refill = [
	1, 2, 3, 1, 2, 3,
]
const dragon_grounded_refill = [
	0, 1, 2, 0, 1, 2,
]
var action_options = [
	0,
]

var flying_retreat_action = preload("dragon_flying_retreat.tres")

var sequence_index = 0
var is_flying : bool = false

# Use 2-bag randomization strategy to cycle between options
# bag upgrades after dragon runs away
func get_next_action() -> EnemyAction:
	var result : EnemyAction
	if enemy.current_health < enemy.max_health / 2 and not is_flying:
		is_flying = true
		enemy.change_enraged(true)
		return flying_retreat_action
	
	var choice_index = randi_range(0, action_options.size() - 1) 
	result = actions[action_options[choice_index]]
	action_options.remove_at(choice_index)
	if action_options.is_empty():
		if is_flying:
			action_options.append_array(dragon_flying_refill)
		else:
			action_options.append_array(dragon_grounded_refill)

	return result
