class_name RedPeg
extends Peg

func _ready():
	pegCount = Logic.redPegCount
	litColor = spriteSheetNr["red_lit"]
	get_node("Sprite2D").set_frame(spriteSheetNr["red"])
	add_to_group("PegRed")
	
	scoreValue = 100