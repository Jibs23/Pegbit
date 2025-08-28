extends Node2D

signal ballEnded

func _enter_tree() -> void:
	Logic.balls = self

func _on_child_order_changed() -> void:
	Ui.update_ui()
	if get_children().size() > 0: # Check if there are any children
		Logic.isBallInPlay = true
	else: # if no children
		Logic.isBallInPlay = false

func _on_ball_end(ballMissed):
	Logic.isInputDisabled = true
	if Logic.ballScoreCounter > 0:
		Logic.audio.playSoundEffect("SFXWealthTransfer")
		await Logic.tween_transfer_points(Ui.uiScoreCounterBall.valueCount,Ui.uiScoreCounter.valueCount,1.0)
	Logic.isInputDisabled = false
	Logic.addScore(Logic.ballScoreCounter)
	Logic.ballScoreCounter = 0
	emit_signal("ballEnded")
	if ballMissed:
		Logic.missedBallFeature.roll_for_new_ball()
	elif Logic.ballCount <= 0 and not Logic.levelClearedBonusMode:
		Logic.GameOver()
	if Logic.levelClearedBonusMode:
		Logic.levelCompleted()
	Ui.update_ui()
