extends CanvasLayer

var hud: Control
var menu: Control
var mainMenu: Control

func _enter_tree() -> void:
	Logic.userInterface = self
	hud = $GameUI
	menu = $Menu
	mainMenu = $MainMenu
	var ui_container = get_child(0)
	Ui.uiBallsCounter = ui_container.get_node("Balls") as Label
	Ui.uiMultiplierCounter = ui_container.get_node("Multiplier") as Label
	Ui.uiScoreCounter = ui_container.get_node("Score") as Label
	Ui.uiScoreCounterBall = ui_container.get_node("BallScore") as Label
	Ui.uiCurrentLevel = ui_container.get_node("CurrentLevel") as Label

func _on_btn_retry_pressed() -> void:
	LevelsManager.level_Restart()


func _on_btn_next_level_pressed() -> void:
	LevelsManager.level_Next()


func _on_btn_previous_level_pressed() -> void:
	LevelsManager.level_Previous()


func _on_btn_play_pressed() -> void:
	mainMenu.visible = false
	var highest_cleared = -1
	for level_num in LevelsManager.levelsLibrary.keys():
		if LevelsManager.levelsLibrary[level_num]["isLevelCleared"]:
			if level_num > highest_cleared:
				highest_cleared = level_num
	var next_level = highest_cleared + 1
	if LevelsManager.levelsLibrary.has(next_level):
		LevelsManager.load_level(next_level)
	else:
		print("No next level available.")


func _on_btn_exit_pressed() -> void:
	pass # Replace with function body.
