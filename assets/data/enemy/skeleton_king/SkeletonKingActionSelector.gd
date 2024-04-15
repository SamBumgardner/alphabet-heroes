extends EnemyActionSelector

var heal_action = preload("res://assets/data/enemy/skeleton_king/skeleton_king_revive.tres")
var normal_actions = {
	"small_attack": preload("res://assets/data/enemy/giant_spider/giant_spider_small_magic_and_heal.tres"),
	"medium_attack": preload("res://assets/data/enemy/giant_spider/giant_spider_medium_magic_and_heal.tres"),
	"fortify": preload("res://assets/data/enemy/giant_spider/giant_spider_nothing.tres"),
	"big_attack": preload("res://assets/data/enemy/giant_spider/giant_spider_big_magic.tres"),
}
var post_heal_actions = {
	"small_attack": preload("res://assets/data/enemy/giant_spider/giant_spider_small_magic_and_heal.tres"),
	"medium_attack": preload("res://assets/data/enemy/giant_spider/giant_spider_medium_magic_and_heal.tres"),
	"fortify": preload("res://assets/data/enemy/giant_spider/giant_spider_nothing.tres"),
	"big_attack": preload("res://assets/data/enemy/giant_spider/giant_spider_big_magic.tres"),
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
	if enemy.current_health < enemy.max_health / 2:
		has_healed = true
		return heal_action
	
	var current_action_dict : Dictionary
	if not has_healed:
		current_action_dict = normal_actions
	else:
		# it'd be nice to more clearly signal to the player that its state has changed.
		current_action_dict = post_heal_actions
	
	result = current_action_dict[action_sequence[sequence_index]]
	sequence_index += 1

	return result
