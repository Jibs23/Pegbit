extends CharacterBody2D

signal bucket_scored

var bucket_track: Path2D
var bucket_path_follow: PathFollow2D
var splash: GPUParticles2D

func _init() -> void:
	Logic.bucket = self
	Logic.connect("bonusModeActivated", Callable(self, "on_bonus_mode_activated"))

func _ready() -> void:
	if get_parent() is Path2D:
		bucket_track = get_parent()
		bucket_path_follow = bucket_track.get_node("PathFollow2D")
		bucket_path_follow.bucket = self
	bucket_path_follow.bucket = self
	splash = $SplashGPU

func _on_score_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		bucket_scored.emit()
		bucket_score_valid(body)
	else:
		print("Non-ball object entered bucket.")

func bucket_score_valid(ball) -> void:
	print("Ball scored in bucket!")
	Logic.addBall()
	ball.ballMissed = false  # Mark the ball as not missed
	ball.endBall()  # Remove the ball from the scene
	Logic.audio.playSoundEffect("SFXBucketScore")
	splash.emitting = true

func on_bonus_mode_activated() -> void:
	queue_free()
