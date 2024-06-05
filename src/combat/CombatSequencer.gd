class_name CombatSequencer extends Node

signal combat_started()
signal combat_finished()
signal player_windup(duration: float)
signal player_impact(duration: float)
signal player_skipped()
signal enemy_windup(duration: float)
signal enemy_impact(duration: float)
signal gameover_victory_started(duration: float)
signal gameover_victory_finished(duration: float)
signal gameover_defeat_started(duration: float)
signal gameover_defeat_finished(duration: float)

var duration_player_windup: float = 2
var duration_player_impact: float = 1
var duration_player_skip: float = 1

var duration_enemy_windup: float = .5
var duration_enemy_impact: float = 1

var duration_gameover_victory: float = 1.5
var duration_gameover_defeat: float = 1.5

var player_defeated: bool = false
var enemy_defeated: bool = false

func _on_player_defeated():
	player_defeated = true

func _on_enemy_defeated():
	enemy_defeated = true

func _on_player_ready_to_act(word: String, remaining_word_count: int):
	start_combat_sequence(word == "", remaining_word_count)

func start_combat_sequence(player_inactive: bool=false, remaining_word_count: int=0):
	combat_started.emit()
	
	var tween = create_tween()
	if player_inactive:
		player_skipped.emit(duration_player_skip)
		tween.tween_interval(duration_player_skip)
	else: # Player did something
		player_windup.emit(duration_player_windup)
		tween.tween_interval(duration_player_windup)
		tween.tween_callback(emit_signal.bind("player_impact", duration_player_impact))
		tween.tween_interval(duration_player_impact)

	# universal wrap-up	
	if remaining_word_count <= 0:
		tween.tween_callback(start_enemy_sequence)
	else:
		tween.tween_callback(end_combat_sequence)

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
	if player_defeated:
		gameover_defeat_started.emit(duration_gameover_defeat)
		var tween = create_tween()
		tween.tween_interval(duration_gameover_defeat)
		tween.tween_callback(emit_signal.bind("gameover_defeat_finished"))
		player_defeated = false
		enemy_defeated = false
		return true

	if enemy_defeated:
		gameover_victory_started.emit(duration_gameover_victory)
		var tween = create_tween()
		tween.tween_interval(duration_gameover_victory)
		tween.tween_callback(emit_signal.bind("gameover_victory_finished"))
		player_defeated = false
		enemy_defeated = false
		return true

	# return true if either sequence was started, otherwise false.
	return false
