extends Node

func _init() -> void:
	Logic.game = self
	

func _process(_delta):
	if Input.is_action_pressed("unlock_all"):
		LevelsManager.unlock_all_levels()
	else: return