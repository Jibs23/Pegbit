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
var scoreValue : int = 10

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

		Logic.score += scoreValue * Logic.scoreMultiplier
		var sfxNote = 1.0 + (min(pegs.pegsActivated, 15) * 0.083) # 0.083 approximates one semitone
		audio.playSoundEffect("SFXHitPeg").pitch_scale = sfxNote
		
		Ui.update_ui()
		removePeg()

func removePeg():
	if self is BluePeg:
		Logic.bluePegCount -= 1
		print("Blue Peg Removed! Remaining Blue Pegs: ", Logic.bluePegCount)
	elif self is RedPeg:
		Logic.redPegCount -= 1
		print("Red Peg Removed! Remaining Red Pegs: ", Logic.redPegCount)
		
		Logic.removedRedPegs += 1
		Logic.updateMultiplier()


	while Logic.isBallInPlay == true: # wait for the ball to NOT be in play
		await get_tree().process_frame

	# shrink animation
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.5)
	await tween.finished

	pegs.pegsActivated = 0

	# remove peg from the scene
	queue_free()
