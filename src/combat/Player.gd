class_name Player extends Combatant

signal player_defeated()

func _on_party_activated(party:Party):
	add_block(party.combat_totals[CombatValues.Values.BLOCK])
	apply_healing(party.combat_totals[CombatValues.Values.HEAL])
	print(self)

func _on_enemy_activated(enemy_action:EnemyAction):
	apply_damage(enemy_action.get_combat_totals()[CombatValues.Values.ATTACK], false)
	apply_damage(enemy_action.get_combat_totals()[CombatValues.Values.MAGIC], true)
	print(self)

func _on_combat_finished():
	remove_block.call_deferred()

func _defeated():
	player_defeated.emit()

func _to_string():
	return "Player stats: " + super()
