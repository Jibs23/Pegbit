extends Area2D

signal bonusHoleEntered(value)

func _ready():
	connect("bonusHoleEntered", Callable(Logic, "_on_bonusHoleEntered"))

func _on_body_shape_entered(_body_id, _body, _body_shape, area_shape):
	var pointHole = self.shape_owner_get_owner(area_shape)
	if pointHole and pointHole.has_meta("ScoreValue") and pointHole.get_meta("ScoreValue") != 0:
		var value = pointHole.get_meta("ScoreValue")
		print("Entered point hole with value: ", value)
		emit_signal("bonusHoleEntered", value)
	else:
		print("Entered point hole without set 'ScoreValue' meta.")
