class_name Peg
extends StaticBody2D

@onready var audio: Node2D = get_node("/root/Game/Audio")
@onready var pegs: Node2D = get_tree().get_nodes_in_group("PegsGroup")[0]

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
		pegs.pegsActivated += 1
		var sfxNote = 1.0 + (min(pegs.pegsActivated, 14) * 0.083) # 0.083 approximates one semitone

		audio.playSoundEffect("SFXHitPeg").pitch_scale = sfxNote

func removePeg():
	if self.get_class() == "RedPeg":
		Logic.redPegCount -= 1
	elif self.get_class() == "BluePeg":
		Logic.bluePegCount -= 1
	queue_free()
