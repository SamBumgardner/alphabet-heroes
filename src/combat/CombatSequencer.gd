class_name CombatSequencer extends Node

signal combat_started()
signal combat_finished()
signal player_windup(duration:float)
signal player_impact(duration:float)
signal enemy_windup(duration:float)
signal enemy_impact(duration:float)
signal gameover_victory(duration:float)
signal gameover_defeat(duration:float)

var duration_player_windup : float = 1.5
var duration_player_impact : float = 1.5

var duration_enemy_windup : float = 1.5
var duration_enemy_impact : float = 1.5

var duration_gameover_victory : float = 1.5
var duration_gameover_defeat : float = 1.5

func start_player_sequence():
	combat_started.emit()
	player_windup.emit(duration_player_windup)

	var tween = create_tween()
	tween.tween_interval(duration_player_windup)
	tween.tween_callback(emit_signal.bind("player_impact", duration_player_impact))
	tween.tween_interval(duration_player_impact)
	tween.tween_callback(start_enemy_sequence)

func start_enemy_sequence():
	if try_gameover_sequence():
		return # game's over, don't continue combat actions

	enemy_windup.emit(duration_enemy_windup)
	
	var tween = create_tween()
	tween.tween_interval(duration_enemy_windup)
	tween.tween_callback(emit_signal.bind("enemy_impact", duration_enemy_impact))
	tween.tween_interval(duration_enemy_impact)
	tween.tween_callback(end_combat_sequence)

func end_combat_sequence():
	if try_gameover_sequence():
		return # game's over, don't continue combat actions
	combat_finished.emit()

func try_gameover_sequence() -> bool:
	# if player defeated
	#  signal event to start appropriate sequence
	# elif player victorious
	#  signal event to start appropriate sequence

	# return true if either sequence was started, otherwise false.
	return false