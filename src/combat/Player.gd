class_name Player extends Combatant

signal player_defeated()
signal player_ready_to_act(word: String, remaining_word_count: int)

@export var max_words_per_turn: int = 3
@export var words_remaining_this_turn = 0

func _on_party_activated(party: Party):
	add_block(party.combat_totals[CombatValues.Values.BLOCK])
	apply_healing(party.combat_totals[CombatValues.Values.HEAL])
	Database.set_player_health_current(current_health)
	print(self)

func _on_enemy_activated(enemy_action: EnemyAction):
	apply_damage(enemy_action.get_combat_totals()[CombatValues.Values.ATTACK], false)
	apply_damage(enemy_action.get_combat_totals()[CombatValues.Values.MAGIC], true)
	Database.set_player_health_current(current_health)
	print(self)

func _on_combat_finished():
	if words_remaining_this_turn == 0:
		_end_of_turn_cleanup()

func _defeated():
	player_defeated.emit()

func _on_word_submitted(word: String):
	words_remaining_this_turn -= 1
	player_ready_to_act.emit(word, words_remaining_this_turn)

func _to_string():
	return "Player stats: " + super()

func _end_of_turn_cleanup():
	words_remaining_this_turn = max_words_per_turn
	remove_block()

func _on_combat_nodes_hidden():
	var progression: PlayerProgressionChange = Database.get_progression_applied_before_enemy()
	apply_progression(progression)

func apply_progression(progression: PlayerProgressionChange):
	max_health += progression.max_health_increase
	apply_healing(progression.health_recovered + progression.max_health_increase)
