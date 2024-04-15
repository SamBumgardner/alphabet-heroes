extends EnemyActionSelector

var player_healthy_actions = [
	preload("res://assets/data/enemy/giant_spider/giant_spider_attack_and_block.tres"),
	preload("res://assets/data/enemy/giant_spider/giant_spider_big_attack.tres"),
	preload("res://assets/data/enemy/giant_spider/giant_spider_block_and_heal.tres")
]
var player_hurt_actions = {
	"small_magic_and_heal": preload("res://assets/data/enemy/giant_spider/giant_spider_small_magic_and_heal.tres"),
	"medium_magic_and_heal": preload("res://assets/data/enemy/giant_spider/giant_spider_medium_magic_and_heal.tres"),
	"nothing": preload("res://assets/data/enemy/giant_spider/giant_spider_nothing.tres"),
	"big_magic": preload("res://assets/data/enemy/giant_spider/giant_spider_big_magic.tres"),
}

const player_healthy_choice_refill = [
	0, 1, 2, 0, 1, 2,
]
var player_healthy_choice_options = [
	0, 0,
]

var player_hurt_sequence = [
	"small_magic_and_heal",
	"medium_magic_and_heal",
	"nothing",
	"big_magic",
	"nothing",
]
var player_hurt_sequence_index = 0

# if player's healthy, use 2-bag randomization strategy to cycle between options
# if player's unhealthy, run set sequence of magic-based attacks.
func get_next_action() -> EnemyAction:
	var result : EnemyAction
	if Database.player_health_current >= 30:
		player_hurt_sequence_index = 0
		var choice_index = randi_range(0, player_healthy_choice_options.size() - 1) 
		result = player_healthy_actions[player_healthy_choice_options[choice_index]]
		player_healthy_choice_options.remove_at(choice_index)
		if player_healthy_choice_options.is_empty():
			player_healthy_choice_options.append_array(player_healthy_choice_refill)
	else:
		# it'd be nice to more clearly signal to the player that its state has changed.
		result = player_hurt_actions[player_hurt_sequence[player_hurt_sequence_index]]
		player_hurt_sequence_index += 1

	return result
