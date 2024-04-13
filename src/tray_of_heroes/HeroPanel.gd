extends PanelContainer

@export var job_to_display : Hero.Job

@onready var label_of_job : Label = (
	$MarginContainer/HBoxContainer/HeroStatistics/LabelOfJob
)

var hero_class_name : String

func _ready():
	hero_class_name = Hero.Job.keys()[job_to_display]
	print(job_to_display)
	print(hero_class_name)
	label_of_job.text = _build_hero_class_name_label()

func _build_hero_class_name_label() -> String:
	return (
		hero_class_name.to_pascal_case()
		+ ":"
	)
