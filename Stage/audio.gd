extends Node2D

func playSoundEffect(effectName: String) -> void:
	if has_node(effectName):  # Check if the node exists
		var sound_effect = get_node(effectName)
		if sound_effect and sound_effect.has_method("play"):  # Ensure the node has a 'play' method
			sound_effect.play()
			print("Playing sound effect: ", effectName)
		else:
			print("Error: Node found but does not have a 'play' method: ", effectName)
	else:
		print("Error: Sound effect node not found: ", effectName)
