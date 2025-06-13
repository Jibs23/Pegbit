extends CharacterBody2D

signal bucket_scored

func _on_score_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		bucket_scored.emit()
		bucket_score_valid(body)
	else:
		print("Non-ball object entered bucket.")

func bucket_score_valid(ball) -> void:
	print("Ball scored in bucket!")
	Logic.addBall()
	ball.queue_free()  # Remove the ball from the scene
	Logic.audio.playSoundEffect("SFXBucketScore")
