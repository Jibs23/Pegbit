extends Node2D

@onready var pegs : Node2D = get_tree().get_nodes_in_group("PegsGroup")[0]

func _ready() -> void:
	Logic.balls = self

func _on_child_order_changed() -> void:
	if get_children().size() > 0: # Check if there are any children
		Logic.isBallInPlay = true
	else: # if no children
		Logic.isBallInPlay = false

func _on_ball_end():
	Logic.score += Logic.ballScoreCounter
	Logic.ballScoreCounter = 0
	print("Score: " + str(Logic.score))
	Ui.update_ui()