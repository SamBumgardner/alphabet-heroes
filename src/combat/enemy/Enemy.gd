class_name Enemy extends Combatant

signal enemy_defeated()
signal action_changed(action:EnemyAction)
signal enemy_activated(action:EnemyAction)
signal enemy_reinitialized()

@export var enemy_data : EnemyData
var action_selector : EnemyActionSelector
var current_action : EnemyAction

func _ready():
	if enemy_data != null:
		_initialize_enemy(enemy_data)

func _initialize_enemy(enemy_data_in:EnemyData):
	enemy_data = enemy_data_in
	max_health = enemy_data.max_health
	current_health = enemy_data.max_health
	current_block = 0
	action_selector = enemy_data.action_selector_class.new(self)
	current_action = action_selector.get_next_action()
	healed.emit(current_health, current_health)
	block_decreased.emit(current_block, current_block)
	action_changed.emit(current_action)
	enemy_reinitialized.emit()

func _on_party_activated(party:Party):
	apply_damage(party.combat_totals[CombatValues.Values.ATTACK], false)
	apply_damage(party.combat_totals[CombatValues.Values.MAGIC], true)
	print(self)
	
func _on_enemy_impact(_duration:float):
	_perform_combat_action.call_deferred()

func _on_enemy_activated(enemy_action:EnemyAction):
	add_block(enemy_action.get_combat_totals()[CombatValues.Values.BLOCK])
	apply_healing(enemy_action.get_combat_totals()[CombatValues.Values.HEAL])

func _perform_combat_action():
	print("Performing action ", current_action)
	enemy_activated.emit(current_action)
	_on_enemy_activated(current_action)

func _on_combat_finished():
	current_action = action_selector.get_next_action()
	action_changed.emit(current_action)

func _defeated():
	enemy_defeated.emit()

func _to_string():
	return "Enemy stats: " + super()
