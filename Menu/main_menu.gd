extends VBoxContainer

var gameStage: Node2D
var menuButtons: Control

func _ready() -> void:
	menuButtons = $MenuButtons
	gameStage = Logic.game.get_node("Stage")
	

func toggleMainMenu():
	if self.visible:
		# Stage mode
		hide()
		Logic.userInterface.hud.visible = true
		Logic.isGamePaused = false
		Logic.isInputDisabled = false
		gameStage.show()
	else:
		# Menu mode
		LevelsManager.levelTransition.play_bubbles_effect()
		await get_tree().create_timer(LevelsManager.levelTransition.transition_time).timeout
		LevelsManager.unload_level()
		show()
		menuButtons.btn_play.grab_focus()
		Logic.userInterface.hud.visible = false
		Logic.isGamePaused = true
		Logic.isInputDisabled = true
		gameStage.hide()
		LevelsManager.levelTransition.stop_bubbles_effect()
		await get_tree().create_timer(LevelsManager.levelTransition.transition_time).timeout
