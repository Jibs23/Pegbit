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

func _on_btn_play_pressed() -> void:
	mainMenu.hide()
	LevelsManager.load_level(LevelsManager.reached_level)


func _on_btn_exit_pressed() -> void:
	SaveManager.save_game()
	get_tree().quit()


func _on_btn_main_menu_pressed() -> void:
	LevelsManager.unload_level()
	Logic.userInterface.mainMenu.toggleMainMenu()
	Logic.userInterface.menu.toggle_menu(false)


func _on_btn_save_pressed() -> void:
	SaveManager.save_game()


func _on_btn_load_pressed() -> void:
	SaveManager.load_save()


func _on_btn_erase_pressed() -> void:
	SaveManager.delete_save()
