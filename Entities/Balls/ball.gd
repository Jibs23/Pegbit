class_name Ball
extends RigidBody2D

@onready var longShotTimer: Timer = $LongShotTimer
var longShotBonusActive: bool = false
signal long_shot_bonus

func _on_body_entered(body:Node) -> void:
	if body.is_in_group("Peg"):
		var peg = body as Peg
		if longShotBonusActive and peg.is_class("RedPeg"):
			connect("long_shot_bonus", Callable(peg, "_on_long_shot_bonus"))
			emit_signal("long_shot_bonus")
			longShotBonusActive = false
			print("Long shot bonus activated for " + peg.name)
		peg.hit()
	longShotTimer.start()


func endBall():
	print("Ball ended")
	queue_free()


func _on_long_shot_timer_timeout() -> void:
	longShotBonusActive = true
