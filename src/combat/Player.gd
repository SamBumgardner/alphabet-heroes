class_name Player extends Combatant

signal player_defeated()

func _on_party_activated(party:Party):
	add_block(party.combat_totals[CombatValues.Values.BLOCK])
	apply_healing(party.combat_totals[CombatValues.Values.HEAL])
	Database.set_player_health_current(current_health)
	print(self)

func _on_enemy_activated(enemy_action:EnemyAction):
	apply_damage(enemy_action.get_combat_totals()[CombatValues.Values.ATTACK], false)
	apply_damage(enemy_action.get_combat_totals()[CombatValues.Values.MAGIC], true)
	Database.set_player_health_current(current_health)
	print(self)

func _on_combat_finished():
	remove_block()

func _defeated():
	player_defeated.emit()

func _to_string():
	return "Player stats: " + super()

func _on_combat_nodes_hidden():
	var progression : PlayerProgressionChange = Database.get_progression_applied_before_enemy()
	max_health += progression.max_health_increase
	apply_healing(progression.health_recovered + progression.max_health_increase)
