extends Node2D

@onready var pegs : Node2D = get_tree().get_nodes_in_group("PegsGroup")[0]

func _on_child_order_changed() -> void:
	if get_children().size() > 0: # Check if there are any children
		Logic.isBallInPlay = true
	else: # if no children
		Logic.isBallInPlay = false
		Logic.ballCount -= 1
		pegs.removeHitPegs()
