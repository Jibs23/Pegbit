extends Node2D

# Define the level requirement for red pegs

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
			peg.add_to_group("PegRed")
			callReady(peg)
		else:
			peg.set_script(preload("res://Entities/Pegs/bluePeg.gd"))
			blue_pegs_assigned += 1
			peg.add_to_group("PegBlue")
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

func removeHitPegs():
	if Logic.ballCount > 0:
		for peg in get_children():
			if not peg is Peg: # Check if the peg is of type Peg
				print("Error: Peg class not found, for call removeHitPegs():" + peg.name)
				continue
			elif peg.isHit == false: # Check if the peg is hit
				continue
			peg.removePeg()
	else:
		Logic.GameOver()
