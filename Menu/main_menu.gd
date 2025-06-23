extends CanvasLayer

@export var startLevel: int = 1

func _on_button_pressed() -> void:
	Logic.toggleMainMenu()
	LevelsManager.load_level(startLevel)
