extends Control

@export var job_to_display : Hero.Job

@export var portrait_to_display : CompressedTexture2D

@onready var label_of_job : Label = (
	$MarginContainer/HBoxContainer/HeroStatistics/LabelOfJob
)
@onready var hero_portrait : TextureRect = (
	$MarginContainer/HBoxContainer/HeroPortrait
)
@onready var heroes_as_letter_names : RichTextLabel = (
	$MarginContainer/HBoxContainer/HeroStatistics/HeroesAsLetterNames
)
@onready var help_panel : Panel = (
	$MarginContainer/HBoxContainer/HeroPortrait/HelpPanel
)
@onready var combat_value_preview : CombatPreview = (
	$MarginContainer/HBoxContainer/HeroPortrait/CombatValuePreview
)

func _ready():
	combat_value_preview._set_icon_combat_values(
		CombatValues.JOB_VALUES[job_to_display]
	)
	var hero_class_name : String = Hero.Job.keys()[job_to_display]

	label_of_job.text = _build_hero_class_name_label(hero_class_name)

	hero_portrait.texture = portrait_to_display

	heroes_as_letter_names.text = ""

func set_heroes_as_letter_names_text(letter_names: String) -> void:
	heroes_as_letter_names.text = letter_names

func _build_hero_class_name_label(hero_class_name: String) -> String:
	return (
		hero_class_name.to_pascal_case()
		+ ":"
	)

func _on_hero_portrait_mouse_entered():
	help_panel.hide()
	combat_value_preview.show()

func _on_hero_portrait_mouse_exited():
	help_panel.show()
	combat_value_preview.hide()
