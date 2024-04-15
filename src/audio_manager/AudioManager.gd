# Play background music triggered by signals.
extends Node

@export var background_music_calm_short : AudioStream
@export var background_music_default : AudioStream

@export var sfx_button_pressed : AudioStream

const _default_audio_crossfade = 0.1

func _ready():
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

#region Button press

func _on_credits_button_pressed():
	SoundManager.play_sound(sfx_button_pressed)

#endregion Button press
