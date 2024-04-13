extends Label

func _on_party_changed(new_party:Party):
	var result = "Combat Preview:\n"
	for i in range(new_party.combat_totals.size()):
		result += "  %s: %s\n" % [CombatValues.Values.keys()[i], new_party.combat_totals[i]]
	text = result
	modulate = Color.from_hsv(randf(), randf(), randf())
