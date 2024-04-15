# Play background music triggered by signals.
extends Node

@export var background_music_calm_short : AudioStream
@export var background_music_default : AudioStream

@export var sfx_button_click : AudioStream
@export var sfx_button_hover : AudioStream
@export var sfx_button_summon : AudioStream
@export var sfx_combat_player_windup : AudioStream

const _default_audio_crossfade = 0.1

func _ready():
	SoundManager.set_ambient_sound_volume(0.5)
	SoundManager.set_music_volume(0.5)
	SoundManager.set_sound_volume(0.5)

#region Scene arrival

func _on_gameplay_ready():
	# Check to skip crossfade if this is the first song being played.
	if not SoundManager.is_music_playing():
		SoundManager.play_music(background_music_default)
		return

	SoundManager.stop_music(_default_audio_crossfade)
	SoundManager.play_music(background_music_default, _default_audio_crossfade)

func _on_start_menu_ready():
	# Check to stay silent if the game is still starting up.
	if not SoundManager.is_music_playing():
		return

	SoundManager.stop_music(_default_audio_crossfade)
	SoundManager.play_music(
		background_music_calm_short,
		_default_audio_crossfade
	)

#endregion Scene arrival

#region Button mouse entered

func _on_credits_button_mouse_entered():
	SoundManager.play_ui_sound(sfx_button_hover)

func _on_exit_button_mouse_entered():
	SoundManager.play_ui_sound(sfx_button_hover)

func _on_quit_button_mouse_entered():
	SoundManager.play_ui_sound(sfx_button_hover)

func _on_start_button_mouse_entered():
	SoundManager.play_ui_sound(sfx_button_hover)

func _on_summon_new_heroes_button_mouse_entered():
	SoundManager.play_ui_sound(sfx_button_hover)

#endregion Button mouse entered

#region Button press

func _on_credits_button_pressed():
	SoundManager.play_ui_sound(sfx_button_click)

func _on_exit_button_pressed():
	SoundManager.play_ui_sound(sfx_button_click)

func _on_summon_new_heroes_button_pressed():
	SoundManager.play_ui_sound(sfx_button_summon)

#endregion Button press

func _on_combat_sequencer_player_impact(duration):
	SoundManager.stop_ambient_sound(sfx_combat_player_windup, 0.9)

func _on_combat_sequencer_player_windup(duration):
	SoundManager.play_ambient_sound(sfx_combat_player_windup)
