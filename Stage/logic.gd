extends Node

var isBallInPlay: bool = false
var isGameOver: bool = false
var isGameStarted: bool = true

var redPegCount: int
var bluePegCount: int
var totalPegCount: int

var removedRedPegs: int = 0
var removedBluePegs: int = 0

var score: int = 0
var scoreMultiplier: int = 1
var ballCount: int

func GameOver():
	isGameOver = true
	isGameStarted = false
	print("Game Over! No more balls left.")

func updateMultiplier():
	# Adjust multiplier based on the number of red pegs remaining
	if removedRedPegs >= 25:
		scoreMultiplier = 10
		print("Multiplier: 10")
	elif removedRedPegs >= 15:
		scoreMultiplier = 5
		print("Multiplier: 5")
	elif removedRedPegs >= 10:
		scoreMultiplier = 3
		print("Multiplier: 3")
	elif removedRedPegs >= 6:
		scoreMultiplier = 2
		print("Multiplier: 2")
	elif removedRedPegs < 6:
		scoreMultiplier = 1
		print("Multiplier: 1")
	elif removedRedPegs >= redPegCount: # FEVER mode
		scoreMultiplier = 20
		print("Multiplier: 20")
	else:
		print("ERROR: Multiplier not set correctly")
	Ui.update_ui()
	
