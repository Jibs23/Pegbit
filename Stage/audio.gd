extends Node2D

var audienceSoundEffectDisappointed: Node2D
var audienceSoundEffectExcited: Node2D

func _enter_tree() -> void:
	Logic.audio = self

func playSoundEffect(effectName: String) -> Node:
	if has_node(effectName):  # Check if the node exists
		var sound_effect = get_node(effectName)
		if sound_effect and sound_effect.has_method("play"):  # Ensure the node has a 'play' method
			sound_effect.play()
			return sound_effect  # Return the sound effect node
		else:
			print("Error: Node found but does not have a 'play' method: ", effectName)
	else:
		print("Error: Sound effect node not found: ", effectName)
	return null  # Return null if the node is not found or invalid


var distanceToPegLastFrame: float
var gettingCloserToPeg: bool
var lastPlayedSoundEffect