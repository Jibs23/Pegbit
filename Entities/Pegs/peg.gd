class_name Peg
extends StaticBody2D

@onready var audio: Node2D = Logic.audio
@onready var pegs: Node2D = Logic.pegs

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

var hitSFX: String = "SFXHitPeg"

signal extraBallCheck

func _ready():
	sprite = $Sprite2D  
	if sprite == null:
		print("Error: Sprite2D node not found!")
	connect("extraBallCheck", Callable(Logic, "_on_extra_ball_check"))

func hit():
	if !isHit:
		isHit = true
		get_node("Sprite2D").set_frame(spriteSheetNr["white"])		
		for number in range(whiteFlashTime):
			await get_tree().process_frame
		get_node("Sprite2D").set_frame(litColor)
		pegCount -= 1
		pegs.pegsActivated += 1

		Logic.ballScoreCounter += scoreValue * Logic.scoreMultiplier
		emit_signal("extraBallCheck")
			
		var sfxNote: float = 1.0 + (min(pegs.pegsActivated, 25) * 0.083) # 0.083 approximates one semitone
		audio.playSoundEffect(hitSFX).pitch_scale = sfxNote
		
		Ui.update_ui()
		removePeg()

func removePeg():
	if self is BluePeg:
		Logic.bluePegCount -= 1
	elif self is RedPeg:
		Logic.redPegCount -= 1
		
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

func _on_long_shot_bonus():
	hitSFX = "SFXHitPegLongShot"
	scoreValue = scoreValue * 3
