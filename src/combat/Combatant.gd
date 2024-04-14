class_name Combatant extends Node

signal hurt(previous_health:int, new_health:int)
signal healed(previous_health:int, new_health:int)
signal block_increased(previous_block:int, new_block:int)
signal block_decreased(previous_block:int, new_block:int)
signal block_removed(previous_block:int, new_block:int)

@export var max_health : int = 50
@export var current_health : int = 50
@export var current_block : int = 0

# emit block_decreased, hurt, trigger defeated logic
func apply_damage(damage:int, is_magic:bool):
	if damage <= 0:
		return

	var unmitigated_damage = damage
	if current_block > 0 and not is_magic:
		var old_block = current_block
		current_block -= min(unmitigated_damage, old_block)
		unmitigated_damage -= old_block
		block_decreased.emit(old_block, current_block)
	
	if unmitigated_damage > 0:
		var old_health = current_health
		current_health -= unmitigated_damage
		hurt.emit(old_health, current_health)
		if old_health > 0 and current_health <= 0:
			_defeated()

# emit block_increased
func add_block(additional_block:int):
	if additional_block <= 0:
		return
	
	var old_block = current_block
	current_block += additional_block
	block_increased.emit(old_block, current_block)

func remove_block():
	if current_block <= 0:
		return
	
	var old_block = current_block
	current_block = 0
	block_removed.emit(old_block, current_block)

# emit healed
func apply_healing(healing:int):
	if healing <= 0:
		return
	
	var old_health = current_health
	current_health += min(healing, max_health - old_health)
	healed.emit(old_health, current_health)

# abstract method, child classes should decide what happens when defeated
func _defeated():
	pass

func _to_string():
	return "Health: %s/%s, Block: %s" % [current_health, max_health, current_block]
