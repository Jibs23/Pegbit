extends Node2D

@export var rotation_speed: float = 1.0
@export var rotation_clockwise: bool = true # true for clockwise, false for counter-clockwise

func _physics_process(delta: float) -> void:
	rotation += rotation_speed * (1 if rotation_clockwise else -1) * delta