extends Node

@onready var uiBallsCounter = get_node("/root/Game/Stage/game UI/VBoxContainer/Balls") as Label
@onready var uiScoreCounter = get_node("/root/Game/Stage/game UI/VBoxContainer/Score") as Label
@onready var uiMultiplierCounter = get_node("/root/Game/Stage/game UI/VBoxContainer/Multiplier") as Label
@onready var uiScoreCounterBall = get_node("/root/Game/Stage/game UI/VBoxContainer/BallScore") as Label

func update_ui() -> void:
	uiBallsCounter.text = "Balls: " + str(Logic.ballCount)
	uiScoreCounter.text = "Score: " + str(Logic.score)
	uiMultiplierCounter.text = "Multiplier: " + str(Logic.scoreMultiplier)
	uiScoreCounterBall.text = "BallScore: " + str(Logic.ballScoreCounter)
