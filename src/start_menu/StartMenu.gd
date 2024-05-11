extends Control

@onready var quit_button = (
	$Padding8px/TitleControlsRows/ButtonRows/QuitButton
)

func _ready():
	Database.reset_values()
	if OS.get_name() == "Web":
		quit_button.visible = false
	if !Database.player_beaten_normal:
		$Padding8px/TitleControlsRows/ButtonRows/HardMode.hide()

func _on_start_button_pressed():
	Database.set_difficulty_data(preload("res://assets/data/normal_mode.tres"))
	get_tree().change_scene_to_file("res://src/gameplay/Gameplay.tscn")

func _on_hard_mode_button_pressed():
	Database.set_difficulty_data(preload("res://assets/data/hard_mode.tres"))
	get_tree().change_scene_to_file("res://src/gameplay/Gameplay.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
