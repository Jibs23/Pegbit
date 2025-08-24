extends Button


func _on_tree_entered() -> void:
	connect("pressed", Callable(get_parent().get_parent(), "_on_btn_next_level_pressed"))
