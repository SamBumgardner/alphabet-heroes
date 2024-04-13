extends Label

@export var job_to_display : Hero.Job

var hero_class_name

func _ready():
	hero_class_name = Hero.Job.keys()[job_to_display]
	_on_hero_repository_contents_changed([{},{},{},{}])

func _on_hero_repository_contents_changed(current_repository):
	var letter_list = current_repository[job_to_display].keys()
	text = "%s:\n" % hero_class_name
	for letter in letter_list:
		text += "%s, " % letter
