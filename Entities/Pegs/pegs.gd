extends Node2D

# Define the level requirement for red pegs
var pegsActivated: int = 0
func _enter_tree() -> void:
	Logic.pegs = self

func _ready():
	var level = get_tree().get_nodes_in_group("level")[0]    
	var pegs = get_children()
	pegs.shuffle()
	var red_peg_requirement: int = level.levelRedPegs	
	var red_pegs_assigned: int = 0
	var blue_pegs_assigned: int = 0

	for peg in pegs:
		if red_pegs_assigned < red_peg_requirement:
			peg.set_script(preload("res://Entities/Pegs/redPeg.gd"))
			red_pegs_assigned += 1
			callReady(peg)
		else:
			peg.set_script(preload("res://Entities/Pegs/bluePeg.gd"))
			blue_pegs_assigned += 1
			callReady(peg)
	
	print("Red pegs: ", red_pegs_assigned)
	Logic.redPegCount = red_pegs_assigned

	print("blue pegs: ", blue_pegs_assigned)
	Logic.bluePegCount = blue_pegs_assigned

	print("Total pegs: ", len(pegs))
	Logic.totalPegCount = len(pegs)

func _on_hit_peg(peg):
	pegsActivated += 1
	Ui.update_ui()
	if peg.pegType == "red":
		var redPegs = get_tree().get_nodes_in_group("PegRed")
		var unhit_red_pegs = []
		for redPeg in redPegs:
			if redPeg is RedPeg and not redPeg.isHit:
				unhit_red_pegs.append(redPeg)
		if unhit_red_pegs.size() == 1:
			var last_peg = unhit_red_pegs[0]
			last_peg.pegIsLastRedPeg = true
			Logic.isOneRedPegRemaining = true
			print("Last red peg set: ", last_peg.name)


func callReady(peg):
	if peg.has_method("_ready"):
		peg._ready()
