extends CanvasLayer


func _enter_tree() -> void:
	Logic.ui_canvas = self
	var ui_container = get_child(0)
	Ui.uiBallsCounter = ui_container.get_node("Balls") as Label
	Ui.uiMultiplierCounter = ui_container.get_node("Multiplier") as Label
	Ui.uiScoreCounter = ui_container.get_node("Score") as Label
	Ui.uiScoreCounterBall = ui_container.get_node("BallScore") as Label
	print("UI Canvas initialized with nodes: ", Ui.uiBallsCounter, Ui.uiMultiplierCounter, Ui.uiScoreCounter, Ui.uiScoreCounterBall)
