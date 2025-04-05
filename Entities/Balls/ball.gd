class_name Ball
extends RigidBody2D

func _on_body_entered(body:Node) -> void:
	if body.is_in_group("Peg"):
		var peg = body as Peg
		peg.hit()


func endBall():
	print("Ball ended")
	queue_free()
