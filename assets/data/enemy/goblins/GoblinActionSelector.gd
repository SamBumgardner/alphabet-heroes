extends EnemyActionSelector

var actions = {
	"small_attack": preload("res://assets/data/enemy/goblins/goblin_small_attack.tres"),
	"big_attack": preload("res://assets/data/enemy/goblins/goblin_big_attack.tres"),
	"defense": preload("res://assets/data/enemy/goblins/goblin_defense.tres"),
}
var action_sequence = [
	"small_attack",
	"small_attack",
	"defense",
	"big_attack",
]
var current_sequence_index = 0

func get_next_action() -> EnemyAction:
	var next_action_key = action_sequence[current_sequence_index]
	var next_action = actions[next_action_key]
	current_sequence_index = (current_sequence_index + 1) % action_sequence.size()
	return next_action
