extends CollisionShape2D

var txtScore: Label
var confetti: GPUParticles2D
var scoreValue: int
var scoreAnimation: AnimationPlayer
var scoreContainer: Control

func _ready() -> void:
	confetti = $confetti as GPUParticles2D
	scoreAnimation = $ScoreAnimation as AnimationPlayer
	scoreContainer = $ScoreContainer as Control
	txtScore = scoreContainer.get_node("TxtScore") as Label
	scoreValue = get_meta("ScoreValue")
	txtScore.text = str(scoreValue)

func activate_score_text() -> void:
	scoreAnimation.play("point_holes_score_text")
	scoreContainer.visible = true

func reset_score_text() -> void:
	scoreAnimation.stop(0)
	scoreContainer.visible = false