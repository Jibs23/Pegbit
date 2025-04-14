extends Node2D

var ui_ball: PackedScene = load("res://Entities/Balls/UI_ball.tscn")

func _enter_tree() -> void:
	Logic.ballsUI = self

func _ready() -> void:
	while get_child_count() < Logic.ballCount:
		var new_ball = ui_ball.instantiate()
		new_ball.position = Vector2(randf() * 1, randf() * 1)  # Randomize position
		add_child(new_ball)
	while get_child_count() > Logic.ballCount:
		remove_ball()

func remove_ball() -> void:
	if get_child_count() > 0:
		var lowest_ball = null
		for child in get_children():
			if lowest_ball == null or child.position.y > lowest_ball.position.y:
				lowest_ball = child
		if lowest_ball:
			remove_child(lowest_ball)

func _on_launcher_shoot_signal() -> void:
	shakeBalls()

	while get_child_count() < Logic.ballCount:
		var new_ball = ui_ball.instantiate()
		new_ball.position = Vector2(randf() * 1, randf() * 1)  # Randomize position
		add_child(new_ball)
	while get_child_count() > Logic.ballCount:
		remove_ball()

func shakeBalls():
	for ball in get_children():
		if ball is RigidBody2D:
			ball.linear_velocity += Vector2(randf() * 100 - 50, -(randf() * 100))

func addExtraBall() -> void:
	var new_ball = ui_ball.instantiate()
	new_ball.position = Vector2(randf() * 1, randf() * 1)  # Randomize position
	add_child(new_ball)
