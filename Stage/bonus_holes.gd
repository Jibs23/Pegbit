extends Node2D

func _init() -> void:
	Logic.bonusHoles = self

var active_position: Vector2
@export var inactive_position: Vector2 = Vector2(0, -25)

func _ready() -> void:
	active_position = self.position
	self.position = Vector2(self.position.x, self.position.y - inactive_position.y)

func show_bonus_holes() -> void:
	self.position = Vector2(self.position.x, active_position.y)

func hide_bonus_holes() -> void:
	self.position = Vector2(self.position.x, active_position.y - inactive_position.y)
