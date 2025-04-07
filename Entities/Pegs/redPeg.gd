class_name RedPeg
extends Peg


func _ready():
	scoreValue = 100
	pegCount = Logic.redPegCount
	litColor = spriteSheetNr["red_lit"]
	get_node("Sprite2D").set_frame(spriteSheetNr["red"])
