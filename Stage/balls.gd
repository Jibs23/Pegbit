extends Node2D

func _enter_tree() -> void:
	Logic.balls = self

func _on_child_order_changed() -> void:
	Logic.ballsUI.maintainBallCount()
	if get_children().size() > 0: # Check if there are any children
		Logic.isBallInPlay = true
	else: # if no children
		Logic.isBallInPlay = false

func _on_ball_end(ballMissed):
	Logic.score += Logic.ballScoreCounter
	Logic.ballScoreCounter = 0
	if ballMissed:
		Logic.missedBallFeature.roll_for_new_ball()
	elif Logic.ballCount <= 0 and not Logic.levelClearedBonusMode:
		Logic.GameOver()
	if Logic.levelClearedBonusMode:
		Logic.levelCompleted()
	Ui.update_ui()

const LONG_SHOT_BONUS = 25000

func _on_long_shot_bonus():
	Logic.score += LONG_SHOT_BONUS
	Logic.audio.playSoundEffect("SFXHitPegLongShot")
