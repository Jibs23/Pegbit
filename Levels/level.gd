extends Node2D
class_name Level

@export var levelRedPegs: int
@export var levelBalls: int = 10

# References to required child nodes
@onready var pegsGroup: Node2D = $PegsGroup
@onready var background: Sprite2D = $Background

signal levelLoaded

func _enter_tree() -> void:
	Logic.level = self
	self.connect("levelLoaded", Callable(get_parent().get_parent(), "_on_level_loaded"))
func _ready() -> void:
	
	# Initialize Logic variables
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

	Logic.isInputDisabled = false
	
	Engine.time_scale = 1.0
	emit_signal("levelLoaded")
	Ui.call_deferred("update_ui")
