class_name Peg
extends StaticBody2D

var frameGrey: int = 0
var frameRed: int = 1
var frameBlue: int = 2

var isHit: bool = false
var sprite: Sprite2D

func _ready():
	sprite = $Sprite2D  
	if sprite == null:
		print("Error: Sprite2D node not found!")

func hit():
	isHit = true

	
