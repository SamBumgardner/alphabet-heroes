# Play background music triggered by signals.
extends Node

@export var background_music_calm_short : AudioStream
@export var background_music_default : AudioStream

@export var sfx_button_click : AudioStream
@export var sfx_button_hover : AudioStream
@export var sfx_button_summon : AudioStream
@export var sfx_combat_enemy_current_windup : AudioStream
@export var sfx_combat_enemy_default_hurt : AudioStream
@export var sfx_combat_enemy_default_hurt_heavy : AudioStream
@export var sfx_combat_enemy_default_windup : AudioStream
@export var sfx_combat_player_hurt : AudioStream
@export var sfx_combat_player_windup : AudioStream

const _default_audio_crossfade = 0.1

const _enemy_default_hurt_heavy_threshold = 10

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

func _on_combat_sequencer_enemy_windup(_duration):
	# Check to play a default SFX if the enemy is missing a unique windup SFX.
	if sfx_combat_enemy_current_windup == null:
		SoundManager.play_ambient_sound(sfx_combat_enemy_default_windup)
		return

	SoundManager.play_ambient_sound(sfx_combat_enemy_current_windup)

func _on_combat_sequencer_player_impact(_duration):
	SoundManager.stop_ambient_sound(sfx_combat_player_windup, 0.9)

func _on_combat_sequencer_player_windup(_duration):
	SoundManager.play_ambient_sound(sfx_combat_player_windup)

func _on_enemy_enemy_reinitialized(enemy_data_in : EnemyData):
	# Populate the current enemy's SFX windup, will use a default if null.
	if enemy_data_in.sfx_windup != null:
		sfx_combat_enemy_current_windup = enemy_data_in.sfx_windup
	else:
		sfx_combat_enemy_current_windup = null

func _on_enemy_hurt(previous_health, new_health):
	# Check to play a heavy SFX if the enemy took at least a heavy
	#  amount of damage.
	if (
		(
			previous_health
			- _enemy_default_hurt_heavy_threshold
		) >= new_health
	):
		SoundManager.play_ambient_sound(sfx_combat_enemy_default_hurt_heavy)
		return

	SoundManager.play_ambient_sound(sfx_combat_enemy_default_hurt)

func _on_player_hurt(previous_health, new_health):
	SoundManager.play_ambient_sound(sfx_combat_player_hurt)
