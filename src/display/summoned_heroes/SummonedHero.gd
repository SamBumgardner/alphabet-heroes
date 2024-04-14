class_name SummonedHero extends AnimatedSprite2D

static var job_spritesheets : Array = [
	preload("res://assets/art/heroes/warrior_frames.tres"),
	preload("res://assets/art/heroes/knight_frames.tres"),
	preload("res://assets/art/heroes/mage_frames.tres"),
	preload("res://assets/art/heroes/priest_frames.tres"),
	preload("res://assets/art/heroes/peasant_frames.tres"),
]

func switch_graphic(new_job : Hero.Job):
	sprite_frames = job_spritesheets[new_job]
