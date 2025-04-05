extends Node

var isBallInPlay: bool = false
var isGameOver: bool = false
var isGameStarted: bool = true

var redPegCount: int
var bluePegCount: int
var totalPegCount: int
var ballCount: int = 10

signal gameOver

func prepNextShot():
	if ballCount > 0:
		for peg in get_tree().get_nodes_in_group("Pegs"):
			peg.removePeg()
	else :
		isGameOver = true
		emit_signal("gameOver")
		print("Game Over! No more balls left.")
