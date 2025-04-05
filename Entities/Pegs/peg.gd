class_name Peg
extends StaticBody2D

var whiteFlashTime: int = 5

# PEG FRAMES
var spriteSheetNr: Dictionary = {
    "grey": 0,
    "red": 1,
    "blue": 2,
    "black": 3,
    "white": 7,
	
    "grey_lit": 4,
    "red_lit": 5,
    "blue_lit": 6
}

var litColor = spriteSheetNr["grey_lit"]

var isHit: bool = false
var sprite: Sprite2D

var pegCount: int

func _ready():
    sprite = $Sprite2D  
    if sprite == null:
        print("Error: Sprite2D node not found!")

func hit():
    if !isHit:
        isHit = true
        get_node("Sprite2D").set_frame(spriteSheetNr["white"])
        for number in range(whiteFlashTime):
            await get_tree().process_frame
        get_node("Sprite2D").set_frame(litColor)
        pegCount -= 1

func removePeg():
    if isHit:
        queue_free()

