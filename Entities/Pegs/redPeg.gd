class_name RedPeg
extends Peg

var pegIsLastRedPeg: bool = false
signal hitLastRedPeg

func _ready():
	connect("hitLastRedPeg", Callable(Logic, "_on_hitLastRedPeg"))
	pegCount = Logic.redPegCount
	pegType = "red"
	litColor = spriteSheetNr["red_lit"]
	get_node("Sprite2D").set_frame(spriteSheetNr["red"])
	add_to_group("PegRed")
	
	scoreValue = 100

func hit():
	if Logic.redPegCount == 2:
		Logic.isOneRedPegRemaining = true
		var redPegs = get_tree().get_nodes_in_group("PegRed")
		for peg in redPegs:
			if peg != self and peg is RedPeg:
				peg.pegIsLastRedPeg = true
				print("Last red peg ", peg.name)
	if pegIsLastRedPeg:
		emit_signal("hitLastRedPeg")
	super() # Call the parent hit method
