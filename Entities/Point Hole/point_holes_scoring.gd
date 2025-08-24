extends Area2D

signal bonusHoleEntered(value)

var scoredPointHole

func _ready():
	connect("bonusHoleEntered", Callable(Logic, "_on_bonusHoleEntered"))
	LevelsManager.connect("levelLoaded", Callable(self, "_on_level_loaded"))

func _on_body_shape_entered(_body_id, _body, _body_shape, area_shape):
	scoredPointHole = self.shape_owner_get_owner(area_shape)
	if scoredPointHole and scoredPointHole.has_meta("ScoreValue") and scoredPointHole.get_meta("ScoreValue") != 0:
		scoredPointHole.get_node("confetti").restart()		
		scoredPointHole.get_node("confetti").emitting = true
		scoredPointHole.activate_score_text()
		Logic.audio.playSoundEffect("SFXBallInBonusHole")
		var value = scoredPointHole.get_meta("ScoreValue")
		print("Entered point hole with value: ", value)
		emit_signal("bonusHoleEntered", value)
	else:
		print("Entered point hole without set 'ScoreValue' meta.")

func _on_level_loaded() -> void:
	#TODO: figure out why this is called twice
	print("Level loaded, resetting confetti.")
	if scoredPointHole:
		scoredPointHole.get_node("confetti").restart()
		scoredPointHole.get_node("confetti").emitting = false
