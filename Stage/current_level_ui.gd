extends Node2D

var valueCount: Label
var levelUi: Node2D

func _ready() -> void:
	levelUi = get_parent()
	Ui.uiCurrentLevel = self
	valueCount = $CurrentLevel

