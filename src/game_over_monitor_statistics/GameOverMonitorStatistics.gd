extends Node

@onready var database = get_node("/root/Database")

# Remember previous dictionary of heroes for counting newly summoned heroes.
var hero_repository_previous : Array

func _ready():
	hero_repository_previous = []

func _on_hero_repository_hero_repository_contents_changed(current_repository):
	_increase_statistic_heroes_summoned(current_repository)

# Count the increase in available heroes for each column, ignoring decreases.
func _increase_statistic_heroes_summoned(current_repository : Array) -> void:
	var current_repository_size = current_repository.size()

	var heroes_summoned_count_increase = 0

	for hero_job_index in current_repository_size:
		var current_section_hero_count_previous = 0

		if hero_job_index < hero_repository_previous.size():
			current_section_hero_count_previous = (
				hero_repository_previous[hero_job_index].size()
			)

		var current_section_hero_count_current = current_repository[
			hero_job_index
		].size()
		
		var current_section_hero_count_increase = max(
			0,
			(
				current_section_hero_count_current
				- current_section_hero_count_previous
			)
		)
		heroes_summoned_count_increase += current_section_hero_count_increase

	hero_repository_previous = current_repository.duplicate(true)

	database.set_heroes_summoned_count(
		database.heroes_summoned_count
		+ heroes_summoned_count_increase
	)

func _on_text_controller_word_submitted(word):
	_increase_statistic_peasants_conscripted(word)

func _increase_statistic_peasants_conscripted(word : String) -> void:
	var peasants_within_word = _count_peasants(word)
	database.set_peasants_conscripted_count(
		database.peasants_conscripted_count
		+ peasants_within_word
	)

# Count how many peasants are in a word.
# Partially copied from HeroRepository method _get_heroes.
# To Do: Replace for DRY code principles.
func _count_peasants(letters : String) -> int:
	var result = 0
	var processed_letters = ""
	for letter in letters:
		var hero : Hero = null
		if not processed_letters.contains(letter):
			for job in range(hero_repository_previous.size()):
				var dict = hero_repository_previous[job]
				if dict.has(letter):
					hero = Hero.new(letter, job)
					break;
		if hero == null:
			result += 1
			hero = Hero.new(letter, Hero.Job.PEASANT)
		processed_letters += letter

	return result
