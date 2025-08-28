class_name Ball
extends RigidBody2D

signal long_shot_bonus
signal end_ball

var ballMissed: bool = true

var distance_since_last_hit: float = 0.0
var numberOfCollisions: int = 0

func _ready() -> void:
	connect("end_ball", Callable(Logic.balls, "_on_ball_end"))
	connect("long_shot_bonus", Callable(Logic.balls, "_on_long_shot_bonus"))

func _on_body_entered(body:Node) -> void:
	if body.is_in_group("Peg"):
		body.hit()
		numberOfCollisions += 1

func endBall() -> void:
	if Logic.ballScoreCounter > 0:
		ballMissed = false
	Logic.camera.resetCamera()
	Logic.reset_extraBallMilestones()
	emit_signal("end_ball", ballMissed)
	queue_free()
	
var stuck_check_accumulator: float = 0.0
var stuck_check_interval: float = 0.5  # seconds between checks

func _process(delta: float) -> void:
	stuck_check_accumulator += delta
	if stuck_check_accumulator >= stuck_check_interval:
		check_ball_stuck(stuck_check_accumulator)
		stuck_check_accumulator = 0.0

var stuck_timer: float = 0.0
var stuck_threshold: float = 1.5  # seconds before considering ball stuck
var velocity_threshold: float = 10.0  

func check_ball_stuck(delta: float) -> void:
	var current_velocity = linear_velocity.length()
	
	if current_velocity < velocity_threshold:
		stuck_timer += delta
		if stuck_timer >= stuck_threshold:
			print("Ball is stuck! Velocity: ", current_velocity)
			Logic.pegs.ballIsStuck = true
	else:
		stuck_timer = 0.0
		Logic.pegs.ballIsStuck = false
