# Defines variables shared across scenes with the correct data types.
extends Node

const _initial_heroes_summoned_count : int = 0
const _initial_monsters_slain_count : int = 0
const _initial_peasants_constripted_count : int = 0
const _initial_player_health_maximum : int = 50

var heroes_summoned_count : int
var monsters_slain_count : int
var peasants_constripted_count : int
var player_health_current : int

func _ready():
	reset_values()

func reset_values() -> void:
	set_heroes_summoned_count(_initial_heroes_summoned_count)
	set_monsters_slain_count(_initial_monsters_slain_count)
	set_peasants_constripted_count(_initial_peasants_constripted_count)
	set_player_health_to_maximum()

func set_heroes_summoned_count(updated_count : int) -> void:
	heroes_summoned_count = updated_count

func set_monsters_slain_count(updated_count : int) -> void:
	monsters_slain_count = updated_count

func set_peasants_constripted_count(updated_count : int) -> void:
	peasants_constripted_count = updated_count

func set_player_health_current(updated_health : int) -> void:
	player_health_current = updated_health

func set_player_health_to_maximum() -> void:
	set_player_health_current(_initial_player_health_maximum)
