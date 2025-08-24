extends Node

var ballsUI: Node2D
var launcher: Node2D
var balls: Node2D
var pegs: Node2D
var audio: Node2D
var level: Node2D
var camera: Camera2D
var game: Node
var missedBallFeature: Node2D
var bucket: Node2D
var bonusHoles: Node2D
var stage: Node2D

signal bullet_time_deactivated

var isGameOver: bool = false
var isGameStarted: bool = false
var isBucketMove: bool = false
var isBallInPlay: bool = false
var isOneRedPegRemaining: bool = false
var isBulletTimeActive: bool = false
var levelClearedBonusMode: bool = false
var isInputDisabled: bool = true
var isGamePaused: bool = false

var redPegCount: int
var bluePegCount: int
var totalPegCount: int

var removedRedPegs: int = 0
var removedBluePegs: int = 0

var ballScoreCounter: int = 0
var score: int = 0
var scoreMultiplier: int = 1
var ballCount: int

signal scoreAdded(amount: int)
signal ballScoreAdded(amount: int)

func addScore(amount:int):
	score += amount
	emit_signal("scoreAdded", amount)

func addBallScore(amount:int):
	ballScoreCounter += amount
	emit_signal("ballScoreAdded", amount)

func GameOver():
	if isGameOver:
		push_error("Game is already over.")
		return
	isGameOver = true
	isGameStarted = false
	isBucketMove = false
	Ui.changeActiveUi("gameMenu")
	isInputDisabled = true
	print("Game Over! No more balls left.")

func updateMultiplier():
	# Define thresholds and their corresponding multipliers
	var multiplier_thresholds = {
		25: 10,
		15: 5,
		10: 3,
		6: 2,
		0: 1
	}
	
	# Sort thresholds in descending order
	var sorted_thresholds = multiplier_thresholds.keys()
	sorted_thresholds.sort()
	sorted_thresholds.reverse()

	if levelClearedBonusMode:
		scoreMultiplier = 20 # FEVER mode multiplier
		print("FEVER MODE Multiplier: " + str(scoreMultiplier))
		return
	# Find the highest threshold that matches removedRedPegs
	for threshold in sorted_thresholds:
		if removedRedPegs == threshold:
			scoreMultiplier = multiplier_thresholds[threshold]
			print("Multiplier: " + str(scoreMultiplier))
			break

	Ui.update_ui()

var extraBallMilestones := {
	1: {"score": 25000, "got": false}, #25000
	2: {"score": 75000, "got": false}, #75000
	3: {"score": 125000, "got": false} #125000
}

func nextExtraBallScore() -> int:
	var mileStones = extraBallMilestones.keys()
	mileStones.sort()
	for milestone in mileStones:
		if not extraBallMilestones[milestone]["got"]:
			return extraBallMilestones[milestone]["score"]
	return -1 # All milestones achieved

func nextExtraBallNumber() -> int:
	var mileStones = extraBallMilestones.keys()
	mileStones.sort()
	for milestone in mileStones:
		if not extraBallMilestones[milestone]["got"]:
			return milestone
	return -1 # All milestones achieved

func reset_extraBallMilestones():
	for milestone in extraBallMilestones.keys():
		extraBallMilestones[milestone]["got"] = false

signal extra_ball_added

func _on_extra_ball_check():
	for milestone in extraBallMilestones.keys():
		var milestone_data = extraBallMilestones[milestone]
		if ballScoreCounter >= milestone_data["score"] and !milestone_data["got"]:
			extraBallMilestones[milestone]["got"] = true
			addBall()
			audio.playSoundEffect("SFXExtraBall")
			emit_signal("extra_ball_added", milestone, milestone_data)
			print("Extra ball %d added! %d" % [milestone, milestone_data["score"]])

func addBall():
	ballCount += 1
	Ui.update_ui()

func _on_hitLastRedPeg():
	emit_signal("bullet_time_deactivated")
	audio.playSoundEffect("SFXCrowdCheer")
	isOneRedPegRemaining = false
	isBulletTimeActive = false
	camera.resetCamera()
	initializeBonusMode()

signal bonusModeActivated

func initializeBonusMode():
	emit_signal("bonusModeActivated")
	levelClearedBonusMode = true
	bonusHoles.show_bonus_holes()
	Engine.time_scale = 0.5

func levelCompleted(): # call after bonus mode is over.
	Ui.changeActiveUi("gameMenu")
	isInputDisabled = true
	Engine.time_scale = 1.0
	LevelsManager.level_Clear()

func _on_bonusHoleEntered(bonusHoleValue: int):
	score += bonusHoleValue
	levelCompleted()

var prepauseTimeScale: float

func _on_game_pause():
	print("Game paused.")
	isGamePaused = true
	isInputDisabled = true
	prepauseTimeScale = Engine.time_scale
	Engine.time_scale = 0.0

func _on_game_unpause():
	print("Game unpaused.")
	isGamePaused = false
	isInputDisabled = false
	Engine.time_scale = prepauseTimeScale

func tween_transfer_points(from_label:Label,to_label:Label,time:float):
	var tween = create_tween()
	var start_value = int(to_label.text)
	var transfer_amount = int(from_label.text)
	var end_value = start_value + transfer_amount
	
	tween.parallel().tween_method(func(value): to_label.text = str(int(value)), start_value, end_value, time)
	tween.parallel().tween_method(func(value): from_label.text = str(int(value)), transfer_amount, 0, time)
	await tween.finished
