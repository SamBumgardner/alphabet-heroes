extends EnemyActionSelector

var small_actions = [
	preload("res://assets/data/enemy/rat_swarm/rat_small_0.tres"),
	preload("res://assets/data/enemy/rat_swarm/rat_small_1.tres"),
]
var big_actions = [
	preload("res://assets/data/enemy/rat_swarm/rat_big_0.tres"),
	preload("res://assets/data/enemy/rat_swarm/rat_big_1.tres"),
]

var turns_per_phase = 2
var current_phase = 0
var current_turn = 0

func get_next_action() -> EnemyAction:
	var result : EnemyAction
	if current_phase == 0:
		result = small_actions.pick_random()
	else:
		result = big_actions.pick_random()
	
	current_turn = (current_turn + 1) % 2
	if current_turn == 0:
		current_phase = (current_phase + 1) % 2
	
	return result

