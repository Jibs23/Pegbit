class_name Launcher
extends Node2D

var ball: PackedScene = load("res://ball.tscn")
var ballSpeed: float = 300

var rotationSpeed: float = 1.5
var maxRotation: float = deg_to_rad(85)
@onready var launchPoint = $BallLaunchPoint


# Called every frame
func _process(delta):
	if Input.is_action_pressed("ui_left") and rotation <= maxRotation:
		rotation += rotationSpeed * delta

	if Input.is_action_pressed("ui_right") and rotation >= -maxRotation:
		rotation -= rotationSpeed * delta

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		shoot()

func shoot():
	var new_ball = ball.instantiate() as RigidBody2D  # Ensure the ball is a RigidBody2D
	if new_ball:
		var ball_counter: int = 0  # Counter to track ball numbers
		ball_counter += 1  
		new_ball.name = "Ball %d" % ball_counter  

		new_ball.position = launchPoint.global_position
		get_parent().get_node("Balls").add_child(new_ball)
		
		# Calculate the direction based on the launchPoint's global rotation
		var direction = Vector2(cos(launchPoint.global_rotation), sin(launchPoint.global_rotation)).normalized()
		new_ball.linear_velocity = direction * ballSpeed
	else:
		print("Error: Failed to instantiate the ball.")
