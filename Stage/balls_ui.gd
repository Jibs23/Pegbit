extends Node2D

var ui_ball: PackedScene = load("res://Entities/Balls/UI_ball.tscn")

var ballContainer: AnimatableBody2D
var ballSpawnPoint: Marker2D
var valueCount: Label
var containerSprite: Sprite2D
var uiBalls: Node2D
var levelUi: Node2D

func _ready() -> void:
	Logic.ballsUI = self
	levelUi = get_parent()
	Ui.uiBallsCounter = self
	uiBalls = $uiBalls
	containerSprite = $Barrel
	valueCount = $Balls
	ballSpawnPoint = $BallSpawnPoint
	ballContainer = $BallContainer

func maintainBallCount():
	while uiBalls.get_child_count() < Logic.ballCount:
		addExtraBall()
		await get_tree().create_timer(0.1).timeout
	while uiBalls.get_child_count() > Logic.ballCount:
		remove_ball()

func addExtraBall() -> void:
	var new_uiBall = ui_ball.instantiate()
	var random_offset = randf_range(-8, 8)
	new_uiBall.position = Vector2(ballSpawnPoint.position.x + random_offset,ballSpawnPoint.position.y)
	uiBalls.add_child(new_uiBall)
	new_uiBall.smokeEffect.emitting = true
	
func remove_ball() -> void:
	if uiBalls.get_child_count() > 0:
		var highest_ball = null
		for uiBall in uiBalls.get_children():
			if highest_ball == null or uiBall.position.y > highest_ball.position.y:
				highest_ball = uiBall
		if highest_ball:
			highest_ball.smokeEffect.emitting = true
			uiBalls.remove_child(highest_ball)

func shakeBalls():
	for uiBall in uiBalls.get_children():
		if uiBall is RigidBody2D:
			uiBall.linear_velocity += Vector2(randf() * 100 - 50, -(randf() * 100))

func _on_launcher_shoot_signal() -> void:
	shakeBalls()

func _on_uiBall_out_of_bounds():
	Ui.update_ui()