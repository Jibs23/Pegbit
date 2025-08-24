class_name Ball
extends RigidBody2D

signal long_shot_bonus
signal end_ball

var ballMissed: bool = true

var distance_since_last_hit: float = 0.0
var last_position: Vector2
var numberOfCollisions: int = 0
const LONG_SHOT_DISTANCE: float = 9999.0 #default is 200 #!disabled



func _ready() -> void:
	connect("end_ball", Callable(Logic.balls, "_on_ball_end"))
	connect("long_shot_bonus", Callable(Logic.balls, "_on_long_shot_bonus"))
	last_position = global_position

func _on_body_entered(body:Node) -> void:
	if body.is_in_group("Peg"):
		if body.is_in_group("PegRed") and !body.isHit and distance_since_last_hit >= LONG_SHOT_DISTANCE and numberOfCollisions > 0:
			emit_signal("long_shot_bonus")
			print("Long shot bonus activated for " + body.name)
		body.hit()
		distance_since_last_hit = 0.0
		last_position = global_position
		numberOfCollisions += 1

func endBall() -> void:
	if Logic.ballScoreCounter > 0:
		ballMissed = false
	Logic.camera.resetCamera()
	Logic.reset_extraBallMilestones()
	emit_signal("end_ball", ballMissed)
	queue_free()
	
func _process(delta: float) -> void:
	var frame_distance = global_position.distance_to(last_position)
	distance_since_last_hit += frame_distance
	last_position = global_position
	$Label.text = str(distance_since_last_hit).pad_decimals(0) + "/" + str(LONG_SHOT_DISTANCE).pad_decimals(0)
	check_ball_stuck(delta)

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
