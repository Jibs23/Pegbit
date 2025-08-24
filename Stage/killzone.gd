extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Ball"):
		var ball = body as Ball
		ball.endBall()
	elif body.is_in_group("uiBall"):
		body.queue_free()
		Ui.update_ui()
		print("UI Ball fell out of the stage and was removed.")