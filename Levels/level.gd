class_name Level
extends Node2D

@export var levelRedPegs: int
@export var levelBalls: int = 10

# References to required child nodes
@onready var pegsGroup: Node2D = $PegsGroup
@onready var background: Sprite2D = $Background

signal levelLoaded

func _enter_tree() -> void:
	Logic.level = self

func _ready() -> void:

	# Initialize Logic variables
	emit_signal("levelLoaded")
	Logic.levelClearedBonusMode = false
	Logic.redPegCount = levelRedPegs
	Logic.ballCount = levelBalls
	Logic.isGameStarted = true
	Logic.isGameOver = false
	Logic.isBallInPlay = false
	Logic.isBucketMove = true
	Logic.launcher.rotation = 0
		
	Logic.score = 0
	Logic.scoreMultiplier = 1
	Logic.ballScoreCounter = 0
	Logic.removedBluePegs = 0
	Logic.removedRedPegs = 0
	Logic.userInterface.menu.toggle_menu(false)
	if Logic.userInterface.hud.visible == false:
		Logic.userInterface.hud.show()
	Logic.ballsUI.maintainBallCount()

	# remove active balls
	for ball in Logic.balls.get_children():
		ball.queue_free()
	Logic.updateMultiplier()
	Logic.isInputDisabled = false
	Logic.bonusHoles.hide_bonus_holes()
	Engine.time_scale = 1.0
	Ui.update_ui()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("launcher_shoot") and Logic.isGameOver:
		get_tree().reload_current_scene()
