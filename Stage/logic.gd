extends Node

var isBallInPlay: bool = false
var isGameOver: bool = false
var isGameStarted: bool = true

var redPegCount: int
var bluePegCount: int
var totalPegCount: int

var score: int = 0
var scoreMultiplier: int = 1
var ballCount: int = 10

func GameOver():
	isGameOver = true
	isGameStarted = false
	print("Game Over! No more balls left.")

