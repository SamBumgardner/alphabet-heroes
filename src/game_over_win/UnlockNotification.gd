class_name UnlockNotification extends PanelContainer

@export_multiline var notification_text : String = ""

@onready var particles : CPUParticles2D = $Control/BoxParticles
@onready var label : Label = $MarginContainer/Label
@onready var unlock_sound : AudioStreamPlayer2D = $UnlockSound

func _ready():
	resized.connect(_on_resized)
	label.text = notification_text

func _on_resized():
	particles.emission_rect_extents = size / 2.0

func pop_up():
	show()
	particles.restart()
	unlock_sound.play()
