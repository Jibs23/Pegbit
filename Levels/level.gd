class_name Level
extends Node2D

@export var levelRedPegs: int
@export var levelBalls: int = 10

# References to required child nodes
@onready var pegsGroup: Node2D = $PegsGroup
@onready var background: Sprite2D = $Background
func _enter_tree() -> void:
	Logic.level = self
func _ready() -> void:

	# Initialize Logic variables
	Logic.redPegCount = levelRedPegs
	Logic.ballCount = levelBalls
	Logic.isGameStarted = true
	Logic.isGameOver = false
	Logic.isBallInPlay = false
	Logic.isBucketMove = true
	Logic.score = 0
	Logic.scoreMultiplier = 1
	Logic.removedBluePegs = 0
	Logic.removedRedPegs = 0
	Ui.update_ui()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("launcher_shoot") and Logic.isGameOver:
		get_tree().reload_current_scene()
