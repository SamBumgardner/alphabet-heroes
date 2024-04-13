class_name Enemy extends Combatant

signal enemy_defeated()

func _on_party_activated(party:Party):
	apply_damage(party.combat_totals[CombatValues.Values.ATTACK], false)
	apply_damage(party.combat_totals[CombatValues.Values.MAGIC], true)
	print(self)

func _defeated():
	enemy_defeated.emit()

func _to_string():
	return "Enemy stats: " + super()
