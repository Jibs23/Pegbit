extends Area2D

signal bullet_time_activated
signal bullet_time_deactivated


var ball: Ball

func _ready() -> void:
	ball = get_parent()
	connect("bullet_time_activated", Callable(Logic.camera, "_on_bullet_time_activated"))
	connect("bullet_time_deactivated", Callable(Logic.camera, "_on_bullet_time_deactivated"))

func _on_body_entered(peg:Node2D) -> void:
	if peg.pegType != "red":
		return
	elif peg.pegIsLastRedPeg and !peg.isHit:
		Logic.isBulletTimeActive = true
		Logic.audio.playSoundEffect("SFXCrowdExcited")
		emit_signal("bullet_time_activated", ball, peg)
	else:
		return

func _on_body_exited(peg:Node2D) -> void:
	if peg.pegType != "red":
		return
	elif peg.pegIsLastRedPeg and !peg.isHit and Logic.isBulletTimeActive:
		Logic.isBulletTimeActive = false
		Logic.audio.playSoundEffect("SFXCrowdDisappointed")
		emit_signal("bullet_time_deactivated")
	else:
		return
