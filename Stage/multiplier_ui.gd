extends Node2D

var valueCount: Label
var mapIndicator: Node2D
var levelUi: Node2D


func _ready() -> void:
	levelUi = get_parent()
	Ui.uiMultiplierCounter = self
	mapIndicator = get_node("Map/Path2D/PathFollow2D")
	valueCount = get_node("Orb/Multiplier")
