extends Combatant

signal player_defeated()

func _on_party_activated(party:Party):
    add_block(party.combat_totals[CombatValues.Values.BLOCK])
    apply_healing(party.combat_totals[CombatValues.Values.HEAL])
    print(self)

func _defeated():
    player_defeated.emit()

func _to_string():
    return "Player stats: " + super()