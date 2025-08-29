extends Path2D


func _ready() -> void:
	get_node("PathFollow2D").reset_bucket()


