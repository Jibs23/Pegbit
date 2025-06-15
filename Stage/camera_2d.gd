extends Camera2D

var ballToFollow: Ball
var isFollowBall: bool = false

func _physics_process(_delta):
	if isFollowBall:
		global_position = ballToFollow.global_position

func _enter_tree() -> void:
	Logic.camera = self

func _on_bullet_time_activated(ball: Ball):
	print("Bullet time activated! in camera_2d.gd")
	ballToFollow = ball
	isFollowBall = true
	reparent(ball, true)
	Engine.time_scale = 0.3

## TODO: finish the bullet time feature
	#TODO: Stop bullet time after leaving peg.
	#TODO: Make transition smoother.
	#TODO: Add audience SFX.
