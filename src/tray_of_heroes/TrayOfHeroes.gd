extends Control

@onready var columns_of_panels = $MarginContainer/ColumnsOfPanels

var dummy_value_to_initialize_empty_display_of_heroes : Array = [
	{},
	{},
	{},
	{}
]

var hero_jobs_to_display : Array = [
	Hero.Job.WARRIOR,
	Hero.Job.KNIGHT,
	Hero.Job.MAGE,
	Hero.Job.PRIEST
]

func _ready():
	if (
		dummy_value_to_initialize_empty_display_of_heroes.size()
		!= hero_jobs_to_display.size()
	):
		push_warning("TrayOfHeroes has mismatching job counts on startup")

	_on_hero_repository_hero_repository_contents_changed(
		dummy_value_to_initialize_empty_display_of_heroes
	)

# Combine an array of strings into a comma-space delimited string.
func _join(string_array: Array) -> String:
	var joined_text = ""

	for string_item in string_array:
		joined_text += "%s, " % string_item

	# Remove trailing comma, if any.
	if joined_text != "":
		joined_text = joined_text.left(-2)

	return joined_text

func _on_hero_repository_hero_repository_contents_changed(current_repository):
	for panel in columns_of_panels.get_children():
		var heroes_as_letter_list = current_repository[
			panel.job_to_display
		].keys()

		panel.set_heroes_as_letter_names_text(_join(heroes_as_letter_list))
