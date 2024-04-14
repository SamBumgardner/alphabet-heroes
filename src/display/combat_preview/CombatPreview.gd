class_name CombatPreview extends HBoxContainer

@onready var icons : Array = [
	$CombatValueIcon,
	$CombatValueIcon2,
	$CombatValueIcon3,
	$CombatValueIcon4,
]

func _on_party_changed(new_party:Party):
	var combat_totals = new_party.combat_totals
	_set_icon_combat_values(combat_totals)

func _on_action_changed(new_action:EnemyAction):
	var combat_totals = new_action.get_combat_totals();
	_set_icon_combat_values(combat_totals)

func _set_icon_combat_values(combat_values:Array):
	for i in range(combat_values.size()):
		icons[i].set_combat_value(combat_values[i])
