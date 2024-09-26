class_name DialogueCharacter
extends Resource
## Resource containing everything needed for a "character" used in [DialogueCutscene]
## Includes name, audio, and visual resources needed for their display.

## The character's name
## Needs to be unique within a cutscene
@export var name : String

## Sound effect to serve as the character's "voice".
## Will be played as characters are revealed in the dialogue box.
## Expect it to be played repeatedly with slight pitch randomization.
@export var voice : AudioStream

## Spritesheet of "expressions" - a character's portrait, without a mouth.
## Mouth positioning is static under current implmentation, so it's probably best to keep the outline static too.
## variation in the eyes & facial features should play nicely with everything else.
@export var expressions : SpriteFrames

## Spritesheet of mouth animations. At a minimum, need to have the animations:
## - "default"
## - "talking"
## Everything else just needs to be implemented as needed for DialogueCutscenes.
@export var mouth_frames : SpriteFrames
