class_name Launcher
extends Node2D

var ball: PackedScene = load("res://Entities/Balls/ball.tscn")
var ballSpeed: float = 300
var rotationSpeed: float = 1.5
@export var maxRotation: float = deg_to_rad(90)
@export var launcherInch: float = 0.1

@onready var launchPoint = $BallLaunchPoint
@onready var smoke = $"Sprite2D/Smoke effect"

signal shoot_signal

func _ready():
	Logic.launcher = self

func _process(delta):
	if Input.is_action_pressed("launcher_turn_left") and rotation <= maxRotation:
		if !Input.is_action_pressed("launcher_inch"):
			rotation += rotationSpeed * delta
		else:
			rotation += rotationSpeed * delta * launcherInch

	if Input.is_action_pressed("launcher_turn_right") and rotation >= -maxRotation:
		if !Input.is_action_pressed("launcher_inch"):
			rotation -= rotationSpeed * delta
		else:
			rotation -= rotationSpeed * delta * launcherInch

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("launcher_shoot") and Logic.isGameStarted and !Logic.isGameOver and !Logic.isBallInPlay and Logic.ballCount > 0:
		shoot()

func shoot():
	var new_ball = ball.instantiate() as RigidBody2D  # Ensure the ball is a RigidBody2D
	if new_ball: #instantiate new ball
		smoke.restart()
		var ball_counter: int = 0  # Counter to track ball numbers
		ball_counter += 1  
		new_ball.name = "Ball %d" % ball_counter  

		new_ball.position = launchPoint.global_position
		$"../Balls".add_child(new_ball)
		
		# Calculate the direction based on the launchPoint's global rotation
		var direction = Vector2(cos(launchPoint.global_rotation), sin(launchPoint.global_rotation)).normalized()
		new_ball.linear_velocity = direction * ballSpeed

		# adjust ui and logic
		Logic.ballCount -= 1
		Ui.update_ui()
		emit_signal("shoot_signal")
	else:
		print("Error: Failed to instantiate the ball.")
