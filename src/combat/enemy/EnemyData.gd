class_name EnemyData extends Resource

@export var name = "placeholder_name"
@export var max_health : int = 50
@export var graphic : Texture2D
@export var action_selector_class : Resource
@export var location_name = "location_name"
@export var location_position : Vector2

# Optionally override the default SFX for attack windup.
@export var sfx_windup : AudioStream
