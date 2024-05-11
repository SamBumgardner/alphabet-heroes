extends EnemyActionSelector

var heal_action = preload("res://assets/data/enemy/normal_mode/skeleton_king/skeleton_king_revive.tres")
var normal_actions = {
	"small_attack": preload("skeleton_king_small_attack_normal.tres"),
	"medium_attack": preload("skeleton_king_medium_attack_normal.tres"),
	"fortify": preload("skeleton_king_fortify_normal.tres"),
	"big_attack": preload("skeleton_king_big_attack_normal.tres"),
}
var post_heal_actions = {
	"small_attack": preload("skeleton_king_small_attack_enrage.tres"),
	"medium_attack": preload("skeleton_king_medium_attack_enrage.tres"),
	"fortify": preload("skeleton_king_fortify_enrage.tres"),
	"big_attack": preload("skeleton_king_big_attack_enrage.tres"),
}

var action_sequence = [
	"medium_attack",
	"small_attack",
	"fortify",
	"medium_attack",
	"small_attack",
	"big_attack",
]
var sequence_index = 0
var has_healed : bool = false

# if player's healthy, use 2-bag randomization strategy to cycle between options
# if player's unhealthy, run set sequence of magic-based attacks.
func get_next_action() -> EnemyAction:
	var result : EnemyAction
	if enemy.current_health < enemy.max_health / 2 and not has_healed:
		has_healed = true
		enemy.change_enraged(true)
		return heal_action
	
	var current_action_dict : Dictionary
	if not has_healed:
		current_action_dict = normal_actions
	else:
		# it'd be nice to more clearly signal to the player that its state has changed.
		current_action_dict = post_heal_actions
	
	result = current_action_dict[action_sequence[sequence_index]]
	sequence_index = (sequence_index + 1) % action_sequence.size()

	return result
