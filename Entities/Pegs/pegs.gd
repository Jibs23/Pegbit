extends Node2D

# Define the level requirement for red pegs

func _ready():
	var level = get_tree().get_nodes_in_group("level")[0]    
	var pegs = get_children()
	pegs.shuffle()
	var red_peg_requirement = level.redPegs	
	var red_pegs_assigned = 0
	var blue_pegs_assigned = 0

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

func callReady(peg):
	if peg.has_method("_ready"):
		peg._ready()
