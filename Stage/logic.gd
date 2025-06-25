extends Node

var ballsUI: Node2D
var launcher: Node2D
var balls: Node2D
var pegs: Node2D
var audio: Node2D
var level: Node2D
var userInterface: CanvasLayer
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

func GameOver():
	isGameOver = true
	isGameStarted = false
	isBucketMove = false
	userInterface.menu.toggle_menu(true)
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


# Ball Score milestones for getting a free ball
const extraBall1: int = 25000
const extraBall2: int = 75000
const extraBall3: int = 125000

# Flags to check if extra balls have been obtained. Resets when ball ends.
var gotExtraBall1: bool = false
var gotExtraBall2: bool = false
var gotExtraBall3: bool = false

func _on_extra_ball_check():
	if ballScoreCounter < extraBall1:
		return
	elif ballScoreCounter >= extraBall1 and !gotExtraBall1:
		gotExtraBall1 = true
		addBall()
		audio.playSoundEffect("SFXExtraBall")
		print("Extra ball 1 added! "+ str(extraBall1))
	elif ballScoreCounter >= extraBall2 and !gotExtraBall2:
		gotExtraBall2 = true
		addBall()
		audio.playSoundEffect("SFXExtraBall")
		print("Extra ball 2 added! "+ str(extraBall2))
	elif ballScoreCounter >= extraBall3 and !gotExtraBall3:
		gotExtraBall3 = true
		addBall()
		audio.playSoundEffect("SFXExtraBall")
		print("Extra ball 3 added! "+ str(extraBall3))

func addBall():
	ballCount += 1
	ballsUI.call_deferred("maintainBallCount")

func _on_hitLastRedPeg():
	emit_signal("bullet_time_deactivated")
	audio.playSoundEffect("SFXCrowdCheer")
	isOneRedPegRemaining = false
	camera.resetCamera()
	initializeBonusMode()

signal bonusModeActivated

func initializeBonusMode():
	emit_signal("bonusModeActivated")
	levelClearedBonusMode = true
	bonusHoles.show_bonus_holes()
	LevelsManager.level_Clear()
	Engine.time_scale = 0.5

func levelCompleted(): # call after bonus mode is over.
	userInterface.menu.toggle_menu(true)
	isInputDisabled = true
	Engine.time_scale = 1.0


func _on_bonusHoleEntered(bonusHoleValue: int):
	score += bonusHoleValue
	levelCompleted()



var prepauseTimeScale: float

func _on_game_pause():
	isGamePaused = true
	isInputDisabled = true
	prepauseTimeScale = Engine.time_scale
	Engine.time_scale = 0.0

func _on_game_unpause():
	isGamePaused = false
	isInputDisabled = false
	Engine.time_scale = prepauseTimeScale