class_name HeroRepository extends Node

const LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var GENERATE_BATCH_SIZE = 8
var GENERATE_START_FIGHT = 6
var GENERATE_END_OF_TURN_SIZE = 2

signal hero_repository_contents_changed(current_repository)

# Array of Dictionaries - one dict for each non-peasant hero job
var _repository : Array
var _available_letters : Dictionary

func _init():
	_repository = Array()
	for i in range(Hero.Job.size() - 1): # exclude the peasants
		_repository.append({})
	_available_letters = {}
	for letter in LETTERS:
		_available_letters[letter] = true

func _ready():
	reset.call_deferred()

func reset():
	_repository = Array()
	for i in range(Hero.Job.size() - 1): # exclude the peasants
		_repository.append({})
	_available_letters = {}
	for letter in LETTERS:
		_available_letters[letter] = true
	
	generate_heroes(GENERATE_START_FIGHT)
	hero_repository_contents_changed.emit(_repository)

func add(heroes:Array):
	for hero : Hero in heroes:
		_repository[hero.job][hero.letter] = true
		_available_letters.erase(hero.letter)
	hero_repository_contents_changed.emit(_repository)

func remove(letters:String):
	for letter in letters:
		for dict : Dictionary in _repository:
			dict.erase(letter)
			_available_letters[letter] = true
	hero_repository_contents_changed.emit(_repository)

func get_heroes(letters:String) -> Array:
	var result = []
	var processed_letters = ""
	for letter in letters:
		var hero : Hero = null
		if not processed_letters.contains(letter):
			for job in range(_repository.size()):
				var dict = _repository[job]
				if dict.has(letter):
					hero = Hero.new(letter, job)
					break;
		if hero == null:
			hero = Hero.new(letter, Hero.Job.PEASANT)
		result.append(hero)
		processed_letters += letter
	
	return result

func generate_heroes_end_of_turn():
	generate_heroes(GENERATE_END_OF_TURN_SIZE)

func generate_heroes_batch():
	generate_heroes(GENERATE_BATCH_SIZE)

func generate_heroes(count_to_generate : int):
	var new_heroes = []
	for i in range(min(count_to_generate, _available_letters.size())):
		var hero = Hero.new(
			_available_letters.keys().pick_random(), 
			Hero.random_job()
		)
		_available_letters.erase(hero.letter)
		new_heroes.append(hero)
	
	add(new_heroes)

func _on_combat_nodes_hidden():
	var progression : PlayerProgressionChange = Database.get_progression_applied_before_enemy()
	GENERATE_BATCH_SIZE += progression.summon_batch_size_increase
	GENERATE_START_FIGHT += progression.summon_batch_size_increase
	GENERATE_END_OF_TURN_SIZE += progression.summon_end_of_turn_increase
