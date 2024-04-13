extends Control

var hero_jobs_to_display = [
	Hero.Job.WARRIOR,
	Hero.Job.KNIGHT,
	Hero.Job.MAGE,
	Hero.Job.PRIEST
]

var dummy_value_to_initialize_empty_display_of_heroes = [{}, {}, {}, {}]

func _ready():
	_on_hero_repository_hero_repository_contents_changed(
		dummy_value_to_initialize_empty_display_of_heroes
	)

func _on_hero_repository_hero_repository_contents_changed(current_repository):
	for hero_job in hero_jobs_to_display:
		var heroes_as_letter_list = current_repository[hero_job].keys()

		# List single-letter names of heroes, comma-delimited.
		var debug_text = ""
		for hero_as_letter in heroes_as_letter_list:
			debug_text += "%s, " % hero_as_letter
		print(
			"TrayOfHeroes heard that column ",
			hero_job,
			" has heroes: ",
			debug_text
		)
