extends Node

var ballsUI: Node2D
var launcher: Node2D
var balls: Node2D
var pegs: Node2D
var audio: Node2D
var level: Node2D

var isGameOver: bool = false
var isGameStarted: bool = true
var isBallInPlay: bool = false
var isBucketMove: bool = true

var redPegCount: int
var bluePegCount: int
var totalPegCount: int

var removedRedPegs: int = 0
var removedBluePegs: int = 0

var ballScoreCounter: int = 0
var score: int = 0
var scoreMultiplier: int = 1
var ballCount: int

func GameOver():
	isGameOver = true
	isGameStarted = false
	isBucketMove = false
	print("Game Over! No more balls left.")

func reset_level():
	var game_node = get_tree().get_nodes_in_group("Game")[0]
	game_node.queue_free() # Remove the current game node
	await get_tree().process_frame # Wait one frame to ensure it's freed

	var new_game = preload("res://Stage/game.tscn").instantiate()
	get_tree().root.add_child(new_game)

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


# Ball Score milestones for getting a free ball
const extraBall1: int = 25000
const extraBall2: int = 75000
const extraBall3: int = 125000

# Flags to check if extra balls have been obtained. Resets when ball ends.
var gotExtraBall1: bool = false
var gotExtraBall2: bool = false
var gotExtraBall3: bool = false

func _on_extra_ball_check():
	if ballScoreCounter < extraBall1:
		return
	elif ballScoreCounter >= extraBall1 and !gotExtraBall1:
		gotExtraBall1 = true
		addBall()
		print("Extra ball 1 added! "+ str(extraBall1))
	elif ballScoreCounter >= extraBall2 and !gotExtraBall2:
		gotExtraBall2 = true
		addBall()
		print("Extra ball 2 added! "+ str(extraBall2))
	elif ballScoreCounter >= extraBall3 and !gotExtraBall3:
		gotExtraBall3 = true
		addBall()
		print("Extra ball 3 added! "+ str(extraBall3))


func addBall():
	ballCount += 1
	Ui.update_ui()
	ballsUI.addExtraBall()
