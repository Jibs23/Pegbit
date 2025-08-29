extends Node

func _init() -> void:
	Logic.game = self
	
	

func _input(event: InputEvent):
	if event.is_action_pressed("unlock_all"):
		LevelsManager.unlock_all_levels()
	else: return