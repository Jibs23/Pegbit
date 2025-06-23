extends Camera2D

var ballToFollow: Ball
var isFollowBall: bool = false
var standardPosition: Vector2
var audienceSoundLenght: float
var lastPeg: Peg
var distanceToPeg: float = 0.0
var lastRedPegPositon: Vector2


func _physics_process(_delta):
	if isFollowBall:
		global_position = ballToFollow.global_position
		distanceToPeg = ballToFollow.global_position.distance_to(lastRedPegPositon)

func _enter_tree() -> void:
	Logic.camera = self

func _on_bullet_time_activated(ball: Ball, peg: Peg):
	lastPeg = peg
	lastRedPegPositon = peg.global_position
	standardPosition = global_position
	ballToFollow = ball

	isFollowBall = true
	reparent(ball, true)
	Engine.time_scale = 0.05
	var tween_zoom := create_tween()
	var zoom_speed := .1
	tween_zoom.tween_property(self, "zoom", Vector2(3, 3), zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_bullet_time_deactivated():
	resetCamera()
	ballToFollow = null
	Engine.time_scale = 1.0

func resetCamera():
	reparent(get_node("/root/Game"), true)
	global_position = standardPosition
	isFollowBall = false
	var tween_zoom := create_tween()
	var zoom_speed := .1
	tween_zoom.tween_property(self, "zoom", Vector2(1, 1), zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
