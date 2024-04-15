extends TextureRect

const GLOW_COLORS = [
	Color.YELLOW,
	Color.SKY_BLUE,
	Color.RED,
	Color.GREEN,
	Color.WHITE
]

static var SEMI_TRANSPARENT = Color.from_hsv(0,0,1,.25)

@onready var glow : Panel = $LeaderBonusGlow

var glow_tween : Tween

func _ready():
	_restart_glow_tween()

func _restart_glow_tween(job:Hero.Job = Hero.Job.WARRIOR):
	if glow_tween != null and glow_tween.is_valid():
		glow_tween.kill()
	
	glow.self_modulate = GLOW_COLORS[job]
	glow_tween = create_tween()
	glow_tween.tween_property(glow, "modulate", SEMI_TRANSPARENT, 0)
	glow_tween.tween_property(glow, "modulate", Color.TRANSPARENT, 1)
	glow_tween.tween_property(glow, "modulate", SEMI_TRANSPARENT, 1)
	glow_tween.set_loops(0)

func set_leader_bonus_glow(matches_leader:bool, job:Hero.Job):
	glow.visible = matches_leader
	_restart_glow_tween(job)
