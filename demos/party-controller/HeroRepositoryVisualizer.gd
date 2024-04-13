extends Label

@export var job_to_display : Hero.Job

func _ready():
	_on_hero_repository_contents_changed([{},{},{},{}])

func _on_hero_repository_contents_changed(current_repository):
	var letter_list = current_repository[job_to_display].keys()
	text = "%s:\n" % Hero.Job.keys()[job_to_display]
	for letter in letter_list:
		text += "%s, " % letter
