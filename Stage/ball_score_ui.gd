extends Node2D

var valueCount: Label
var levelUi: Node2D
var animationPlayer: AnimationPlayer
var extraballsUI: Node2D

func _ready() -> void:
	valueCount = $BallScore
	Ui.uiScoreCounterBall = self
	levelUi = get_parent()
	extraballsUI = get_node("extra balls UI")