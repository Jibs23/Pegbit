class_name BluePeg
extends Peg

func _ready():
	pegCount = Logic.bluePegCount
	pegType = "blue"
	litColor = spriteSheetNr["blue_lit"]
	get_node("Sprite2D").set_frame(spriteSheetNr["blue"])
	add_to_group("PegBlue")

