class_name EnemyActionSelector extends RefCounted

var enemy : Enemy

func _init(owning_enemy:Enemy = null):
	enemy = owning_enemy

func get_next_action() -> EnemyAction:
	return EnemyAction.new()
