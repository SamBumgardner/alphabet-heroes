extends Control

func _ready():
	$TitleLabel.text = Database.INTRO_TITLE
	$IntroText.text = Database.INTRO_TEXT
