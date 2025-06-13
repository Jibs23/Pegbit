extends CharacterBody2D

signal bucket_scored

func _on_score_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		bucket_scored.emit()
		bucket_score_valid()
	else:
		print("Non-ball object entered bucket.")

func bucket_score_valid() -> void:
	print("Ball scored in bucket!")
	Logic.ballCount += 1
