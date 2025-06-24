extends Node
var uiBallsCounter
var uiScoreCounter
var uiMultiplierCounter
var uiScoreCounterBall
var uiCurrentLevel

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	var ui_elements = [
		[uiBallsCounter, "Balls: ", Logic.ballCount],
		[uiMultiplierCounter, "Multiplier: ", Logic.scoreMultiplier],
		[uiScoreCounter, "Score: ", Logic.score],
		[uiScoreCounterBall, "BallScore: ", Logic.ballScoreCounter],
		[uiCurrentLevel, "Current Level: ", LevelsManager.get_current_level()]
	]
	for element in ui_elements:
		var label = element[0]
		var display_text = element[1]
		var value = element[2]
		if value == null:
			value = 0
			print("Warning: Value for " + display_text + " is null, setting to 0")
		if label:
			label.text = display_text + str(value)
