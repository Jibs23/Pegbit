extends Node
var uiBallsCounter
var uiScoreCounter
var uiMultiplierCounter
var uiScoreCounterBall

func _ready() -> void:
	find_ui_elements()
	update_ui()

func update_ui() -> void:
	var ui_elements = [
		[uiBallsCounter, "Balls: ", Logic.ballCount],
		[uiMultiplierCounter, "Multiplier: ", Logic.scoreMultiplier],
		[uiScoreCounter, "Score: ", Logic.score],
		[uiScoreCounterBall, "BallScore: ", Logic.ballScoreCounter]
	]
	for element in ui_elements:
		var label = element[0]
		var display_text = element[1]
		var value = element[2]
		if value == null:
			value = 0
			print("Warning: Value for " + display_text + " is null, setting to 0")
		if label:
			label.text = display_text + str(value)

func find_ui_elements() -> void:
	var ui_node = get_tree().get_nodes_in_group("UI")[0]
	uiBallsCounter = ui_node.get_node("VBoxContainer/Balls") as Label
	uiMultiplierCounter = ui_node.get_node("VBoxContainer/Multiplier") as Label
	uiScoreCounter = ui_node.get_node("VBoxContainer/Score") as Label
	uiScoreCounterBall = ui_node.get_node("VBoxContainer/BallScore") as Label
