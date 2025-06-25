extends VBoxContainer

func toggleMainMenu():
	var gameStage = Logic.game.get_node("Stage")
	var mainMenu = Logic.userInterface.mainMenu
	if mainMenu.visible:
		# Stage mode
		mainMenu.hide()
		Logic.userInterface.hud.visible = true
		Logic.isGamePaused = false
		Logic.isInputDisabled = false
		gameStage.show()
	else:
		# Menu mode
		LevelsManager.levelTransition.play_bubbles_effect()
		await get_tree().create_timer(LevelsManager.levelTransition.transition_time).timeout
		LevelsManager.unload_level()
		mainMenu.show()
		Logic.userInterface.hud.visible = false
		Logic.isGamePaused = true
		Logic.isInputDisabled = true
		gameStage.hide()
		LevelsManager.levelTransition.stop_bubbles_effect()
		await get_tree().create_timer(LevelsManager.levelTransition.transition_time).timeout
