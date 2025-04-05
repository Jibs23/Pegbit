extends Node2D

func _on_child_order_changed() -> void:
	if get_children().size() > 0: # Check if there are any children
		Logic.isBallInPlay = true
	else: # if no children
		Logic.isBallInPlay = false
		Logic.ballCount -= 1
		Logic.prepNextShot()
