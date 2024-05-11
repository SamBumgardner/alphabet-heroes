extends Control

var just_unlocked_hard_mode : bool = false 

func _ready():
	if not Database.player_beaten_normal:
		Database.set_player_beaten_normal(true)
		just_unlocked_hard_mode = true

func optional_unlock_notification():
	if just_unlocked_hard_mode:
		$UnlockNotification.pop_up()
