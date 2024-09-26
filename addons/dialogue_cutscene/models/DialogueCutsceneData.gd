class_name DialogueCutsceneData
extends Resource

## Set of [DialogueCharacter] used in this scene.
## Ordering doesn't matter, this should generally be used to create a dictionary keyed by character name.
## Godot's default editor makes adding custom resources to a dictionary a huge pain, though, so this is much simpler.
## Because of this, avoid adding the same character twice, or creating two characters with the same name.
@export var characters : Array[DialogueCharacter] = []

## Array of strings representing the "pages" of the cutscene's script.
## Each string begins with the name of the speaking character.
## This is followed by any number of metadata-and-dialogue pairs, the start and end of each block of metadata marked by "|" characters
## The combination of metadata and text provided here dictates the pacing and content of the scene.
##
## For a complete explanation of metadata's structure and possible values, see [method DialogueUnit._init]
##
## An example of a complete dialogue_script:
## [code]
## dialogue_script = [
##     "Cameron|1.5|So, do you want to talk about anything in particular?\n\nWe\'ve got all of this space to work with, after all.", 
##     "Gerald|1|I think I\'d like to talk about boats today.",    
##     "Cameron|1.5|Boats, huh? I\'ve never had one before. I hear they can be pretty expensive to maintain.",
##     "Gerald|1,0,2|Yeah, me neither.|.15,0,0,default,default|...",
##     "Cameron|1.5,0,.5,worried|Wait, that\'s it?|1.5,0,0,curious| Why did you even bring them up in the first place?",
##     "Gerald|1,0,.5|I just wanted to see how long we could keep this conversation |1.5,1,.5,laughing,talking,smile|AFLOAT!",
##     "Cameron|1.5,0,0,worried,talking,smile|Boooooooo!"
## ]
## [/code]
@export var dialogue_script : Array[DialogueScriptPage] = []
