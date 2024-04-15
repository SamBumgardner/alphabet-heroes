class_name PlayerProgressionChange extends RefCounted

var summon_batch_size_increase : int = 0
var summon_end_of_turn_increase : int = 0
var max_letters_increase : int = 0
var max_health_increase : int = 0
var health_recovered : int = 0

func _init(batch_increase:int = 0, end_of_turn_increase:int = 0, letters_increase:int = 0,
		max_health:int = 0, healing:int = 0):
	summon_batch_size_increase = batch_increase
	summon_end_of_turn_increase = end_of_turn_increase
	max_letters_increase = letters_increase
	max_health_increase = max_health
	health_recovered = healing

func _to_string():
	var result = ""
	if summon_batch_size_increase != 0: 
		result += "Summon Count: +%s\n" % summon_batch_size_increase
	if summon_end_of_turn_increase != 0: 
		result += "Passive Summons: +%s\n" % summon_end_of_turn_increase
	if max_letters_increase != 0:
		result += "Party Size: +%s\n" % max_letters_increase
	if max_health_increase != 0:
		result += "Max Health: +%s\n"
	if health_recovered != 0:
		result += "Healed: %s\n"
	return result
