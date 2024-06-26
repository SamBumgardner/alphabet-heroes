extends Control

const combat_fade_out_duration = .5
const travel_fade_in_duration = .5
const travel_fade_out_duration = .5
const combat_fade_in_duration = .5

signal combat_nodes_hidden() # means combat stuff can perform all of their upgrades now
signal fight_retried()

@onready var database = get_node("/root/Database")

@onready var combat_nodes = $CombatNodes as Control
@onready var combat_sequencer = $CombatNodes/CombatSequencer as CombatSequencer
@onready var hero_repository = $CombatNodes/HeroRepository as HeroRepository
@onready var enemy = $CombatNodes/Enemy as Enemy
@onready var player = $CombatNodes/Player as Player
@onready var text_controller = $CombatNodes/TextController as TextController

@onready var travel_nodes = $TravelNodes as Control

@onready var world_map = $CanvasLayer/WorldMap as WorldMap

func _ready():
	
	# wire up connections in code to make them more durable than editor config
	text_controller.word_submitted.connect(combat_sequencer._on_word_submitted)
	combat_sequencer.combat_started.connect(text_controller._on_combat_started)
	combat_sequencer.player_impact.connect(text_controller._on_player_impact)
	combat_sequencer.combat_finished.connect(text_controller._on_combat_finished)
	
	combat_sequencer.combat_finished.connect(enemy._on_combat_finished)
	combat_sequencer.enemy_impact.connect(enemy._on_enemy_impact)
	enemy.enemy_defeated.connect(combat_sequencer._on_enemy_defeated)
	
	var party_controller = $CombatNodes/PartyController as PartyController
	party_controller.party_activated.connect(enemy._on_party_activated)
	
	text_controller.word_changed.connect(party_controller._on_word_changed)
	text_controller.word_activated.connect(party_controller._on_word_activated)
	
	var player_combat_preview = $CombatNodes/PlayerCombatPreview as CombatPreview
	party_controller.party_changed.connect(player_combat_preview._on_party_changed)
	
	var enemy_combat_preview = $CombatNodes/EnemyCombatPreview as CombatPreview
	enemy.action_changed.connect(enemy_combat_preview._on_action_changed)
	
	enemy.enemy_activated.connect(player._on_enemy_activated)
	combat_sequencer.combat_finished.connect(player._on_combat_finished)
	party_controller.party_activated.connect(player._on_party_activated)
	player.player_defeated.connect(combat_sequencer._on_player_defeated)
	
	var tile_text_display = $CombatNodes/TileTextDisplay as TileTextDisplay
	text_controller.word_changed.connect(tile_text_display._set_word)
	text_controller.word_denied.connect(tile_text_display._color_denied_text)
	text_controller.word_submitted.connect(tile_text_display._word_submitted_reaction)
	
	var summoned_hero_previews = $CombatNodes/SummonedHeroPreviews as SummonedHeroPreviews
	party_controller.party_changed.connect(summoned_hero_previews._on_party_changed)
	combat_sequencer.player_windup.connect(summoned_hero_previews._on_player_windup)

	var animated_hero_displayer = $CombatNodes/AnimatedHeroDisplayer as AnimatedHeroDisplayer
	party_controller.party_changed.connect(animated_hero_displayer._on_party_changed)
	summoned_hero_previews.summon_hero_positions.connect(
		animated_hero_displayer._on_summon_hero_positions
	)
	combat_sequencer.player_windup.connect(animated_hero_displayer._on_player_windup)
	combat_sequencer.player_impact.connect(animated_hero_displayer._on_player_impact)
	
	combat_sequencer.combat_finished.connect(hero_repository.generate_heroes_end_of_turn)
	
	var summon_new_heroes_button = $CombatNodes/SummonNewHeroesButton
	combat_sequencer.combat_started.connect(summon_new_heroes_button._on_combat_started)
	combat_sequencer.combat_finished.connect(summon_new_heroes_button._on_combat_finished)
	
	var skip_turn_label = $CombatNodes/SkipTurnLabel
	combat_sequencer.player_skipped.connect(skip_turn_label._on_turn_skipped)
	
	var enemy_display = $CombatNodes/EnemyDisplay
	enemy.enemy_enraged.connect(enemy_display._on_enemy_enrage_changed)
	
	combat_nodes_hidden.connect(hero_repository._on_combat_nodes_hidden)
	combat_nodes_hidden.connect(text_controller._on_combat_nodes_hidden)
	combat_nodes_hidden.connect(player._on_combat_nodes_hidden)
	
	var intro_animation : IntroAnimation = $IntroNodes/IntroAnimation
	intro_animation.intro_finished.connect(_on_intro_finished)
	
	# short-term game over handling:
	var developer_only_navigation = $CombatNodes/DeveloperOnlyNavigation
	combat_sequencer.gameover_defeat_finished.connect(
		developer_only_navigation._on_lose_button_pressed
	)
	
	combat_sequencer.gameover_victory_finished.connect(_on_gameover_victory_finished)
	
	if Database.current_enemy_index != -1:
		fight_retried.emit()
		_initialize_at_combat()

func _on_intro_finished():
	print("received cleanup")
	$IntroNodes.process_mode = Node.PROCESS_MODE_DISABLED
	world_map.reset_scale_tween()
	Database.set_current_enemy_index(-1)
	_on_gameover_victory_finished()

func try_get_next_enemy() -> EnemyData:
	Database.set_current_enemy_index(Database.current_enemy_index + 1)
	if Database.current_enemy_index < Database.ENEMY_LIST.size():
		return Database.ENEMY_LIST[Database.current_enemy_index]
	
	return null

func _on_gameover_victory_finished():
	var next_enemy = try_get_next_enemy()
	
	if next_enemy == null:
		var developer_only_navigation = $CombatNodes/DeveloperOnlyNavigation
		developer_only_navigation._on_win_button_pressed()
		return
	
	$TravelNodes/Label.text = "Travelling to %s..." % next_enemy.location_name
	var changes_text = Database.get_progression_applied_before_enemy().to_string()
	if changes_text != "":
		$TravelNodes/PanelContainer.show()
		$TravelNodes/PanelContainer/ProgressionText.text = "Your legend grows:\n" + changes_text
	else:
		$TravelNodes/PanelContainer.hide()
		$TravelNodes/PanelContainer/ProgressionText.text = ""
		
	
	travel_nodes.modulate = Color.TRANSPARENT
	travel_nodes.show()
	
	var travel_tween = create_tween()
	travel_tween.tween_property(combat_nodes, "modulate", Color.TRANSPARENT, combat_fade_out_duration)
	travel_tween.tween_callback(emit_signal.bind("combat_nodes_hidden"))
	travel_tween.tween_property(travel_nodes, "modulate", Color.WHITE, travel_fade_in_duration)
	travel_tween.parallel().tween_property(world_map, "modulate", Color.WHITE, travel_fade_in_duration)
	world_map.add_travel_tween_steps(travel_tween, next_enemy.location_position)
	travel_tween.tween_callback(_reinitialize_combat.bind(next_enemy))
	travel_tween.tween_property(travel_nodes, "modulate", Color.TRANSPARENT, travel_fade_out_duration)
	travel_tween.parallel().tween_property(world_map, "modulate", Color.DIM_GRAY, travel_fade_in_duration)
	travel_tween.tween_callback(travel_nodes.hide)
	travel_tween.tween_property(combat_nodes, "modulate", Color.WHITE, combat_fade_in_duration)
	travel_tween.tween_callback(_begin_new_combat)

# Use to jump straight to a particular fight
func _initialize_at_combat():
	var starting_enemy = Database.ENEMY_LIST[Database.current_enemy_index]
	# cancel intro animation
	($IntroNodes/IntroAnimation as IntroAnimation).stop()
	$IntroNodes.process_mode = Node.PROCESS_MODE_DISABLED
	$IntroNodes.queue_free()
	# apply all previous improvements
	var i = 0
	while i <= Database.current_enemy_index:
		var progression = Database.HERO_PROGRESSION[i]
		hero_repository.apply_progression(progression)
		text_controller.apply_progression(progression)
		player.apply_progression(progression)
		i += 1
	# jump world map to target position & scale & change modulation to dim gray
	world_map.jump_to_destination(starting_enemy.location_position)
	world_map.modulate = Color.DIM_GRAY
	# _reinitialize_combat with current enemy
	_reinitialize_combat(starting_enemy)
	# hide travel nodes
	travel_nodes.hide()
	# modulate in combat nodes
	combat_nodes.modulate = Color.WHITE
	# begin new combat
	_begin_new_combat()
	

func _reinitialize_combat(new_enemy_data:EnemyData):
	combat_sequencer.combat_finished.emit()
	hero_repository.reset()
	enemy.initialize_enemy(new_enemy_data)
	combat_nodes.process_mode = Node.PROCESS_MODE_DISABLED

func _begin_new_combat():
	combat_nodes.process_mode = Node.PROCESS_MODE_INHERIT
