class_name Ball
extends RigidBody2D

@onready var longShotTimer: Timer = $LongShotTimer
signal long_shot_bonus
signal end_ball

func _ready() -> void:
	connect("end_ball", Callable(get_parent(), "_on_ball_end"))
	connect("long_shot_bonus", Callable(self, "_on_long_shot_bonus"))

func _on_body_entered(body:Node) -> void:
	if body.is_in_group("Peg"):
		if body.is_in_group("PegRed") and longShotTimer.time_left <= 0:
			emit_signal("long_shot_bonus")
			
			print("Long shot bonus activated for " + body.name)
		body.hit()
	longShotTimer.start()


func endBall():
	print("Ball ended")
	emit_signal("end_ball")
	Logic.gotExtraBall1 = false
	Logic.gotExtraBall2 = false
	Logic.gotExtraBall3 = false
	queue_free()
func _process(_delta: float) -> void:
	$Label.text = str(longShotTimer.time_left).pad_decimals(2)
