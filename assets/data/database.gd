# Defines variables shared across scenes with the correct data types.
extends Node

const _initial_enemy_index : int = 0
const _initial_heroes_summoned_count : int = 0
const _initial_monsters_slain_count : int = 0
const _initial_peasants_conscripted_count : int = 0
const _initial_player_health_maximum : int = 50

static var ENEMY_LIST = [
	preload("res://assets/data/enemy/rat_swarm/RatSwarmData.tres"),
	preload("res://assets/data/enemy/goblins/GoblinData.tres"),
	preload("res://assets/data/enemy/giant_spider/GiantSpider.tres"),
	preload("res://assets/data/enemy/dragon/Dragon.tres"),
	preload("res://assets/data/enemy/skeleton_king/SkeletonKing.tres"),
	preload("res://assets/data/enemy/castle_of_doom/CastleOfDoomData.tres")
]

var current_enemy_index : int
var heroes_summoned_count : int
var monsters_slain_count : int
var peasants_conscripted_count : int
var player_health_current : int

func _ready():
	reset_values()

func reset_values() -> void:
	set_current_enemy_index(_initial_enemy_index)
	set_heroes_summoned_count(_initial_heroes_summoned_count)
	set_monsters_slain_count(_initial_monsters_slain_count)
	set_peasants_conscripted_count(_initial_peasants_conscripted_count)
	set_player_health_to_maximum()

func set_current_enemy_index(updated_index : int) -> void:
	current_enemy_index = updated_index

func set_heroes_summoned_count(updated_count : int) -> void:
	heroes_summoned_count = updated_count

func set_monsters_slain_count(updated_count : int) -> void:
	monsters_slain_count = updated_count

func set_peasants_conscripted_count(updated_count : int) -> void:
	peasants_conscripted_count = updated_count

func set_player_health_current(updated_health : int) -> void:
	player_health_current = updated_health

func set_player_health_to_maximum() -> void:
	set_player_health_current(_initial_player_health_maximum)
