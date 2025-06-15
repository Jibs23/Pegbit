extends Area2D

signal bullet_time_activated

func _on_body_entered(peg:Node) -> void:
	if peg.is_in_group("PegRed") and Logic.isLastRedPeg and peg.isHit == false:
		connect("bullet_time_activated", Callable(Logic.camera, "_on_bullet_time_activated"))
		emit_signal("bullet_time_activated", get_parent())
	else:
		return

func _on_body_exited(peg:Node2D) -> void:
	if peg.is_in_group("PegRed") and Logic.isLastRedPeg:
		pass
	else:
		return