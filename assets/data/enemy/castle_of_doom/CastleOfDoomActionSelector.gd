extends EnemyActionSelector

var actions = [
	preload("castle_small_both.tres"),
	preload("castle_medium_both.tres"),
	preload("castle_scaling_both.tres"),
	preload("castle_medium_attack.tres"),
	preload("castle_big_attack.tres"),
	preload("castle_big_magic.tres"),
	preload("castle_hasty_fortifications.tres"),
]

const seige_broken_refill = [
	3, 4, 5, 6, 6
]
var action_options = [
	3, 4, 5, 6, 6
]

var start_of_combat : bool = true
var gates_broken : bool = false
var initial_fortification_action : EnemyAction = preload("castle_initial_fortification.tres")
var broken_gates_action : EnemyAction = preload("castle_broken_gates.tres")

const opening_sequence_length = 3
var current_sequence_i = 0

# Use 2-bag randomization strategy to cycle between options
# bag upgrades after dragon runs away
func get_next_action() -> EnemyAction:
	var result : EnemyAction
	if start_of_combat:
		start_of_combat = false
		return initial_fortification_action
	
	if enemy.current_block <= 0 and not gates_broken:
		gates_broken = true
		return broken_gates_action
	
	if not gates_broken:
		result = actions[current_sequence_i]
		current_sequence_i = (current_sequence_i + 1) % opening_sequence_length
		if current_sequence_i == 0: # just finished a loop
			(actions[2] as EnemyAction).attack += 5
			(actions[2] as EnemyAction).magic += 5
		return result
	
	else:
		var choice_index = randi_range(0, action_options.size() - 1) 
		result = actions[action_options[choice_index]]
		action_options.remove_at(choice_index)
		if action_options.is_empty():
			action_options.append_array(seige_broken_refill)
		return result
